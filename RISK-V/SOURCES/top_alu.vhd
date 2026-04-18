----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2026 21:43:26
-- Design Name: 
-- Module Name: top_alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_alu is
	generic(
		DATA_WIDTH	: positive := 32
	);
	port(
		o_dout_DEBUG	: out	std_logic_vector(DATA_WIDTH-1 downto 0);
		o_pc_DEBUG		: out	std_logic_vector(DATA_WIDTH-1 downto 0);

		i_gclk		: in	std_logic;
		i_ce		: in	std_logic;

		i_sel_a		: in	std_logic;						-- select pin for reg 1
		--i_branch	: in	std_logic;						-- r w branching?
		i_jump		: in	std_logic;						-- r w jumping?
		i_funct3	: in	std_logic_vector(2 downto 0);	-- funct3
		i_funct7	: in	std_logic_vector(6 downto 0);	-- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
		i_inst_type	: in	std_logic_vector(2 downto 0);	-- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

		i_din0		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 0
		i_din1		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 1
		i_imm		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- immediate
		i_pc		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- program counter
		
		o_dout		: out	std_logic_vector(DATA_WIDTH-1 downto 0);	 -- data out
		o_pc		: out	std_logic_vector(DATA_WIDTH-1 downto 0) -- program counter

	);
end top_alu;

architecture Behavioral of top_alu is

	signal w_sel_a	: std_logic := '0';
	signal w_funct3	: std_logic_vector(2 downto 0) 				:= (others => '0');
	signal w_funct7	: std_logic_vector(6 downto 0) 				:= (others => '0');
	signal w_din0	: std_logic_vector(DATA_WIDTH-1 downto 0)	:= (others => '0');
	signal w_din1	: std_logic_vector(DATA_WIDTH-1 downto 0)	:= (others => '0');

	signal w_dout	: std_logic_vector(DATA_WIDTH-1 downto 0)	:= (others => '0');	
	signal w_pc		: std_logic_vector(DATA_WIDTH-1 downto 0)	:= (others => '0');	

begin

	o_dout_DEBUG <= w_dout;
	o_pc_DEBUG 	 <= w_pc;

	data_sync_proc: process(i_gclk) is
	begin
		if rising_edge(i_gclk) then
			if (i_ce = '1') then

					w_sel_a		<= i_sel_a;
					w_funct3	<= i_funct3;
					w_funct7	<= i_funct7;	
					w_din0		<= i_din0;

					o_dout		<= w_dout;				
					o_pc		<= w_pc;				
									

					-- a sel 	 = w_din1	<= i_din1 or i_imm
					-- funct7(5) = w_din1	<= INV or BUF
					-- inst = I	 = i_funct3 = 1 or 5 just i_imm(4:0)

					if (i_sel_a = '1') then										-- means we work with rs2, not imm
						if (i_funct7(5) = '1' AND (i_funct3 = "000")) then		-- means subtraction, so data needs inverting
							w_din1	<= std_logic_vector(signed(NOT i_din1));
						else
							w_din1	<= i_din1;
						end if;
					else
						if (i_inst_type = "001") then								-- mby fix, (1)
							if (i_funct7(5) = '1' AND (i_funct3 = "000")) then		-- means subtraction, so data needs inverting
								w_din1	<= std_logic_vector(signed(NOT i_imm));
							elsif(i_funct3 = "001" OR i_funct3 = "101") then		-- when shifting with imm only
								w_din1	<= (DATA_WIDTH-1 downto 5 => '0') & i_imm(4 downto 0);
							else
								w_din1	<= i_imm;
							end if;
						else
							w_din1	<= i_imm;										-- (2), so inverting occurs even if branching?
						end if;
					end if;

			end if;
		end if;
	end process data_sync_proc;

	ALU_proc: process(all) is
		
		---------------------------------------------------------------------------------------------------------------
		
		impure function f_addition(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
									data1 	: std_logic_vector(DATA_WIDTH-1 downto 0);
									w_inst	: std_logic ) return std_logic_vector is
			variable result : signed(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			result := signed(data0) + signed(data1) + w_inst;
			return std_logic_vector(result);
		end function f_addition;
		
        ---------------------------------------------------------------------------------------------------------------
        
		impure function f_left_shift(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
										data1 	: std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
			variable data : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			data := shift_left(unsigned(data0), to_integer(unsigned(data1)));
			return std_logic_vector(data);
		end function f_left_shift;
		
        ---------------------------------------------------------------------------------------------------------------
        
		impure function f_right_shift(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
										data1 	: std_logic_vector(DATA_WIDTH-1 downto 0);
										w_inst	: std_logic ) return std_logic_vector is
			variable dout1 : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
			variable dout2 :   signed(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			if (w_inst = '0') then
				dout1 := shift_right(unsigned(data0), to_integer(unsigned(data1)));
				dout2 := (others => '0');
				return std_logic_vector(dout1);
			else
				dout1 := (others => '0');
				dout2 := shift_right(  signed(data0), to_integer(unsigned(data1)));
				return std_logic_vector(dout2);
			end if;
		end function f_right_shift;
		
        ---------------------------------------------------------------------------------------------------------------
		
		impure function f_set_less(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
									data1 	: std_logic_vector(DATA_WIDTH-1 downto 0) ) return std_logic_vector is
			variable i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			i := (DATA_WIDTH-1 downto 0 => '1') when (signed(data0) < signed(data1)) else (DATA_WIDTH-1 downto 0 => '0');
			return i;
		end function f_set_less;
		
        ---------------------------------------------------------------------------------------------------------------
        
		impure function f_set_less_u(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
										data1 	: std_logic_vector(DATA_WIDTH-1 downto 0) ) return std_logic_vector is
			variable i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			i := (DATA_WIDTH-1 downto 0 => '1') when (unsigned(data0) < unsigned(data1)) else (DATA_WIDTH-1 downto 0 => '0');
			return i;
		end function f_set_less_u;
		
        ---------------------------------------------------------------------------------------------------------------
        
	begin
		
		w_dout	<= (others => '0');
		w_pc	<= (others => '0');

		case i_inst_type is
			
			-- Register
			when "000" =>
			
			    if    w_funct3 = "000" then
					w_dout <= f_addition   (w_din0, w_din1, w_funct7(5));
				elsif w_funct3 = "001" then
					w_dout <= f_left_shift (w_din0, w_din1);
				elsif w_funct3 = "010" then
					w_dout <= f_set_less   (w_din0, w_din1);
				elsif w_funct3 = "011" then
					w_dout <= f_set_less_u (w_din0, w_din1);
				elsif w_funct3 = "100" then
					w_dout <= w_din0 XOR w_din1;
				elsif w_funct3 = "101" then
					w_dout <= f_right_shift(w_din0, w_din1, w_funct7(5));
				elsif w_funct3 = "110" then
					w_dout <= w_din0 OR  w_din1;
				else
					w_dout <= w_din0 AND w_din1;
				end if;

			--  Immediate
			when "001" =>

				if (i_jump = '1') then

					if (w_funct3 = "000") then
						w_dout <= f_addition(i_pc, std_logic_vector(to_unsigned(4, DATA_WIDTH)), '0');
						w_pc   <= f_addition(w_din0, i_imm, '0');
					end if;
					
				else
					    if    w_funct3 = "000" then
							w_dout <= f_addition   (w_din0, w_din1, w_funct7(5));
						elsif w_funct3 = "001" then
							w_dout <= f_left_shift (w_din0, w_din1);
						elsif w_funct3 = "010" then
							w_dout <= f_set_less   (w_din0, w_din1);
						elsif w_funct3 = "011" then
							w_dout <= f_set_less_u (w_din0, w_din1);
						elsif w_funct3 = "100" then
							w_dout <= w_din0 XOR w_din1;
						elsif w_funct3 = "101" then
							w_dout <= f_right_shift(w_din0, w_din1, w_funct7(5));
						elsif w_funct3 = "110" then
							w_dout <= w_din0 OR  w_din1;
						else
							w_dout <= w_din0 AND w_din1;
						end if;
				end if;
			
			-- Upper Imeadiate
			when "100" =>
			
				if w_sel_a = '1' then
					w_dout <= f_left_shift(i_imm, std_logic_vector(to_unsigned(12, DATA_WIDTH)));
				else
					w_dout <= f_addition(i_pc, f_left_shift(i_imm, std_logic_vector(to_unsigned(12, DATA_WIDTH))), '0');
				end if;

			-- Branch
			when "011" =>
			
				if w_funct3 = "000" then
					if signed(i_din0) = signed(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				elsif w_funct3 = "001" then
					if signed(i_din0) /= signed(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				elsif w_funct3 = "100" then
					if signed(i_din0) < signed(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				elsif w_funct3 = "101" then
					if signed(i_din0) >= signed(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				elsif w_funct3 = "110" then
					if unsigned(i_din0) < unsigned(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				elsif w_funct3 = "111" then
					if unsigned(i_din0) >= unsigned(i_din1) then
						w_pc <= f_addition(i_pc, i_imm, '0');
					else
						w_pc <= i_pc;
					end if;

				else
					w_pc <= i_pc;
				end if;

			-- Jump
			when "101" =>
			
				w_dout <= f_addition(i_pc, std_logic_vector(to_unsigned(4, DATA_WIDTH)), '0');
				w_pc   <= f_addition(i_pc, i_imm, '0');
				
			when others => null;
			
				
		end case;
	end process ALU_proc;

end Behavioral;
