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
end Instruction_decoder;


architecture Behavioral of Instruction_decoder is

    constant R : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant I : STD_LOGIC_VECTOR(2 downto 0) := "001"; 
    constant S : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant B : STD_LOGIC_VECTOR(2 downto 0) := "011"; 
    constant U : STD_LOGIC_VECTOR(2 downto 0) := "100"; 
    constant J : STD_LOGIC_VECTOR(2 downto 0) := "101";

    SIGNAL opcode : STD_LOGIC_VECTOR (6 downto 0);

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
                branch_f <= '0';
            when "0101111" =>
                instruct_typ <= R;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= instruct(31 downto 25);
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= to_signed(0, 32);
                jump_f <= '0';
                branch_f <= '1';

            when "0000011" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '0';
                branch_f <= '0';
            when "0010011" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '0';
                branch_f <= '0';
            when "1100111" =>
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '1';
                branch_f <= '0';
            when "1110011" =>  -- ???
                instruct_typ <= I;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= to_unsigned(0, 5);
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 20));
                jump_f <= '1'; -- ???
                branch_f <= '0';

            when "0100011" =>
                instruct_typ <= S;
                rd  <= to_unsigned(0, 5);
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= signed((31 downto 12 => instruct(31)) & instruct(31 downto 25) & instruct(11 downto 7));
                jump_f <= '0';
                branch_f <= '0';

            when "1100011" =>
                instruct_typ <= B;
                funct_3 <= instruct(14 downto 12);
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= resize(signed(instruct(7) & instruct(30 downto 25) & instruct(11 downto 8) & '0'), imm'length);
                jump_f <= '0';
                branch_f <= '1';

            when "0110111" =>
                instruct_typ <= U;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= unsigned(instruct(19 downto 15));
                rs2 <= unsigned(instruct(24 downto 20));
                imm <= resize(signed(instruct(31 downto 12)) & to_signed(0, 12), imm'length);
                jump_f <= '0';
                branch_f <= '0';

            when "1101111" =>
                instruct_typ <= J;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= unsigned(instruct(11 downto 7 ));
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= resize(signed(instruct(31) & instruct(19 downto 12) & instruct(20) & instruct(30 downto 25) & '0'), imm'length);
                jump_f <= '1';
                branch_f <= '0';
            
            when others =>
                instruct_typ <= R;
                funct_3 <= (others => '0');
                funct_7 <= (others => '0');
                rd  <= to_unsigned(0, 5);
                rs1 <= to_unsigned(0, 5);
                rs2 <= to_unsigned(0, 5);
                imm <= to_signed(0, 32);
                jump_f <= '0';
                branch_f <= '0';

      END CASE; 
    END PROCESS;
end Behavioral;
