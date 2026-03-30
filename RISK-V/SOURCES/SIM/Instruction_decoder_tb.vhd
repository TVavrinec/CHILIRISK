----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2026 12:12:04 AM
-- Design Name: 
-- Module Name: Instruction_decoder_tb - Behavioral
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

entity Instruction_decoder_tb is
--  Port ( );
end Instruction_decoder_tb;

architecture Behavioral of Instruction_decoder_tb is

    COMPONENT Instruction_decoder is
        Port ( 
                instruct     : in STD_LOGIC_VECTOR (31 downto 0);
                imm          : out SIGNED(31 downto 0);
                jump_f       : out STD_LOGIC;
                branch_f     : out STD_LOGIC;
                funct_3      : out STD_LOGIC_VECTOR(2 downto 0);
                funct_7      : out STD_LOGIC_VECTOR(6 downto 0);
                rs1          : out UNSIGNED(4 downto 0);
                rs2          : out UNSIGNED(4 downto 0);
                rd           : out UNSIGNED(4 downto 0);
                instruct_typ : out STD_LOGIC_VECTOR(2 downto 0)
            );
    END COMPONENT  Instruction_decoder;

    CONSTANT clk_period           : TIME := 20 ns;

    SIGNAL instruct     : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL imm          : SIGNED(31 downto 0);
    SIGNAL jump_f       : STD_LOGIC;
    SIGNAL branch_f     : STD_LOGIC;
    SIGNAL funct_3      : STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL funct_7      : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL rs1          : UNSIGNED(4 downto 0);
    SIGNAL rs2          : UNSIGNED(4 downto 0);
    SIGNAL rd           : UNSIGNED(4 downto 0);
    SIGNAL instruct_typ : STD_LOGIC_VECTOR(2 downto 0);

begin

    Instruction_decoder_inst : Instruction_decoder
    PORT MAP ( 
            instruct     => instruct,
            imm          => imm,
            jump_f       => jump_f,
            branch_f     => branch_f,
            funct_3      => funct_3,
            funct_7      => funct_7,
            rs1          => rs1,
            rs2          => rs2,
            rd           => rd,
            instruct_typ => instruct_typ 
        );


    proc_stim : PROCESS
    BEGIN
    
        -- R
        instruct <=  "0000000" & "11101" & "00000" & "000" & "00101" & "0110011";
        WAIT FOR clk_period;
        instruct <=  "0000000" & "11110" & "01100" & "000" & "00110" & "0110011";
        WAIT FOR clk_period;
        instruct <=  "0000000" & "11111" & "01101" & "000" & "00111" & "0110011";
        WAIT FOR clk_period;

        -- Test all possible input values
        for i in 0 to 2**12 - 1 loop
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0000011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                report "Error - 101";
            end if;
            WAIT FOR clk_period/2;
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0010011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                report "Error - 107";
            end if;
            WAIT FOR clk_period/2;
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "1100111";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                report "Error - 113";
            end if;
            WAIT FOR clk_period/2;
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "1110011";
            WAIT FOR clk_period;
            if i /= to_integer(imm) then
                report "Error - 119";
            end if;
        end loop;

        wait for 10 ns;

        report "Test: OK";

        -- I
        WAIT FOR clk_period;
        instruct <=  "000000000001" & "00000" & "000" & "00101" & "0010011";
        WAIT FOR clk_period;
        instruct <=  "000000100000" & "01100" & "000" & "00110" & "0010011";
        WAIT FOR clk_period;
        instruct <=  "100000000000" & "01101" & "000" & "00111" & "0010011";

        -- I
        WAIT FOR clk_period;
        instruct <=  "000000000001" & "00000" & "000" & "00101" & "0000011";
        WAIT FOR clk_period;
        instruct <=  "000000100000" & "01100" & "000" & "00110" & "0000011";
        WAIT FOR clk_period;
        instruct <=  "100000000000" & "01101" & "000" & "00111" & "0000011";

        -- S
        WAIT FOR clk_period;
        instruct <=  "0000001" & "11101" & "00000" & "000" & "00101" & "0100011";
        WAIT FOR clk_period;
        instruct <=  "1000000" & "11110" & "01100" & "000" & "00110" & "0100011";
        WAIT FOR clk_period;
        instruct <=  "0000101" & "11111" & "01101" & "000" & "00111" & "0100011";

        -- B
        WAIT FOR clk_period;
        instruct <=  "0000001" & "11101" & "00000" & "000" & "00101" & "1100011";
        WAIT FOR clk_period;
        instruct <=  "1000000" & "11110" & "01100" & "000" & "00110" & "1100011";
        WAIT FOR clk_period;
        instruct <=  "0000101" & "11111" & "01101" & "000" & "00111" & "1100011";
        WAIT;
    END PROCESS proc_stim;

end Behavioral;
