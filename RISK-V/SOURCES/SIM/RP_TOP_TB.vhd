
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RP_TOP_TB is
--  Port ( );
end RP_TOP_TB;

architecture Behavioral of RP_TOP_TB is

COMPONENT RP_TOP
    PORT(

        CLK : IN STD_LOGIC;
        RST_i : IN STD_LOGIC;
        
        sw_i : IN STD_LOGIC_VECTOR (15 downto 0);
        
        --OUTPUTS

        DISP_SEG    : out STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG    : out STD_LOGIC_VECTOR (3 DOWNTO 0);
        led     : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    signal CLK : STD_LOGIC;
    signal RST : STD_LOGIC := '1';
    signal sw : STD_LOGIC_VECTOR (15 downto 0);

    signal led : STD_LOGIC_VECTOR (15 downto 0);
    signal DISP_SEG : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal DISP_DIG : STD_LOGIC_VECTOR (3 DOWNTO 0);
begin

    dut : RP_TOP
        PORT MAP(
            CLK => CLK,
            RST_i => RST,
            sw_i => sw,
            led => led,
            DISP_SEG => DISP_SEG,
            DISP_DIG => DISP_DIG
        );

    CLK_process : process
    begin
        sw <= x"0000";
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
