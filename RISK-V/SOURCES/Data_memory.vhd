library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Data_memory is
    Port ( 
           --INPUTS
           clk : in STD_LOGIC;
           w_en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           w_data : in STD_LOGIC_VECTOR (31 downto 0);

           RW_Size : in STD_LOGIC_VECTOR (1 downto 0);
           UnSi_flag: in STD_LOGIC;

           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (31 downto 0));
           
end Data_memory;

architecture Behavioral of Data_memory is

    --Declare memory
    --INSTRUCTION MEMORY IS (4500*2) --> 9 kBytes
    type mem_type is array (0 to 4500*2-1) of std_logic_vector(7 downto 0);
    signal mem : mem_type := (others => (others => '0'));

    --Memory should be implemented as block RAM
    attribute ram_style : string;
    attribute ram_style of mem : signal is "block";

begin
    process(clk)
    begin
        if rising_edge(clk) then
            r_data <= (others => '0');
            if (w_en = '1') then
                CASE RW_Size is
                    when "00" =>
                        mem(to_integer(unsigned(addr))+0) <= w_data( 7 downto  0);
                    when "01" =>
                        mem(to_integer(unsigned(addr))+0) <= w_data( 7 downto  0);
                        mem(to_integer(unsigned(addr))+1) <= w_data(15 downto  8);
                    when "10" =>
                        mem(to_integer(unsigned(addr))+0) <= w_data( 7 downto  0);
                        mem(to_integer(unsigned(addr))+1) <= w_data(15 downto  8);
                        mem(to_integer(unsigned(addr))+2) <= w_data(23 downto 16);
                    when "11" =>
                        mem(to_integer(unsigned(addr))+0) <= w_data( 7 downto  0);
                        mem(to_integer(unsigned(addr))+1) <= w_data(15 downto  8);
                        mem(to_integer(unsigned(addr))+2) <= w_data(23 downto 16);
                        mem(to_integer(unsigned(addr))+3) <= w_data(31 downto 24);
                    when others =>
                        null;
                end CASE;
            else
                CASE RW_Size is
                    when "00" =>
                        if UnSi_flag = '1' then
                            r_data <= (others => mem(to_integer(unsigned(addr)))(7)) & mem(to_integer(unsigned(addr)));
                        else
                            r_data <= (others => '0') & mem(to_integer(unsigned(addr)));
                        end if;
                    when "01" =>
                        if UnSi_flag = '1' then
                            r_data <= (others => mem(to_integer(unsigned(addr))+1)(7)) & mem(to_integer(unsigned(addr))+1) & mem(to_integer(unsigned(addr)));
                        else
                            r_data <= (others => '0') & mem(to_integer(unsigned(addr))+1) & mem(to_integer(unsigned(addr)));
                        end if;
                    when "10" =>
                        if UnSi_flag = '1' then
                            r_data <= (others => mem(to_integer(unsigned(addr))+2)(7)) & mem(to_integer(unsigned(addr))+2) & mem(to_integer(unsigned(addr))+1) & mem(to_integer(unsigned(addr)));
                        else
                            r_data <= (others => '0') & mem(to_integer(unsigned(addr))+2) & mem(to_integer(unsigned(addr))+1) & mem(to_integer(unsigned(addr)));
                        end if;
                    when "11" =>
                        r_data <= mem(to_integer(unsigned(addr))+3) & mem(to_integer(unsigned(addr))+2) & mem(to_integer(unsigned(addr))+1) & mem(to_integer(unsigned(addr)));
                    when others =>
                        null;
                end CASE;
            end if;
        end if;
    end process;
    
end Behavioral;
