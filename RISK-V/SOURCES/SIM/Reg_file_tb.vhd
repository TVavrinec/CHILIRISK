----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2026 02:56:33 PM
-- Design Name: 
-- Module Name: Reg_file_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_file_tb is
end Reg_file_tb;

architecture Behavioral of Reg_file_tb is

    COMPONENT Reg_file is
        Port (
                REG_WRITE_EN : in STD_LOGIC;
                REG_RST      : in STD_LOGIC;
                READ_REG1    : in UNSIGNED (4 downto 0);
                READ_REG2    : in UNSIGNED (4 downto 0);
                WRITE_REG    : in UNSIGNED (4 downto 0);
                WRITE_DATA   : in SIGNED  (31 downto 0);
                DATA_RED1    : out SIGNED (31 downto 0);
                DATA_RED2    : out SIGNED (31 downto 0)
            );
    end COMPONENT Reg_file;


        
    CONSTANT clk_period           : TIME := 20 ns;

    SIGNAL simulation_finished    : BOOLEAN := FALSE;

    SIGNAL REG_WRITE_EN  : STD_LOGIC := '0';
    SIGNAL REG_RST       : STD_LOGIC := '0';
    SIGNAL READ_REG1     : UNSIGNED(4 downto 0) := (others => '0');
    SIGNAL READ_REG2     : UNSIGNED(4 downto 0) := (others => '0');
    SIGNAL WRITE_REG     : UNSIGNED(4 downto 0) := (others => '0');
    SIGNAL WRITE_DATA    : SIGNED(31 downto 0) := (others => '0');
    SIGNAL DATA_RED1     : SIGNED(31 downto 0) := (others => '0');
    SIGNAL DATA_RED2     : SIGNED(31 downto 0) := (others => '0');

begin

    Reg_file_inst: Reg_file
    PORT MAP (
            REG_WRITE_EN => REG_WRITE_EN ,
            REG_RST      => REG_RST      ,
            READ_REG1    => READ_REG1    ,
            READ_REG2    => READ_REG2    ,
            WRITE_REG    => WRITE_REG    ,
            WRITE_DATA   => WRITE_DATA   ,
            DATA_RED1    => DATA_RED1    ,
            DATA_RED2    => DATA_RED2    
        );

    proc_stim : PROCESS
    BEGIN
        REG_RST  <= '1';
        WAIT FOR clk_period;
        REG_RST  <= '0';
            -- REG_WRITE_EN : in STD_LOGIC;
            -- REG_RST      : in STD_LOGIC;
            -- READ_REG1    : in UNSIGNED (4 downto 0);
            -- READ_REG2    : in UNSIGNED (4 downto 0);
            -- WRITE_REG    : in UNSIGNED (4 downto 0);
            -- WRITE_DATA   : in SIGNED  (31 downto 0);    
        for i in 0 to 31 loop
            READ_REG1 <= to_unsigned(i,5);    
            READ_REG2 <= to_unsigned(31-i,5);
            WAIT FOR clk_period;
        end loop;
        
        WAIT FOR clk_period;
        
        REG_WRITE_EN <= '1';
        for i in 0 to 31 loop
            READ_REG1 <= to_unsigned(i,5);
            READ_REG2 <= to_unsigned(31-i,5);
            WRITE_REG <= to_unsigned(i,5);
            WRITE_DATA <= to_signed(i*134217728,32);
            WAIT FOR clk_period;
        end loop;
        REG_WRITE_EN <= '0';

        WAIT;
    END PROCESS proc_stim;
            
end Behavioral;
