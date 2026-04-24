----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2026 08:39:52 AM
-- Design Name: 
-- Module Name: RP_TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RP_TOP is
    Port ( 
        CLK : in STD_LOGIC,
        RST : in STD_LOGIC
        );
end RP_TOP;

architecture Behavioral of RP_TOP is

    COMPONENT ce_gen
    GENERIC (
        G_DIV_FACT          : POSITIVE := 2
    );
    PORT (
        CLK                 : IN  STD_LOGIC;
        CE                  : IN  STD_LOGIC;
        SRST                : IN  STD_LOGIC;
        CE_O                : OUT STD_LOGIC 
    );
    END COMPONENT ce_gen;

    COMPONENT top_alu is
	generic(
		DATA_WIDTH	: positive := 32
	);
	port(
		o_dout_DEBUG	: out	std_logic_vector(DATA_WIDTH-1 downto 0);
		o_pc_DEBUG		: out	std_logic_vector(DATA_WIDTH-1 downto 0);

		i_gclk		: in	std_logic;
		i_ce		: in	std_logic;

		i_sel_a		: in	std_logic;						-- select pin for reg 1
		--i_branch	: in	std_logic;						-- r w branching?
		i_jump		: in	std_logic;						-- r w jumping?
		i_funct3	: in	std_logic_vector(2 downto 0);	-- funct3
		i_funct7	: in	std_logic_vector(6 downto 0);	-- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
		i_inst_type	: in	std_logic_vector(2 downto 0);	-- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

		i_din0		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 0
		i_din1		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 1
		i_imm		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- immediate
		i_pc		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- program counter
		
		o_dout		: out	std_logic_vector(DATA_WIDTH-1 downto 0); -- data out
		o_pc		: out	std_logic_vector(DATA_WIDTH-1 downto 0)  -- program counter
	);
    END COMPONENT top_alu;


    COMPONENT Reg_file is
    Port ( 
            -- CLK          : in STD_LOGIC;
            REG_WRITE_EN : in STD_LOGIC;
            REG_RST      : in STD_LOGIC;
            READ_REG1    : in UNSIGNED (4 downto 0);
            READ_REG2    : in UNSIGNED (4 downto 0);
            WRITE_REG    : in UNSIGNED (4 downto 0);
            WRITE_DATA   : in SIGNED  (31 downto 0);
            
            DATA_RED1    : out SIGNED (31 downto 0);
            DATA_RED2    : out SIGNED (31 downto 0)
        );
    END COMPONENT Reg_file;
    
    COMPONENT Program_counter is
    Port ( 
            CLK         : in STD_LOGIC;
            CLK_EN      : in STD_LOGIC;
            JUMP_F      : in STD_LOGIC;
            RST         : in STD_LOGIC;
            PC_JUMP     : in SIGNED(31 downto 0);
            PC          : out UNSIGNED(31 downto 0);
            PC_NEXT     : out UNSIGNED(31 downto 0)
        );
    END COMPONENT Program_counter;

    COMPONENT Instruction_decoder is
    Port ( 
            instruct            : in STD_LOGIC_VECTOR (31 downto 0);

            instruct_typ        : out STD_LOGIC_VECTOR(2 downto 0);            
            funct_3             : out STD_LOGIC_VECTOR(2 downto 0);
            funct_7             : out STD_LOGIC_VECTOR(6 downto 0);

            jump_f              : out STD_LOGIC;
            PC_adding_f         : out STD_LOGIC;
            memory_use_f        : out STD_LOGIC;

            bite_cound_memory   : out STD_LOGIC_VECTOR(1 downto 0);
            bite_type_memory    : out STD_LOGIC; -- 0 for unsigned, 1 for signed

            rs1                 : out UNSIGNED(4 downto 0);
            rs2                 : out UNSIGNED(4 downto 0);
            rd                  : out UNSIGNED(4 downto 0);
            
            imm                 : out SIGNED(31 downto 0)
        );
    END COMPONENT Instruction_decoder;

    COMPONENT Instruction_Cache is
    Port ( 
            --INPUTS
            clk     : in STD_LOGIC;
            w_en    : in STD_LOGIC;
            addr    : in STD_LOGIC_VECTOR (31 downto 0);
            w_data  : in STD_LOGIC_VECTOR (31 downto 0);
           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (31 downto 0)
        );
           
    END COMPONENT Instruction_Cache;

    COMPONENT Data_memory is
    Port ( 
           --INPUTS
           clk : in STD_LOGIC;
           w_en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           w_data : in STD_LOGIC_VECTOR (31 downto 0);

           RW_Size : in STD_LOGIC_VECTOR (1 downto 0);
           UnSi_flag: in STD_LOGIC;

           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (31 downto 0));
           
    END COMPONENT Data_memory;

    SIGNAL CLK_B : STD_LOGIC;

    -- INSTRUCTION SIGNALS
    SIGNAL instruct             : STD_LOGIC_VECTOR (31 downto 0);

    SIGNAL instruct_typ        : STD_LOGIC_VECTOR(2 downto 0);            
    SIGNAL funct_3             : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL funct_7             : STD_LOGIC_VECTOR(6 downto 0);

    -- FLAGS
    SIGNAL jump_f              : STD_LOGIC;
    SIGNAL PC_adding_f         : STD_LOGIC;
    SIGNAL memory_use_f        : STD_LOGIC;

    -- CONTROL SIGNALS FOR MEMORY
    SIGNAL bite_cound_memory   : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL bite_type_memory    : STD_LOGIC; -- 0 for unsigned, 1 for signed

    -- REGISTERS SIGNALS
    SIGNAL rs1_addr                 : UNSIGNED(4 downto 0);
    SIGNAL rs2_addr                 : UNSIGNED(4 downto 0);
    SIGNAL rd_addr                  : UNSIGNED(4 downto 0);

    SIGNAL rs1_value                : UNSIGNED(31 downto 0);
    SIGNAL rs2_value                : UNSIGNED(31 downto 0);
    SIGNAL rd_value                 : UNSIGNED(31 downto 0);
    
    -- IMMEDIATE SIGNAL
    SIGNAL imm                 : SIGNED(31 downto 0)

    -- PROGRAM COUNTER SIGNALS
    SIGNAL PC_JUMP             : SIGNED(31 downto 0);
    SIGNAL PC                  : UNSIGNED(31 downto 0);
    SIGNAL PC_NEXT             : UNSIGNED(31 downto 0);

begin ------------------------------------ Behavioral description of RP_TOP ------------------------------------ 

    ce_gen_inst : ce_gen
    GENERIC (
            G_DIV_FACT          : POSITIVE := 10
        );
    PORT (
            CLK                 : CLK,
            CE                  : '1',
            SRST                : '0',
            CE_O                : CLK_B 
        );

    ALU_inst : top_alu
	generic(
            DATA_WIDTH	: positive := 32
        );
	port(
            -- o_dout_DEBUG	: out	std_logic_vector(DATA_WIDTH-1 downto 0);
            -- o_pc_DEBUG		: out	std_logic_vector(DATA_WIDTH-1 downto 0);

            i_gclk		=> CLK,
            i_ce		=> CLK_B,

            i_sel_a		=> in	std_logic;  -- select pin for reg 1
            --i_branch	=> in	std_logic;  -- r w branching?
            i_jump		=> jump_f,          -- r w jumping?
            i_funct3	=> funct_3,         -- funct3
            i_funct7	=> funct_7,         -- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
            i_inst_type	=> instruct_typ,    -- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

            i_din0		=> rs1_value,   -- data in 0
            i_din1		=> rs2_value,   -- data in 1
            i_imm		=> imm,         -- immediate
            i_pc		=> PC,          -- program counter
            
            o_dout		=> rd_value,    -- data out
            o_pc		=> PC_JUMP      -- program counter
        );

    Reg_file_inst : Reg_file
    Port ( 
            -- CLK          : in STD_LOGIC;
            REG_WRITE_EN : in STD_LOGIC;
            REG_RST      : RST,
            READ_REG1    : rs1_addr,
            READ_REG2    : rs2_addr,
            WRITE_REG    : rd_addr,
            WRITE_DATA   : rd_value,
            
            DATA_RED1    : rs1_value,
            DATA_RED2    : rs2_value
        );
    
    Program_counter_inst : Program_counter
    Port ( 
            CLK         => CLK,
            CLK_EN      => CLK_B,
            JUMP_F      => jump_f,
            RST         => RST,
            PC_JUMP     => PC_JUMP,
            PC          => PC,
            PC_NEXT     => PC_NEXT
        );

    Instruction_decoder_inst : Instruction_decoder
    Port ( 
            instruct            => instruct,

            instruct_typ        => instruct_typ,            
            funct_3             => funct_3,
            funct_7             => funct_7,

            jump_f              => jump_f,
            PC_adding_f         => PC_adding_f,
            memory_use_f        => memory_use_f,

            bite_cound_memory   => bite_cound_memory,
            bite_type_memory    => bite_type_memory, -- 0 for unsigned, 1 for signed

            rs1                 => rs1,
            rs2                 => rs2,
            rd                  => rd,
            
            imm                 => imm
        );

    Instruction_Cache_inst : Instruction_Cache
    Port ( 
           --INPUTS
            clk     => CLK,
            w_en    => '0',            -- potenciálně do budoucna -> NOT RST and nějakej signál z prográmátoru,
            addr    => PC,
            w_data  => (others => '0'), -- potenciálně do budoucna -> signál z prográmátoru,
           
           --OUTPUTS
           r_data => instruct
        );

    Data_memory_inst : Data_memory
    Port ( 
           --INPUTS
           clk      : CLK;
           w_en     : in STD_LOGIC;
           addr     : in STD_LOGIC_VECTOR (31 downto 0);
           w_data   : in STD_LOGIC_VECTOR (31 downto 0);

           RW_Size   => bite_cound_memory,
           UnSi_flag => bite_type_memory,

           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (31 downto 0)
        );
        

end Behavioral;
