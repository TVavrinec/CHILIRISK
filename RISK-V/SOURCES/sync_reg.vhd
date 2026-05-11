----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
  PORT(
    CLK                 : IN STD_LOGIC;
    SIG_IN              : IN STD_LOGIC;
    WORD_IN             : IN STD_LOGIC_VECTOR (15 downto 0);

    WORD_OUT            : OUT STD_LOGIC_VECTOR (15 downto 0);
    SIG_OUT             : OUT STD_LOGIC
  );
END ENTITY sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------
  SIGNAL SIG_IN_sig0    : STD_LOGIC;
  SIGNAL SIG_IN_sig1    : STD_LOGIC;
  SIGNAL WORD_IN_sig_0  : STD_LOGIC_VECTOR (15 downto 0);
  SIGNAL WORD_IN_sig_1  : STD_LOGIC_VECTOR (15 downto 0);
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS (CLK) begin
  IF rising_edge(CLK) THEN
    SIG_IN_sig0 <= SIG_IN;
    SIG_IN_sig1 <= SIG_IN_sig0;
    SIG_OUT <= SIG_IN_sig1;

    WORD_IN_sig_0 <= WORD_IN;
    WORD_IN_sig_1 <= WORD_IN_sig_0;
    WORD_OUT <= WORD_IN_sig_1;

  END IF; 
END PROCESS;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
