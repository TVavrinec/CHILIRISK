library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Data_memory is
    Port ( 
           --INPUTS
           clk          : in STD_LOGIC;
           w_en         : in STD_LOGIC;
           addr         : in STD_LOGIC_VECTOR (31 downto 0);
           w_data       : in STD_LOGIC_VECTOR (31 downto 0);

           RW_Size      : in STD_LOGIC_VECTOR (1 downto 0);  -- 00  8bits 01 16 bits 10 32bits
           UnSi_flag    : in STD_LOGIC;

           pin_in       : in STD_LOGIC_VECTOR (15 downto 0);

           --OUTPUTS
           r_data   : out STD_LOGIC_VECTOR (31 downto 0);

           pin_out  : out STD_LOGIC_VECTOR (15 downto 0);
           disp_out : out STD_LOGIC_VECTOR (15 downto 0)
        );
           
end Data_memory;

architecture Behavioral of Data_memory is

    COMPONENT blk_mem_gen_0
    PORT (
        clka : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
    );
    END COMPONENT; 

    type t_vector is array (0 to 8) of STD_LOGIC_VECTOR(31 downto 0);

    SIGNAL out_regs : t_vector := ( others => (others => '0'));

    type byte is array (0 to 3) of STD_LOGIC_VECTOR(7 downto 0);

    SIGNAL D_in  : byte := ( others => (others => '0'));
    SIGNAL D_out : byte := ( others => (others => '0'));

    SIGNAL W_en_internal : STD_LOGIC_VECTOR (3 downto 0);

begin
    blk_mem_gen_0_A : blk_mem_gen_0
    PORT MAP (
        clka    => clk,
        ena     => '1',
        wea(0)  => W_en_internal(0),
        addra   => addr(11 downto 0),
        dina    => D_in(0),
        douta   => D_out(0)
    );

    blk_mem_gen_0_B : blk_mem_gen_0
    PORT MAP (
        clka    => clk,
        ena     => '1',
        wea(0)  => W_en_internal(1),
        addra   => addr(11 downto 0),
        dina    => D_in(1),
        douta   => D_out(1)
    );
    
    blk_mem_gen_0_C : blk_mem_gen_0
    PORT MAP (
        clka    => clk,
        ena     => '1',
        wea(0)  => W_en_internal(2),
        addra   => addr(11 downto 0),
        dina    => D_in(2),
        douta   => D_out(2)
    );

    blk_mem_gen_0_D : blk_mem_gen_0
    PORT MAP (
        clka    => clk,
        ena     => '1',
        wea(0)  => W_en_internal(3),
        addra   => addr(11 downto 0),
        dina    => D_in(3),
        douta   => D_out(3)
    );

    process(all)
        variable offset : integer;
        variable byte   : std_logic_vector(7 downto 0);
        variable half   : std_logic_vector(15 downto 0);
    begin
        offset := to_integer(unsigned(addr(1 downto 0)));
        D_in <= ( others => (others => '0'));
        W_en_internal <= "0000";

        if addr(31) = '0' then
            if w_en = '1' then
                ------------------
                -- WRITE
                ------------------
                case RW_Size is

                    -- STORE BYTE
                    when "00" =>
                        case offset is
                            when 0 => 
                                D_in(0) <= w_data(7 downto 0);
                                W_en_internal <= "0001";
                            when 1 => 
                                D_in(1) <= w_data(7 downto 0);
                                W_en_internal <= "0010";
                            when 2 => 
                                D_in(2) <= w_data(7 downto 0);
                                W_en_internal <= "0100";
                            when 3 => 
                                D_in(3) <= w_data(7 downto 0);
                                W_en_internal <= "1000";
                            when others => 
                                W_en_internal <= "0000";
                        end case;

                    -- STORE HALFWORD
                    when "01" =>
                        case offset is
                            when 0 =>
                                D_in(0) <= w_data(7 downto 0);
                                D_in(1) <= w_data(15 downto 8);
                                W_en_internal <= "0011";
                            when 2 =>
                                D_in(2) <= w_data(7 downto 0);
                                D_in(3) <= w_data(15 downto 8);
                                W_en_internal <= "1100";
                            when others => 
                                W_en_internal <= "0000";
                        end case;

                    -- STORE WORD
                    when "10" =>
                        D_in(0) <= w_data(7 downto 0);
                        D_in(1) <= w_data(15 downto 8);
                        D_in(2) <= w_data(23 downto 16);
                        D_in(3) <= w_data(31 downto 24);
                        W_en_internal <= "1111";

                    when others => null;
                end case;
            else
                ------------------
                -- READ
                ------------------
                case RW_Size is

                    -- LOAD BYTE
                    when "00" =>
                        case offset is
                            when 0 => byte := D_out(0);
                            when 1 => byte := D_out(1);
                            when 2 => byte := D_out(2);
                            when 3 => byte := D_out(3);
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
                            when 0 => half := D_out(1) & D_out(0);
                            when 2 => half := D_out(3) & D_out(2);
                            when others => half := (others => '0');
                        end case;

                        if UnSi_flag = '1' then
                            r_data <= (31 downto 16 => half(15)) & half;
                        else
                            r_data <= (31 downto 16 => '0') & half;
                        end if;

                    -- LOAD WOR
                    when "10" =>
                        r_data <= D_out(3) & D_out(2) & D_out(1) & D_out(0);

                    when others =>
                        r_data <= (others => '0');
                end case;
            end if;
        else 
            if w_en = '1' then
                out_regs(to_integer(unsigned(addr(30 downto 2)))) <= w_data;
            else
                r_data <= out_regs(to_integer(unsigned(addr(30 downto 2))));
            end if;
        end if;

        pin_out <= out_regs(0)(15 downto 0);
        disp_out <= out_regs(1)(15 downto 0);
        out_regs(3)(15 downto 0) <= pin_in;
    end process;
    
end Behavioral;
