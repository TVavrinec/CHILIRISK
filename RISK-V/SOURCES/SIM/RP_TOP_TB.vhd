
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RP_TOP_TB is
--  Port ( );
end RP_TOP_TB;

architecture Behavioral of RP_TOP_TB is

COMPONENT RP_TOP
PORT(
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            o_dout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal CLK : STD_LOGIC;
signal RST : STD_LOGIC := '1';
signal o_dout : STD_LOGIC_VECTOR (31 downto 0);

begin

dut : RP_TOP
PORT MAP(
CLK => CLK,
RST => RST,
o_dout => o_dout);

CLK_process : process
begin
    while true loop
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end loop;
end process;


stim: process
begin
wait for 100ns;
wait;
end process;

end Behavioral;
