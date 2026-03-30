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

library std;
use std.textio.all;

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
        variable error_count : integer;
        variable L : line;

        variable instruct_signed12 : signed(11 downto 0);
        variable instruct_signed20 : signed(19 downto 0);
    BEGIN
        error_count := 0;

        -- Test "all" possible options of R-type instruction
        for i in 0 to 2**7 - 1 loop
            instruct <= std_logic_vector(to_signed(i, 7)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0110011";
            WAIT FOR clk_period/2;
            if to_unsigned(i,7) /= unsigned(funct_7) then
                error_count := error_count+1;
                report "Error - funct_7: " & integer'image(to_integer(unsigned(funct_7)));
            end if;
            if to_unsigned(i,5)  /= rs2 then
                error_count := error_count+1;
                report "Error - rs2: " & integer'image(to_integer(rs2));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - R-typ, opcoude: 0110011";
        end if;
        error_count := 0;

        for i in 0 to 2**7 - 1 loop
            instruct <= std_logic_vector(to_signed(i, 7)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0101111";
            WAIT FOR clk_period/2;
            if to_unsigned(i,7) /= unsigned(funct_7) then
                error_count := error_count+1;
                report "Error - funct_7: " & integer'image(to_integer(unsigned(funct_7)));
            end if;
            if to_unsigned(i,5)  /= rs2 then
                error_count := error_count+1;
                report "Error - rs2: " & integer'image(to_integer(rs2));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - R-typ, opcoude: 0101111";
            report "Test: OK - R-typ";
        end if;
        error_count := 0;

        -- Test "all" possible options of I-type instruction
        for i in -2**11 to 2**11 - 1 loop
            instruct <= std_logic_vector(to_signed(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0000011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - I-typ, opcoude: 0000011";
        end if;
        error_count := 0;

        for i in -2**11 to 2**11 - 1 loop
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "0010011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - I-typ, opcoude: 0010011";
        end if;
        error_count := 0;
        
        for i in -2**11 to 2**11 - 1 loop
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "1100111";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - I-typ, opcoude: 1100111";
        end if;
        error_count := 0;
        
        for i in -2**11 to 2**11 - 1 loop
            instruct <= std_logic_vector(to_unsigned(i, 12)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(to_unsigned(i, 5)) & "1110011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            if to_unsigned(i,5) /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - I-typ, opcoude: 1110011";
            report "Test: OK - I-typ";
        end if;
        error_count := 0;

        -- Test "all" possible options of S-type instruction
        for i in -2**11 to 2**11 - 1 loop
            instruct_signed12 := to_signed(i, 12);
            instruct <= std_logic_vector(instruct_signed12(11 downto 5)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(instruct_signed12(4 downto 0)) & "0100011";
            WAIT FOR clk_period/2;
            if i /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs2 then
                error_count := error_count+1;
                report "Error - rs2: " & integer'image(to_integer(rs2));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - S-typ, opcoude: 0100011";
            report "Test: OK - S-typ";
        end if;
        error_count := 0;


        -- Test "all" possible options of B-type instruction
        for i in -2**10 to 2**10 - 1 loop
            instruct_signed12 := to_signed(i, 12);
            instruct <= "0" & std_logic_vector(instruct_signed12(9 downto 4)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 5)) & std_logic_vector(to_unsigned(i, 3)) & std_logic_vector(instruct_signed12(3 downto 0)) & instruct_signed12(10) & "1100011";
            WAIT FOR clk_period/2;
            if i*2 /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rs2 then
                error_count := error_count+1;
                report "Error - rs2: " & integer'image(to_integer(rs2));
            end if;
            if to_unsigned(i,5)  /= rs1 then
                error_count := error_count+1;
                report "Error - rs1: " & integer'image(to_integer(rs1));
            end if;
            if to_unsigned(i,3) /= unsigned(funct_3) then
                error_count := error_count+1;
                report "Error - funct_3: " & integer'image(to_integer(unsigned(funct_3)));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - B-typ, opcoude: 1100011";
        end if;
        error_count := 0;


        -- Test "all" possible options of U-type instruction
        for i in -2**20 to 2**20 - 1 loop
            instruct <= std_logic_vector(to_unsigned(i, 20)) & std_logic_vector(to_unsigned(i, 5)) & "0110111";
            WAIT FOR clk_period/2;
            if i*2**12 /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm decod: " & integer'image(to_integer(imm)) & " imm set:" & integer'image(i);
            end if;
            if to_unsigned(i,5)  /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - U-typ, opcoude: 0110111";
            report "Test: OK - U-typ";
        end if;
        error_count := 0;

        -- Test "all" possible options of J-type instruction
        for i in -2**19 to 2**19 - 1 loop
            instruct_signed20 := to_signed(i, 20);
            instruct <= instruct_signed20(19) & std_logic_vector(instruct_signed20(9 downto 0)) & instruct_signed20(10) & std_logic_vector(instruct_signed20(18 downto 11)) & std_logic_vector(to_unsigned(i, 5)) & "1101111";
            WAIT FOR clk_period/2;
            if i*2 /= to_integer(imm) then
                error_count := error_count+1;
                report "Error - imm: " & integer'image(to_integer(imm));
            end if;
            if to_unsigned(i,5)  /= rd then
                error_count := error_count+1;
                report "Error - rd: " & integer'image(to_integer(rd));
            end if;
            WAIT FOR clk_period/2;
        end loop;
        if error_count = 0 then
            report "Test: OK - J-typ, opcoude: 1101111";
            report "Test: OK - J-typ";
        end if;
        error_count := 0;


    END PROCESS proc_stim;

end Behavioral;
