----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2026 14:53:45
-- Design Name: 
-- Module Name: top_alu_async - Behavioral
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

entity top_alu_async is
	generic(
		DATA_WIDTH	: positive := 32
	);
	port(
		i_jump		: in	std_logic;						-- r w jumping?
		i_u_type	: in 	std_logic;						-- type of U instruction
		i_load		: in 	std_logic;						-- load operations with imm
		i_funct3	: in	std_logic_vector(2 downto 0);	-- funct3
		i_funct7	: in	std_logic_vector(6 downto 0);	-- funct7(5), decides modes of certain operations (ADD/SUB | SRL/SRA)
		i_inst_type	: in	std_logic_vector(2 downto 0);	-- type of instruction; 000 - R | 001 - I | 010 - S | 011 - B | 100 - U | 101 - J

		i_din0		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 0
		i_din1		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- data in 1
		i_imm		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- immediate
		i_pc		: in	std_logic_vector(DATA_WIDTH-1 downto 0); -- program counter

		o_dout		: out	std_logic_vector(DATA_WIDTH-1 downto 0);	 -- data out
		o_pc		: out	std_logic_vector(DATA_WIDTH-1 downto 0);	 -- program counter
		o_addr		: out	std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end top_alu_async;

architecture Behavioral of top_alu_async is

begin
		
	ALU_proc: process(all) is
		
		---------------------------------------------------------------------------------------------------------------
		
		function f_addition(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
								data1 	: std_logic_vector(DATA_WIDTH-1 downto 0);
								w_inst	: std_logic ) return std_logic_vector is
			variable result : signed(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			if (w_inst = '1') then
				result := signed(data0) - signed(data1);
			else
				result := signed(data0) + signed(data1);
			end if;
			return std_logic_vector(result);
		end function f_addition;
		
        ---------------------------------------------------------------------------------------------------------------
        
		function f_left_shift(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
								data1 	: std_logic_vector(DATA_WIDTH-1 downto 0)) return std_logic_vector is
			variable data : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			data := shift_left(unsigned(data0), to_integer(unsigned(data1)));
			return std_logic_vector(data);
		end function f_left_shift;
		
        ---------------------------------------------------------------------------------------------------------------
        
		function f_right_shift(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
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
		
		function f_set_less(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
								data1 	: std_logic_vector(DATA_WIDTH-1 downto 0) ) return std_logic_vector is
			variable i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			i := (DATA_WIDTH-1 downto 0 => '1') when (signed(data0) < signed(data1)) else (DATA_WIDTH-1 downto 0 => '0');
			return i;
		end function f_set_less;
		
        ---------------------------------------------------------------------------------------------------------------
        
		function f_set_less_u(	data0 	: std_logic_vector(DATA_WIDTH-1 downto 0);
								data1 	: std_logic_vector(DATA_WIDTH-1 downto 0) ) return std_logic_vector is
			variable i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
		begin
			i := (DATA_WIDTH-1 downto 0 => '1') when (unsigned(data0) < unsigned(data1)) else (DATA_WIDTH-1 downto 0 => '0');
			return i;
		end function f_set_less_u;
		
        ---------------------------------------------------------------------------------------------------------------
        
	begin
		
		-- defaut assign
		o_dout	<= (others => '0');
		o_pc	<= (others => '0');
		o_addr	<= (others => '0');

		case i_inst_type is
			
			-- Register
			when "000" =>
			
			    if    i_funct3 = "000" then
					o_dout <= f_addition   (i_din0, i_din1, i_funct7(5));
				elsif i_funct3 = "001" then
					o_dout <= f_left_shift (i_din0, i_din1);
				elsif i_funct3 = "010" then
					o_dout <= f_set_less   (i_din0, i_din1);
				elsif i_funct3 = "011" then
					o_dout <= f_set_less_u (i_din0, i_din1);
				elsif i_funct3 = "100" then
					o_dout <= i_din0 XOR i_din1;
				elsif i_funct3 = "101" then
					o_dout <= f_right_shift(i_din0, i_din1, i_funct7(5));
				elsif i_funct3 = "110" then
					o_dout <= i_din0 OR  i_din1;
				else
					o_dout <= i_din0 AND i_din1;
				end if;

			--  Immediate
			when "001" =>

				if (i_jump = '1') then

					if (i_funct3 = "000") then
						o_dout <= f_addition(i_pc, std_logic_vector(to_unsigned(4, DATA_WIDTH)), '0');
						o_pc   <= f_addition(i_din0, i_imm, '0');
					end if;
					
				elsif (i_load = '1') then

					o_addr <= f_addition(i_din0, i_imm, '0');
				else
					    if    i_funct3 = "000" then
							o_dout <= f_addition   (i_din0, i_imm, i_funct7(5));
						elsif i_funct3 = "001" then
							o_dout <= f_left_shift (i_din0, (DATA_WIDTH-1 downto 5 => '0') & i_imm(4 downto 0));
						elsif i_funct3 = "010" then
							o_dout <= f_set_less   (i_din0, i_imm);
						elsif i_funct3 = "011" then
							o_dout <= f_set_less_u (i_din0, i_imm);
						elsif i_funct3 = "100" then
							o_dout <= i_din0 XOR i_imm;
						elsif i_funct3 = "101" then
							o_dout <= f_right_shift(i_din0, (DATA_WIDTH-1 downto 5 => '0') & i_imm(4 downto 0), i_funct7(5));
						elsif i_funct3 = "110" then
							o_dout <= i_din0 OR  i_imm;
						else
							o_dout <= i_din0 AND i_imm;
						end if;
				end if;
			
			-- Upper Imeadiate
			when "100" =>
			
				if (i_u_type = '1') then
					o_dout <=  i_imm;               --f_left_shift(i_imm, std_logic_vector(to_unsigned(12, DATA_WIDTH)));
				else
					o_dout <=  i_imm;               --f_addition(i_pc, f_left_shift(i_imm, std_logic_vector(to_unsigned(12, DATA_WIDTH))), '0');
				end if;

			-- Branch
			when "011" =>
			
				if i_funct3 = "000" then
					if signed(i_din0) = signed(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				elsif i_funct3 = "001" then
					if signed(i_din0) /= signed(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				elsif i_funct3 = "100" then
					if signed(i_din0) < signed(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				elsif i_funct3 = "101" then
					if signed(i_din0) >= signed(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				elsif i_funct3 = "110" then
					if unsigned(i_din0) < unsigned(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				elsif i_funct3 = "111" then
					if unsigned(i_din0) >= unsigned(i_din1) then
						o_pc <= f_addition(i_pc, i_imm, '0');
					else
						o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
					end if;

				else
					o_pc <= f_addition(i_pc, std_logic_vector(TO_UNSIGNED(4,32)), '0');
				end if;

			-- Jump
			when "101" =>
			
				o_dout <= f_addition(i_pc, std_logic_vector(to_unsigned(4, DATA_WIDTH)), '0');
				o_pc   <= f_addition(i_pc, i_imm, '0');

			-- Store
			when "010" =>
			
				o_addr <= f_addition(i_din0, i_imm, '0');
				o_dout <= i_din1;
				
			when others => null;
			
				
		end case;
	end process ALU_proc;

end Behavioral;
