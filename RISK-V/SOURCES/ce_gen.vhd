----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    G_DIV_FACT          : POSITIVE := 2
  );
  PORT (
    CLK                 : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE_O                : OUT STD_LOGIC 
  );
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------
  signal cnt : INTEGER range 0 to G_DIV_FACT;
  signal cnt_next : INTEGER range 0 to G_DIV_FACT;


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

PROCESS (CLK) begin
  IF falling_edge(CLK) THEN
    if SRST = '1' then
      cnt <= 0;  
    elsif CE = '1' then
      cnt <= cnt_next;
    end if ;
  END IF; 
END PROCESS;

PROCESS (cnt) begin
  CE_O <= '0';
  cnt_next <= cnt + 1;
  IF cnt = G_DIV_FACT-1 THEN
    cnt_next <= 0;
    CE_O <= '1';
  END IF; 
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
