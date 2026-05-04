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

           RW_Size : in STD_LOGIC_VECTOR (1 downto 0);  -- 00  8bits 01 16 bits 10 32bits
           UnSi_flag: in STD_LOGIC;

           
           --OUTPUTS
           r_data : out STD_LOGIC_VECTOR (31 downto 0));
           
end Data_memory;

architecture Behavioral of Data_memory is

    --Declare memory
    --INSTRUCTION MEMORY IS (2249*4) --> 9 kBytes
    type mem_type is array (0 to 2249) of std_logic_vector(31 downto 0);
    signal mem : mem_type := (others => (others => '0'));

    --Memory should be implemented as block RAM
    attribute ram_style : string;
    attribute ram_style of mem : signal is "block";

begin
    process(clk)
        variable index  : integer;
        variable offset : integer;
        variable word   : std_logic_vector(31 downto 0);
        variable byte   : std_logic_vector(7 downto 0);
        variable half   : std_logic_vector(15 downto 0);
    begin
        if rising_edge(clk) then
            index  := to_integer(unsigned(addr(31 downto 2)));
            offset := to_integer(unsigned(addr(1 downto 0)));

            word := mem(index);

            ------------------
            -- WRITE
            ------------------
            if w_en = '1' then
                case RW_Size is

                    -- STORE BYTE
                    when "00" =>
                        case offset is
                            when 0 => word(7 downto 0)   := w_data(7 downto 0);
                            when 1 => word(15 downto 8)  := w_data(7 downto 0);
                            when 2 => word(23 downto 16) := w_data(7 downto 0);
                            when 3 => word(31 downto 24) := w_data(7 downto 0);
                            when others => null;
                        end case;

                    -- STORE HALFWORD
                    when "01" =>
                        case offset is
                            when 0 => word(15 downto 0)  := w_data(15 downto 0);
                            when 2 => word(31 downto 16) := w_data(15 downto 0);
                            when others => null;
                        end case;

                    -- STORE WORD
                    when "10" =>
                        word := w_data;

                    when others =>
                        null;
                end case;

                mem(index) <= word;
            end if;
            ------------------
            -- READ
            ------------------
            case RW_Size is

                -- LOAD BYTE
                when "00" =>
                    case offset is
                        when 0 => byte := word(7 downto 0);
                        when 1 => byte := word(15 downto 8);
                        when 2 => byte := word(23 downto 16);
                        when 3 => byte := word(31 downto 24);
                        when others => byte := (others => '0');
                    end case;

                    if UnSi_flag = '1' then
                        r_data <= (31 downto 8 => byte(7)) & byte;
                    else
                        r_data <= (31 downto 8 => '0') & byte;
                    end if;

                -- LOAD HALFWORD
                when "01" =>
                    case offset is
                        when 0 => half := word(15 downto 0);
                        when 2 => half := word(31 downto 16);
                        when others => half := (others => '0');
                    end case;

                    if UnSi_flag = '1' then
                        r_data <= (31 downto 16 => half(15)) & half;
                    else
                        r_data <= (31 downto 16 => '0') & half;
                    end if;

                -- LOAD WORD
                when "10" =>
                    r_data <= word;

                when others =>
                    r_data <= (others => '0');
            end case;
        end if;
    end process;
    
end Behavioral;
