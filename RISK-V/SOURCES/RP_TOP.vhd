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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RP_TOP is
    Port ( 
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;

            sw : IN STD_LOGIC_VECTOR (15 downto 0);

		    DISP_SEG    : out STD_LOGIC_VECTOR (7 DOWNTO 0);
		    DISP_DIG    : out STD_LOGIC_VECTOR (3 DOWNTO 0);
            led : out STD_LOGIC_VECTOR (15 downto 0)
        );
end RP_TOP;

architecture Behavioral of RP_TOP is

    component top_7seg_driver is
        generic(
            GCLK_FREQ	: positive  := 100e6;
            ANODE_FREQ	: positive  := 100;
            DOT_POINT	: std_logic := '1'
        );
        port(
            i_gclk		: in	std_logic;
            i_dig_1		: in	std_logic_vector(3 downto 0);
            i_dig_2		: in	std_logic_vector(3 downto 0);
            i_dig_3		: in	std_logic_vector(3 downto 0);
            i_dig_4		: in	std_logic_vector(3 downto 0);

            o_segments	: out	std_logic_vector(7 downto 0);
            o_anode		: out	std_logic_vector(3 downto 0)
        );
    end component top_7seg_driver;

    COMPONENT ce_gen
    GENERIC (
        G_DIV_FACT          : POSITIVE := 5
    );
    PORT (
        CLK                 : IN  STD_LOGIC;
        CE                  : IN  STD_LOGIC;
        SRST                : IN  STD_LOGIC;
        CE_O                : OUT STD_LOGIC 
    );
    END COMPONENT ce_gen;

    COMPONENT top_alu_async is
	generic(
		DATA_WIDTH	: positive := 32
	);
	port(
		i_jump		: in	std_logic;						-- r w jumping?
		i_u_type	: in 	std_logic;						-- type of U instruction
		i_load		: in 	std_logic;						-- load operations with imm
		i_funct3	: in	std_logic_vector(2 downto 0);	-- funct3
		i_funct7	: in	std_logic_vector(6 downto 0);	-- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
		i_inst_type	: in	std_logic_vector(2 downto 0);	-- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

		i_din0		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 0
		i_din1		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 1
		i_imm		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- immediate
		i_pc		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- program counter
		
		o_dout		: out	std_logic_vector(DATA_WIDTH-1 downto 0);	 -- data out
		o_pc		: out	std_logic_vector(DATA_WIDTH-1 downto 0);	 -- program counter
		o_addr		: out	std_logic_vector(DATA_WIDTH-1 downto 0)
	);
    END COMPONENT top_alu_async;


    COMPONENT Reg_file is
    Port ( 
            CLK          : in STD_LOGIC;
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
       
    component clk_wiz_0
    port(-- Clock in ports
        -- Clock out ports
        clk_out1          : out    std_logic;
        -- Status and control signals
        reset             : in     std_logic;
        locked            : out    std_logic;
        clk_in1           : in     std_logic
        );
    end component;
    
    
    COMPONENT Instruction_decoder is
    Port ( 
            instruct            : in STD_LOGIC_VECTOR (31 downto 0);

            instruct_typ        : out STD_LOGIC_VECTOR(2 downto 0);            
            funct_3             : out STD_LOGIC_VECTOR(2 downto 0);
            funct_7             : out STD_LOGIC_VECTOR(6 downto 0);

            jump_f              : out STD_LOGIC;
            reg_write_f         : out STD_LOGIC;
            mem_read_f          : out STD_LOGIC;
            mem_write_f         : out STD_LOGIC;

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
            CLK     : in STD_LOGIC;
            CLK_EN  : in STD_LOGIC;
            
            w_en    : in STD_LOGIC;
            w_data  : in STD_LOGIC_VECTOR (31 downto 0);
           
            JUMP_F  : in STD_LOGIC;
            PC_RST     : in STD_LOGIC;
            PC_SET  : in UNSIGNED(31 downto 0);
            
            --OUTPUTS
            PC      : out UNSIGNED(31 downto 0);
            r_data  : out STD_LOGIC_VECTOR (31 downto 0)
        );
           
    END COMPONENT Instruction_Cache;

    COMPONENT Data_memory is
    Port ( 
           --INPUTS
           clk       : in STD_LOGIC;
           w_en      : in STD_LOGIC;
           addr      : in STD_LOGIC_VECTOR (31 downto 0);
           w_data    : in STD_LOGIC_VECTOR (31 downto 0);

           RW_Size   : in STD_LOGIC_VECTOR (1 downto 0);
           UnSi_flag : in STD_LOGIC;

           pin_in    : in STD_LOGIC_VECTOR (15 downto 0);

           --OUTPUTS
           r_data   : out STD_LOGIC_VECTOR (31 downto 0);
           pin_out  : out STD_LOGIC_VECTOR (15 downto 0);
           disp_out : out STD_LOGIC_VECTOR (15 downto 0)
        );
           
    END COMPONENT Data_memory;

    -- signals for the 7seg display
	SIGNAL w_dig_1	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL w_dig_2	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL w_dig_3	: STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL w_dig_4	: STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL CLK_B : STD_LOGIC := '1';
    SIGNAL clk_sig: STD_LOGIC;

    -- INSTRUCTION SIGNALS
    SIGNAL instruct             : STD_LOGIC_VECTOR (31 downto 0);

    SIGNAL instruct_typ        : STD_LOGIC_VECTOR(2 downto 0);            
    SIGNAL funct_3             : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL funct_7             : STD_LOGIC_VECTOR(6 downto 0);

    -- FLAGS
    SIGNAL jump_f              : STD_LOGIC;
    SIGNAL reg_write_f         : STD_LOGIC;
    SIGNAL mem_read_f          : STD_LOGIC;
    SIGNAL mem_write_f         : STD_LOGIC;

    -- CONTROL SIGNALS FOR MEMORY
    SIGNAL bite_cound_memory   : STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL bite_type_memory    : STD_LOGIC; -- 0 for unsigned, 1 for signed
    
    SIGNAL ADDR_MEM            : STD_LOGIC_VECTOR(31 downto 0);
    
    SIGNAL memory_data_out     : STD_LOGIC_VECTOR(31 downto 0);
    
    -- PROGRAM COUNTER SIGNALS
    SIGNAL PC_SET              : UNSIGNED(31 downto 0);
    SIGNAL PC                  : UNSIGNED(31 downto 0);
    --SIGNAL PC_NEXT             : UNSIGNED(31 downto 0);
    
    -- IMMEDIATE SIGNAL
    SIGNAL imm                 : SIGNED(31 downto 0);
    
    -- REGISTERS SIGNALS
    SIGNAL rs1_addr                 : UNSIGNED(4 downto 0);
    SIGNAL rs2_addr                 : UNSIGNED(4 downto 0);
    SIGNAL rd_addr                  : UNSIGNED(4 downto 0);

    SIGNAL rs1_value                : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL rs2_value                : STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL rd_value                 : STD_LOGIC_VECTOR(31 downto 0);
        
    
        -- Non Components Signals
        SIGNAL NCS_rd_value             : SIGNED(31 downto 0);
    

begin ------------------------------------ Behavioral description of RP_TOP ------------------------------------ 

    CLK_GEN_50MHZ_COMP : clk_wiz_0
    port map ( 
        -- Clock out ports  
        clk_out1 => clk_sig,
        -- Status and control signals                
        reset => '1',
        locked => open,
        -- Clock in ports
        clk_in1 => CLK
    );
    -- clk_sig <= CLK; --CLK pro simulaci

    seg_disp_driver_inst : top_7seg_driver
    generic map(
		GCLK_FREQ	=> 100e6,
		ANODE_FREQ	=> 100,
		DOT_POINT	=> '1'
	)
	port map(
		i_gclk		=> CLK,
		i_dig_1		=> w_dig_1,
		i_dig_2		=> w_dig_2,
		i_dig_3		=> w_dig_3,
		i_dig_4		=> w_dig_4,
		o_segments	=> DISP_SEG,
		o_anode		=> DISP_DIG 
	);
    


    ce_gen_inst : ce_gen
    generic map (
            G_DIV_FACT => 1
        )
    port map (
            CLK     => clk_sig,
            CE      => '1',
            SRST    => '0',
            CE_O    => CLK_B 
        );

    top_alu_async_inst : top_alu_async
	generic map(
            DATA_WIDTH	=> 32
        )
	port map(
            i_jump		=> jump_f,              -- r w jumping?
            i_u_type	=> bite_type_memory,	-- type of U instruction
            i_load		=> mem_read_f,		    -- load operations with imm
            i_funct3	=> funct_3,             -- funct3
            i_funct7	=> funct_7,             -- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
            i_inst_type	=> instruct_typ,        -- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

            i_din0		=> STD_LOGIC_VECTOR(rs1_value),   -- data in 0
            i_din1		=> STD_LOGIC_VECTOR(rs2_value),   -- data in 1
            i_imm		=> STD_LOGIC_VECTOR(imm),         -- immediate
            i_pc		=> STD_LOGIC_VECTOR(PC),          -- program counter
            
            o_dout		    => rd_value,    -- data out
            UNSIGNED(o_pc)  => PC_SET,      -- program counter
            o_addr          => ADDR_MEM
        );

    Reg_file_inst : Reg_file
    port map ( 
            CLK          => clk_sig,
            REG_WRITE_EN => reg_write_f,
            REG_RST      => RST,
            READ_REG1    => rs1_addr,
            READ_REG2    => rs2_addr,
            WRITE_REG    => rd_addr,
            WRITE_DATA   => NCS_rd_value,
            
            SIGNED(DATA_RED1)    => rs1_value,
            SIGNED(DATA_RED2)    => rs2_value
        );

    Instruction_decoder_inst : Instruction_decoder
    port map ( 
            instruct            => instruct,

            instruct_typ        => instruct_typ,
            funct_3             => funct_3,
            funct_7             => funct_7,

            jump_f              => jump_f,
            mem_read_f          => mem_read_f,
            reg_write_f         => reg_write_f,
            mem_write_f         => mem_write_f,
            
            bite_cound_memory   => bite_cound_memory,
            bite_type_memory    => bite_type_memory, -- 0 for unsigned, 1 for signed

            UNSIGNED(rs1)       => rs1_addr,
            UNSIGNED(rs2)       => rs2_addr,
            UNSIGNED(rd)        => rd_addr,
            
            imm                 => imm
        );

    Instruction_Cache_inst : Instruction_Cache
    port map ( 
           --INPUTS
           CLK     => clk_sig,
           CLK_EN  => CLK_B,
           
           w_en    => '0',            -- potenciálně do budoucna -> NOT RST and nějakej signál z prográmátoru,
           w_data  => (others => '0'), -- potenciálně do budoucna -> signál z prográmátoru,
           
           JUMP_F  => jump_f,
           PC_RST  => RST,
           PC_SET  => PC_SET,
           
           --OUTPUTS
           PC     => PC,
           r_data => instruct
        );

    Data_memory_inst : Data_memory
    port map ( 
           --INPUTS
           clk      => clk_sig,
           w_en     => mem_write_f,
           addr     => ADDR_MEM,
           w_data   => STD_LOGIC_VECTOR(rd_value),

           RW_Size   => bite_cound_memory,
           UnSi_flag => bite_type_memory,
           
           pin_in    => sw,
           
           --OUTPUTS
           r_data   => memory_data_out,
           pin_out  => led,
           disp_out(03 downto 00) => w_dig_1,
           disp_out(07 downto 04) => w_dig_2,
           disp_out(11 downto 08) => w_dig_3,
           disp_out(15 downto 12) => w_dig_4
        );
      
      

    process (rd_value, mem_read_f, memory_data_out) is
    begin
        if mem_read_f = '1' then
            NCS_rd_value <= signed(memory_data_out);
        else
            NCS_rd_value <= signed(rd_value);
        end if;
    end process;

end Behavioral;
