
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
        
                pin_in : IN STD_LOGIC_VECTOR (15 downto 0);

                --OUTPUTS
                pin_out : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    signal CLK : STD_LOGIC;
    signal RST : STD_LOGIC := '1';
    signal pin_in : STD_LOGIC_VECTOR (15 downto 0);
    signal pin_out : STD_LOGIC_VECTOR (15 downto 0);
begin

    dut : RP_TOP
        PORT MAP(
            CLK => CLK,
            RST => RST,
            pin_in => pin_in,
            pin_out => pin_out
        );

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
