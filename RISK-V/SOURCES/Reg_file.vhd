----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2026 01:43:27 PM
-- Design Name: 
-- Module Name: Reg_file - Behavioral
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

entity Reg_file is
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
end Reg_file;

architecture Behavioral of Reg_file is

type t_vector is array (0 to 31) of SIGNED(31 downto 0); 

SIGNAL regs : t_vector;

begin

PROCESS (REG_WRITE_EN, REG_RST, WRITE_REG, WRITE_DATA) begin
    regs(0) <= to_signed(0, 32);

    IF REG_RST = '0' then
        for n in 1 to 31 loop
            regs(n) <= to_signed(0, 32);
        end loop;
    ELSIF REG_WRITE_EN = '1' then
        regs(to_integer(WRITE_REG)) <= WRITE_DATA;
    END IF;

END PROCESS;

DATA_RED1 <= regs(to_integer(READ_REG1));
DATA_RED2 <= regs(to_integer(READ_REG2));


end Behavioral;
