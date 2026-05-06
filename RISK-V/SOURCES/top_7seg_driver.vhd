----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2026 01:15:39 PM
-- Design Name: 
-- Module Name: top_7seg_driver - Behavioral
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
use IEEE.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_7seg_driver is
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
end top_7seg_driver;

architecture Behavioral of top_7seg_driver is

	constant C_AN_MAX_VAL : integer := GCLK_FREQ/ANODE_FREQ;

	signal r_seg_en	 : unsigned(3 downto 0) 		:= (others => '0');
	signal w_seg_sel : unsigned(3 downto 0) 		:= (others => '0');
	signal w_svnseg  : std_logic_vector(6 downto 0) := (others => '0');
	
	signal r_an_cnt  : unsigned(integer(ceil(log2(real(C_AN_MAX_VAL-1))))-1 downto 0) := (others => '0');
	signal r_an_sel  : unsigned(2 downto 0) := (others => '0');

begin
	o_segments <= DOT_POINT & w_svnseg;

	with r_an_sel select
	o_anode	<= 		"1000" when "100",
					"0100" when "011",
					"0010" when "001",
					"0001" when others;	

	with r_an_sel select
	w_seg_sel <= 	unsigned(i_dig_4) when "100",
					unsigned(i_dig_3) when "011",
					unsigned(i_dig_2) when "001",
					unsigned(i_dig_1) when others;
					
	with w_seg_sel select
	w_svnseg <=		"0010000" when "1001",	-- 9
					"0000000" when "1000",	-- 8
					"1111000" when "0111",	-- 7
					"0000010" when "0110",	-- 6
					"0010010" when "0101",	-- 5
					"0011001" when "0100",	-- 4
					"0110000" when "0011",	-- 3
					"0100100" when "0010",	-- 2
					"1111001" when "0001",	-- 1
					"1000000" when "0000",	-- 0
					"0001000" when "1010",  -- A
					"0000011" when "1011",  -- b
					"1000110" when "1100",  -- C
					"0100001" when "1101",  -- d
					"0000110" when "1110",  -- E
					"0001110" when "1111",  -- F
					"0111111" when others;	-- -

	ANODE_SELECT_proc: process(i_gclk) is
	begin
		if rising_edge(i_gclk) then
--			if (i_cntr_rst = '1') then
--
--				r_an_cnt <= (others => '0');
--				r_an_sel <= (others => '0');
--
--			else

				if (r_an_cnt >= C_AN_MAX_VAL-1) then
					r_an_cnt <= (others => '0');

					if (r_an_sel >= "100") then
						r_an_sel <= (others => '0');
					else
						r_an_sel <= r_an_sel + 1;
					end if;
				else
					r_an_cnt <= r_an_cnt + 1;
				end if;

--			end if;
		end if;
	end process ANODE_SELECT_proc;

end Behavioral;
