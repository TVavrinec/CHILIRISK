library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_memory is
    Port ( 
           --INPUTS
           clk : in STD_LOGIC;
           w_en : in STD_LOGIC;
           w_addr : in STD_LOGIC_VECTOR (3 downto 0);
           r_addr : in STD_LOGIC_VECTOR (3 downto 0);
           w_data : in STD_LOGIC_VECTOR (7 downto 0);
           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (7 downto 0));
           
end Data_memory;

architecture Behavioral of Data_memory is

    --Declare memory  
    --INSTRUCTION MEMORY IS 9216*8bits --> 9,216kBytes 
    type mem_type is array (0 to 9215) of std_logic_vector(7 downto 0);
    signal mem : mem_type := (others => (others => '0'));
    
    --Memory should be implemented as block RAM
    attribute ram_style : string;
    attribute ram_style of mem : signal is "block";
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
        --write
            if (w_en = '1') then
                mem(to_integer(unsigned(w_addr))) <= w_data;
            end if;
        --read
                r_data <= mem(to_integer(unsigned(r_addr)));
        end if;
    end process;
    
end Behavioral;
