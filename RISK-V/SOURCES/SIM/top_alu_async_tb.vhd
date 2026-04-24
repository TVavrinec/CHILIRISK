----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2025 19:31:48
-- Design Name: 
-- Module Name: top_alu_async_async_tb - Behavioral
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
-- Additional Comments:
-- 
-- 		testbench for the module top_alu_async
-- 		UNNECESSARILY EXTENSIVE!!!
-- 		TESTING ALL FUNCTIONALITY EXCEPT THE U INSTRUCTION (makes no sense on 6-bit vectors)
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

entity top_alu_async_tb is
--  Port ( );
end top_alu_async_tb;

architecture Behavioral of top_alu_async_tb is

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

	constant C_DATA_WIDTH : positive := 6;

	constant R : std_logic_vector(2 downto 0) := "000";
	constant I : std_logic_vector(2 downto 0) := "001";
	constant S : std_logic_vector(2 downto 0) := "010";
	constant B : std_logic_vector(2 downto 0) := "011";
	constant U : std_logic_vector(2 downto 0) := "100";
	constant J : std_logic_vector(2 downto 0) := "101";
	
	--signal wi_sel_a		: std_logic := '0';
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

	signal r_reg_cnt	: unsigned(2*C_DATA_WIDTH-1 downto 0) := (others => '0');


begin

	w_clk <= not w_clk after CLK_PERIOD / 2;
	--w_rst <= '1', '0'  after 2*CLK_PERIOD;

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
				null;
			else
				assert	false 
				report	LF & "--------------------------------------------------------" & LF &
						LF & fail_message												& LF & 
						LF & "--------------------------------------------------------" & LF 
				severity severity_lvl;
				v_error_cnt := v_error_cnt + 1;
			end if;
		end procedure check_condition;

		function f_slt(	constant sig0 : in std_logic_vector;
						constant sig1 : in std_logic_vector ) return std_logic_vector is
		begin
			if signed(sig0) < signed(sig1) then
				return (sig0'range => '1');
			else
				return (sig0'range => '0');
			end if;
		end function;

		function f_sltu(constant sig0 : in std_logic_vector;
						constant sig1 : in std_logic_vector ) return std_logic_vector is
		begin
			if unsigned(sig0) < unsigned(sig1) then
				return (sig0'range => '1');
			else
				return (sig0'range => '0');
			end if;
		end function;

		function f_eq(	constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if (signed(compare0) = signed(compare1)) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;

		function f_neq(	constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if signed(compare0) /= signed(compare1) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;

		function f_lt(	constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if signed(compare0) < signed(compare1) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;

		function f_meq(	constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if signed(compare0) >= signed(compare1) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;

		function f_ltu(	constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if unsigned(compare0) < unsigned(compare1) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;

		function f_mequ(constant compare0 : in std_logic_vector;
						constant compare1 : in std_logic_vector;
						constant prog_cnt : in std_logic_vector;
						constant im_const : in std_logic_vector ) return std_logic_vector is
		begin
			if (unsigned(compare0) >= unsigned(compare1)) then
				return std_logic_vector( to_signed( ( to_integer(unsigned(prog_cnt)) + to_integer(signed(im_const))) , C_DATA_WIDTH) );
			else
				return prog_cnt;
			end if;
		end function;
		
	begin

		wi_load		<= '0';				-- load instruction
		wi_u_type	<= '-';				-- type of U instruction

		-----------------------------------------------------------------------
		-------					REGISTER INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		
		AND_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "111";          -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("REG: bitwise AND");
			check_condition(wo_dout = (wi_din0 AND wi_din1));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		OR_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "110"; -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("REG: bitwise OR");
			check_condition(wo_dout = (wi_din0 OR wi_din1));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		XOR_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "100"; -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("REG: bitwise XOR");
			check_condition(wo_dout = (wi_din0 XOR wi_din1));    -- now working with i_imm, not din1
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		ADD_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: addition: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " + " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & " = " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) + to_integer(signed(wi_din1))) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SUB_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= "0100000";		-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: addition: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " - " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & " = " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) - to_integer(signed(wi_din1))) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SLT_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "010";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: SLT: is " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & "? " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = f_slt(wi_din0, wi_din1) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SLTU_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "011";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: SLTU: is " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & "? " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = f_sltu(wi_din0, wi_din1) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SLL_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "001";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: SLL: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_left(unsigned(wi_din0), to_integer(unsigned(wi_din1)))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SRL_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "101";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: SRL: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_right(unsigned(wi_din0), to_integer(unsigned(wi_din1)))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		SRA_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= R;
			wi_funct3	<= "101";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= "0100000";		-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= (others => '0');
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "REG: SRA: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_right(  signed(wi_din0), to_integer(unsigned(wi_din1)))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');


		-----------------------------------------------------------------------
		-------					IMMEDIATE INSTRUCTIONS					-------
		-----------------------------------------------------------------------

		I_AND_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "111";          -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("IMM: bitwise AND");
			check_condition(wo_dout = (wi_din0 AND wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_OR_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "110"; -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("IMM: bitwise OR");
			check_condition(wo_dout = (wi_din0 OR wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_XOR_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "100"; -- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for("IMM: bitwise XOR");
			check_condition(wo_dout = (wi_din0 XOR wi_imm));    -- now working with i_imm, not din1
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
		
			r_reg_cnt <= (others => '0');

		I_ADD_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: addition: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " + " & INTEGER'IMAGE(to_integer(signed(wi_imm))) & " = " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) + to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0'); 

		I_SUB_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= "0100000";		-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: addition: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " - " & INTEGER'IMAGE(to_integer(signed(wi_imm))) & " = " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) - to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_SLT_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "010";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: SLT: is " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(signed(wi_imm))) & "? " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = f_slt(wi_din0, wi_imm) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
		
			r_reg_cnt <= (others => '0');

		I_SLTU_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "011";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: SLTU: is " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(unsigned(wi_imm))) & "? " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = f_sltu(wi_din0, wi_imm) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_SLL_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "001";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: SLL: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_imm(4 downto 0)))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_left(unsigned(wi_din0), to_integer(unsigned(wi_imm(4 downto 0))))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_SRL_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "101";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: SRL: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_imm(4 downto 0)))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_right(unsigned(wi_din0), to_integer(unsigned(wi_imm(4 downto 0))))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		I_SRA_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "101";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= "0100000";		-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "IMM: SRA: shifting " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " by " & INTEGER'IMAGE(to_integer(unsigned(wi_imm(4 downto 0)))) & ", result: " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector(shift_right(  signed(wi_din0), to_integer(unsigned(wi_imm(4 downto 0))))) );
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');
		


		I_jump_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '1';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH)); -- unsigned, wtf? kkt tak potom je to jeble ale...
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_pc		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));	-- unsigned
			
			wait for 2*CLK_PERIOD;
			checking_for( "I JUMP: addition of imm and din0: " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " + " & INTEGER'IMAGE(to_integer(signed(wi_imm))) & " = " & INTEGER'IMAGE(to_integer(signed(wo_pc))));
			check_condition(wo_pc = std_logic_vector( to_signed( (to_integer(unsigned(wi_din0)) + to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			wait for CLK_PERIOD;
			checking_for( "I JUMP: addition of pc and 4: " & INTEGER'IMAGE(to_integer(unsigned(wi_pc))) & " + " & INTEGER'IMAGE(4) & " = " & INTEGER'IMAGE(to_integer(unsigned(wo_pc))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(unsigned(wi_pc)) + 4) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		-----------------------------------------------------------------------
		--------					BRANCH INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		B_eq_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: ==: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " == " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_eq(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		B_neq_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "001";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: /=: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " /= " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_neq(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		B_lt_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "100";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: <, signed: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_lt(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		B_meq_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "101";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: >=, signed: " & INTEGER'IMAGE(to_integer(signed(wi_din0))) & " >= " & INTEGER'IMAGE(to_integer(signed(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_meq(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		B_ltu_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "110";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: <, unsigned: " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " < " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_ltu(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		B_mequ_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= B;
			wi_funct3	<= "111";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_din1		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_imm		<= std_logic_vector(  to_signed(2, C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(to_unsigned(3, C_DATA_WIDTH));
			
			wait for 2*CLK_PERIOD;
			checking_for("BRANCH: >=, unsigned: " & INTEGER'IMAGE(to_integer(unsigned(wi_din0))) & " >= " & INTEGER'IMAGE(to_integer(unsigned(wi_din1))) & "? output_pc: " & INTEGER'IMAGE(to_integer(signed(wo_pc))) & ", input_pc: " & INTEGER'IMAGE(to_integer(signed(wi_pc))));
			check_condition(wo_pc = f_mequ(wi_din0, wi_din1, wi_pc, wi_imm));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		-----------------------------------------------------------------------
		--------					JUMP INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		J_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= J;
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= (others => '0');
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			
			wait for 2*CLK_PERIOD;
			checking_for( "JUMP: pc output = pc input(" & INTEGER'IMAGE(to_integer(unsigned(wi_pc))) & ") + imm(" & INTEGER'IMAGE(to_integer(signed(wi_imm))) & ") = " & INTEGER'IMAGE(to_integer(signed(wo_pc))));
			check_condition(wo_pc = std_logic_vector( to_signed( (to_integer(unsigned(wi_pc)) + to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			wait for CLK_PERIOD;
			checking_for( "JUMP: data out = input pc: " & INTEGER'IMAGE(to_integer(unsigned(wi_pc))) & " + " & INTEGER'IMAGE(4) & " = " & INTEGER'IMAGE(to_integer(signed(wo_dout))));
			check_condition(wo_dout = std_logic_vector( to_signed( (to_integer(unsigned(wi_pc)) + 4) , C_DATA_WIDTH) ));
			
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		-----------------------------------------------------------------------
		--------					LOAD INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		L_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '0';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= I;
			wi_load		<= '1';
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "LOAD: output address = register0(" & INTEGER'IMAGE(to_integer(signed(wi_din0))) & ") + imm(" & INTEGER'IMAGE(to_integer(signed(wi_imm))) & ") = " & INTEGER'IMAGE(to_integer(signed(wo_addr))));
			check_condition(wo_addr = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) + to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');

		-----------------------------------------------------------------------
		--------					STORE INSTRUCTIONS					-------
		-----------------------------------------------------------------------
		S_loop: for k in 0 to 2**(2*C_DATA_WIDTH)-1 loop
			-- START
			--wi_sel_a	<= '-';				-- '1' = work with data1 | '0' work with imm
			wi_jump		<= '-';				-- ONLY IN inst = I, '1' = program counter operation | '0' = normal inst = R commands
			wi_inst		<= S;
			wi_load		<= '-';
			wi_funct3	<= "000";			-- 000 ADD/SUB1 | 001 SLL  | 010 SLT  | 011 SLTU | 100 XOR | 101 SRL/SRA1| 110 OR 	| 111 AND
			wi_funct7	<= (others => '0');	-- bit (5) decides modes of certain operations 0/1 (ADD/SUB | SRL/SRA)
			wi_din0		<= std_logic_vector(r_reg_cnt(C_DATA_WIDTH-1 downto 0));
			wi_din1		<= (others => '0');
			wi_imm		<= std_logic_vector(r_reg_cnt(2*C_DATA_WIDTH-1 downto C_DATA_WIDTH));
			wi_pc		<= (others => '0');
			
			wait for 2*CLK_PERIOD;
			checking_for( "STORE: output address = register0(" & INTEGER'IMAGE(to_integer(signed(wi_din0))) & ") + imm(" & INTEGER'IMAGE(to_integer(signed(wi_imm))) & ") = " & INTEGER'IMAGE(to_integer(signed(wo_addr))));
			check_condition(wo_addr = std_logic_vector( to_signed( (to_integer(signed(wi_din0)) + to_integer(signed(wi_imm))) , C_DATA_WIDTH) ));
			wait for 2*CLK_PERIOD;
			r_reg_cnt <= r_reg_cnt + 1;
			
			wait for 6*CLK_PERIOD;	--STOP
		end loop;
			
			r_reg_cnt <= (others => '0');


		------------------------------------------------------------------------------------------------------------------

		wait for CLK_PERIOD;

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
		--i_sel_a		 => wi_sel_a,
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
