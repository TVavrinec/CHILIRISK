----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2026 10:00:52 PM
-- Design Name: 
-- Module Name: Program_counter_tb - Behavioral
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
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY Program_counter_tb IS
END Program_counter_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF Program_counter_tb IS
----------------------------------------------------------------------------------

  COMPONENT Program_counter
    Port ( 
            CLK         : in STD_LOGIC;
            JUMP_F      : in STD_LOGIC;
            RST         : in STD_LOGIC;
            PC_JUMP     : in SIGNED(31 downto 0);
            PC          : out UNSIGNED(31 downto 0);
            PC_NEXT     : out UNSIGNED(31 downto 0)
        );
  END COMPONENT Program_counter;

  --------------------------------------------------------------------------------
    
  CONSTANT clk_period           : TIME := 20 ns;

  SIGNAL simulation_finished    : BOOLEAN := FALSE;

  SIGNAL CLK         : STD_LOGIC := '0';
  SIGNAL JUMP_F      : STD_LOGIC := '0';
  SIGNAL RST         : STD_LOGIC := '0';
  SIGNAL PC_JUMP     : SIGNED(31 downto 0);
  SIGNAL PC          : UNSIGNED(31 downto 0);
  SIGNAL PC_NEXT     : UNSIGNED(31 downto 0);

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS BEGIN
    clk <= '0'; WAIT FOR clk_period/2;
    clk <= '1'; WAIT FOR clk_period/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  Program_counter_i: Program_counter
    PORT MAP ( 
            CLK         => CLK,
            JUMP_F      => JUMP_F,
            RST         => RST,
            PC_JUMP     => PC_JUMP,
            PC          => PC,
            PC_NEXT     => PC_NEXT
        );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    RST  <= '1';
    PC_JUMP <= TO_SIGNED(16#02468AE0#,32);
    WAIT FOR clk_period * 5;
    RST  <= '0';
    WAIT FOR clk_period * 100;
    JUMP_F <= '1';
    WAIT FOR clk_period;
    JUMP_F <= '0';
    WAIT FOR clk_period * 100;
    JUMP_F <= '1';
    WAIT FOR clk_period * 2;
    JUMP_F <= '0';
    PC_JUMP <= TO_SIGNED(-16#40000000#,32);
    WAIT FOR clk_period * 100;
    JUMP_F <= '1';
    WAIT FOR clk_period * 20;
    JUMP_F <= '0';
    WAIT;
  END PROCESS proc_stim;

----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
