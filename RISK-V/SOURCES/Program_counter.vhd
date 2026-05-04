----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2026 09:22:25 PM
-- Design Name: 
-- Module Name: Program_counter - Behavioral
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

entity Program_counter is
    Port ( 
            CLK         : in STD_LOGIC;
            CLK_EN      : in STD_LOGIC;
            JUMP_F      : in STD_LOGIC;
            RST         : in STD_LOGIC;
            PC_SET      : in UNSIGNED(31 downto 0);
            PC          : out UNSIGNED(31 downto 0)
        );
end Program_counter;

architecture Behavioral of Program_counter is

SIGNAL PC_internal : UNSIGNED(31 downto 0)  := (others => '0');
SIGNAL PC_internal_next : UNSIGNED(31 downto 0) := (others => '0');

begin

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF RST = '0' THEN
                PC_internal <= TO_UNSIGNED(0, 32);
            ELSIF CLK_EN = '1' THEN
                PC_internal <= PC_internal_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (PC_internal, PC_SET, JUMP_F)
    BEGIN
        PC_internal_next <= PC_internal + 4;
        PC <= PC_internal;
        IF JUMP_F = '1' THEN
            PC_internal_next <= PC_SET; 
        END IF;
    END PROCESS;

    

end Behavioral;
