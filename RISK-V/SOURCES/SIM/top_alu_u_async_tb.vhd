----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 19:31:48
-- Design Name: 
-- Module Name: design_name_tb - Behavioral
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
-- 		testbench for the module top_alu_async
-- 		UNNECESSARILY EXTENSIVE!!!!!!!!
-- 		UNNECESSARILY EXTENSIVE!!!!!!!!
-- 		UNNECESSARILY EXTENSIVE!!!!!!!!
-- 		TESTING JUST THE U INSTRUCTION
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.finish;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_alu_u_async_tb is
--  Port ( );
end top_alu_u_async_tb;

architecture Behavioral of top_alu_u_async_tb is

	--------------------------------------------------------------
	constant CLK_FREQ	: integer := 125e6;
	constant CLK_PERIOD	: time := 1 sec/CLK_FREQ;

	constant CE_FREQ	: integer := 100e3;
	constant CE_PERIOD	: time := 1 sec/CE_FREQ;

	signal	w_clk	: std_logic := '1';
	signal	w_ce	: std_logic := '0';
	--signal	w_rst	: std_logic := '1';

	shared variable v_error_cnt : integer := 0;
	--------------------------------------------------------------

	constant C_DATA_WIDTH : positive := 32;

	constant R : std_logic_vector(2 downto 0) := "000";
	constant I : std_logic_vector(2 downto 0) := "001";
	constant S : std_logic_vector(2 downto 0) := "010";
	constant B : std_logic_vector(2 downto 0) := "011";
	constant U : std_logic_vector(2 downto 0) := "100";
	constant J : std_logic_vector(2 downto 0) := "101";
	
	signal wi_sel_a		: std_logic := '0';
	signal wi_jump		: std_logic := '0';
	signal wi_u_type	: std_logic := '0';
	signal wi_load		: std_logic := '0';

	signal wi_inst		: std_logic_vector(2 downto 0)				:= (others => '0');
	signal wi_funct3	: std_logic_vector(2 downto 0)				:= (others => '0');
	signal wi_funct7	: std_logic_vector(6 downto 0)				:= (others => '0');

	signal wi_din0		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
	signal wi_din1		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
	signal wi_imm		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
	signal wi_pc		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');

	signal wo_dout		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
	signal wo_pc		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
	signal wo_addr		: std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');

	signal r_reg_cnt	: unsigned(20-1 downto 0) := (others => '0');

begin

	w_clk <= not w_clk after CLK_PERIOD / 2;
	--w_rst <= '1', '0'  after CLK_PERIOD;

	CE_proc: process is
	begin
		wait until rising_edge(w_clk);

		w_ce <= '1';
		wait for CLK_PERIOD;
		w_ce <= '0';
		wait for CE_PERIOD-CLK_PERIOD;
		
	end process CE_proc;

	TEST_VECTORS_proc: process is

		procedure checking_for(message : in string) is
		begin
			report	LF & "--------------------------------------------------------" & LF &
					LF & "Checking for: " & message									& LF & 
					LF & "--------------------------------------------------------" & LF;
		end procedure checking_for;

		procedure check_condition (	condition		: in boolean;
									pass_message	: in string := "Check: passed";
									fail_message	: in string := "Check: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! FAILED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
									severity_lvl	: in severity_level := error) is
		begin
    		if condition then
				report	LF & "--------------------------------------------------------" & LF &
						LF & pass_message												& LF & 
						LF & "--------------------------------------------------------" & LF 
				severity note;
			else
				assert	false 
				report	LF & "--------------------------------------------------------" & LF &
						LF & fail_message												& LF & 
						LF & "--------------------------------------------------------" & LF 
				severity severity_lvl;
				v_error_cnt := v_error_cnt + 1;
			end if;
		end procedure check_condition;
		
	begin
		---------------------------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------
		-------					UPPER IMM INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		U0_loop: for k in 0 to 2**(19)-1 loop
			-- START
			wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '-';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_load		<= '-';				-- load instruction
			wi_u_type	<= '1';				-- type of U instruction
			wi_inst		<= U;
			wi_funct3	<= (others => '0');	-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= (others => '0');
			wi_din1		<= (others => '0');
			wi_imm		<= (C_DATA_WIDTH-1 downto 20 => '0') & std_logic_vector(r_reg_cnt(20-1 downto 0));
			wi_pc		<= (others => '0');
			
			wait for 1*CLK_PERIOD;
			checking_for( "U: shifting, imm before: " & INTEGER'IMAGE(to_integer(unsigned(wi_imm))) & " by " & INTEGER'IMAGE(12) & ", output: " & INTEGER'IMAGE(to_integer(unsigned(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_left(  unsigned(wi_imm), 12)) );
			
			wait for 1*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 2*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');
		
		U1_loop: for k in 0 to 2**(19)-1 loop
			-- START
			wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '-';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_load		<= '-';				-- load instruction
			wi_u_type	<= '0';				-- type of U instruction
			wi_inst		<= U;
			wi_funct3	<= (others => '0');			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');		-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= (others => '0');
			wi_din1		<= (others => '0');
			wi_imm		<= (C_DATA_WIDTH-1 downto 20 => '0') & std_logic_vector(r_reg_cnt(20-1 downto 0));
			wi_pc		<= std_logic_vector(to_unsigned(10, C_DATA_WIDTH));
			
			wait for 1*CLK_PERIOD;
			checking_for( "U: adding, prog counter : " & INTEGER'IMAGE(to_integer(unsigned(wi_pc))) & ", immediate value: " & INTEGER'IMAGE(to_integer(unsigned(wi_imm))) & ", output: " & INTEGER'IMAGE(to_integer(unsigned(wo_dout))));
			check_condition( wo_dout = std_logic_vector( to_unsigned( (to_integer(unsigned(shift_left(unsigned(wi_imm), 12))) + to_integer(unsigned(wi_pc))) , C_DATA_WIDTH) )	);
			
			wait for 1*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 2*CLK_PERIOD;	--STOP
		end loop;

			r_reg_cnt <= (others => '0');
		
        wait for CLK_PERIOD;
		---------------------------------------------------------------------------------------------------------

		if v_error_cnt = 0 then
			report	LF & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & LF &
					LF & "           ALL TESTS PASSED!!! with no errors           "	& LF & 
					LF & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & LF 
			severity note;
		else
			report	LF & "--------------------------------------------------------" 				& LF &
					LF & "Simulation finished with " & integer'image(v_error_cnt) & " error(s)."	& LF & 
					LF & "--------------------------------------------------------" 				& LF 
			severity failure;
		end if;
		
		finish;
	end process TEST_VECTORS_proc;

	top_alu_async_inst: entity work.top_alu_async 
	generic map(
		DATA_WIDTH	=> C_DATA_WIDTH
	)
	port map(
		i_sel_a		 => wi_sel_a,
		i_u_type	 => wi_u_type,
		i_load	 	 => wi_load,
		i_jump		 => wi_jump,
		i_funct3	 => wi_funct3,
		i_funct7	 => wi_funct7,
		i_inst_type	 => wi_inst,
		i_din0		 => wi_din0,
		i_din1		 => wi_din1,
		i_imm		 => wi_imm,
		i_pc		 => wi_pc,
		o_dout		 => wo_dout,
		o_pc		 => wo_pc,
		o_addr		 => wo_addr
	);

end Behavioral;
