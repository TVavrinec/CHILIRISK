
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity Reg_file is
    Port ( 
            CLK          : in STD_LOGIC;
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

SIGNAL regs : t_vector := ( others => (others => '0'));

begin

PROCESS (CLK) begin    
    if rising_edge(CLK) then
        regs(0) <= to_signed(0, 32);

        IF REG_RST = '0' then
            for n in 1 to 31 loop
                regs(n) <= to_signed(0, 32);
            end loop;
        ELSIF REG_WRITE_EN = '1' then
            regs(to_integer(WRITE_REG)) <= WRITE_DATA;
        END IF;
    END IF;
END PROCESS;

DATA_RED1 <= regs(to_integer(READ_REG1));
DATA_RED2 <= regs(to_integer(READ_REG2));

end Behavioral;
