----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2026 09:28:39 PM
-- Design Name: 
-- Module Name: Instruction_decoder - Behavioral
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

entity Instruction_decoder is
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
end Instruction_decoder;


architecture Behavioral of Instruction_decoder is

    constant R : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant I : STD_LOGIC_VECTOR(2 downto 0) := "001"; 
    constant S : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant B : STD_LOGIC_VECTOR(2 downto 0) := "011"; 
    constant U : STD_LOGIC_VECTOR(2 downto 0) := "100"; 
    constant J : STD_LOGIC_VECTOR(2 downto 0) := "101";

    -- bite_type_memory definitions
    constant UNSIGNED_F : STD_LOGIC := '0';
    constant SIGNET_F   : STD_LOGIC := '1';


begin

    PROCESS (instruct) begin
        CASE instruct(6 downto 0) is
            when "0110011" =>
                instruct_typ <= R;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= instruct(31 downto 25);                
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= to_signed(0, 32);
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed
            when "0101111" =>
                instruct_typ <= R;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= instruct(31 downto 25);
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= to_signed(0, 32);
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed

            when "0000011" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '1';
                mem_write_f <= '0';
                bite_cound_memory <= instruct(13 downto 12);
                bite_type_memory <= not instruct(14); -- 0 for unsigned, 1 for signed
            when "0010011" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed           
            when "1100111" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '1';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed
            when "1110011" =>  -- ???
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '1'; -- ???
                reg_write_f <= '1';
                mem_read_f <= '0'; -- ???
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed


            when "0100011" =>
                instruct_typ <= S;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 25) & instruct(11 downto 7));
                jump_f <= '0';
                reg_write_f <= '0';
                mem_read_f <= '0';
                mem_write_f <= '1';
                bite_cound_memory <= instruct(13 downto 12);
                bite_type_memory <= not instruct(14); -- 0 for unsigned, 1 for signed


            when "1100011" =>
                instruct_typ <= B;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= resize(signed(instruct(7) & instruct(30 downto 25) & instruct(11 downto 8) & '0'), imm'length);
                jump_f <= '0';
                reg_write_f <= '0';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed


            when "0110111" =>
                instruct_typ <= U;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7));
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= signed(instruct(31 downto 12) & (11 downto 0 => '0'));
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed
            when "0010111" =>
                instruct_typ <= U;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7));
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= signed(instruct(31 downto 12) & (11 downto 0 => '0'));
                jump_f <= '0';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed

            when "1101111" =>
                instruct_typ <= J;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= resize(signed(instruct(31) & instruct(19 downto 12) & instruct(20) & instruct(30 downto 21) & '0'), imm'length);
                jump_f <= '1';
                reg_write_f <= '1';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed
            
            when others =>
                instruct_typ <= R;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= to_signed(0, 32);
                jump_f <= '0';
                reg_write_f <= '0';
                mem_read_f <= '0';
                mem_write_f <= '0';
                bite_cound_memory <= "00"; -- not used
                bite_type_memory  <= UNSIGNED_F; -- 0 for unsigned, 1 for signed

      END CASE; 
    END PROCESS;
end Behavioral;
