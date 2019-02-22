library ieee;
use ieee.std_logic_1164.all;

entity CU is
port(
	op_code: in std_logic_vector(5 downto 0);
	flag_reg_out: in std_logic_vector(3 downto 0); --CF/OF/SF/ZF <-- LSB
	alu_mux_sel: out std_logic;--DONE
	r_stack: out std_logic;--DONE
	w_stack: out std_logic;--DONE
	stack_data_sel: out std_logic;--DONE
	s: out std_logic_vector(8 downto 1);
	w_r_n_data_mem: out std_logic;--DONE
	w_rf: out std_logic--DONE
);
end CU;

architecture dataflow of CU is
signal BC: std_logic_vector(3 downto 0);
signal branch: std_logic;
signal call, ret, push, pop: std_logic;
signal BR_inst, BE, BNE, BG, BGE: std_logic;
signal test: std_logic;
begin
	s(1) <= op_code(5); --Connect with RD and Rt mux
	s(2) <= op_code(5); --Imm, RD2
	
	with op_code select
		s(4 downto 3) <= "00" when "100001", --Connect with stack_out
				 "01" when "101110", --Connect with input_buffer
				 "10" when "100011", --Connect with data_mem_out
				 "11" when others; --Default is to write in RF from ALU_out
	s(5) <= op_code(5) and (not op_code(4)) and op_code(3) and op_code(2) and op_code(1); --OUT opcode
	
	s(8 downto 6) <= "011" when op_code = "001000" else
			 "010" when test = '1' else
			 "001" when op_code = "010001" else --Select Stack
			 "100" when op_code = "010000" else --Select Instruction call, JMP
			 "000";
	--Stack Memory control signals
	r_stack <= ret or pop;
	w_stack <= call or push;
	stack_data_sel <= call;

	--Data Memory control signal
	w_r_n_data_mem <= op_code(5) and op_code(1) and not(op_code(0) or op_code(2) or op_code(3)or op_code(4)); --Store OPCODE
	
	--ALU_mux selection line
	alu_mux_sel <= op_code(5);
	
	--Write of REG file
	w_rf <= not op_code(4); 
	
--Branch testing logic

branch <= BC(0) or BC(1) or BC(2) or BC(3);
BC(0) <= flag_reg_out(0) and BE; --Branch Equal
BC(1) <= not(flag_reg_out(0)) and BNE; --Branch Not Equal
BC(2) <= (flag_reg_out(1) xnor flag_reg_out(2)) and not(flag_reg_out(0)) and BG; --Branch Greater than
BC(3) <= (flag_reg_out(1) xnor flag_reg_out(2)) and flag_reg_out(0) and BGE; --Branch Greater than or Equal

--Signals logic
push <= op_code(5) and not(op_code(1) or op_code(0) or op_code(2) or op_code(3)or op_code(4));
pop <= op_code(5) and op_code(0) and not(op_code(1) or op_code(2) or op_code(3)or op_code(4));
call<= op_code(4) and op_code(0) and not(op_code(1) or op_code(2) or op_code(3)or op_code(5));
ret <= op_code(4) and op_code(1) and not(op_code(0) or op_code(2) or op_code(3)or op_code(5));

--Branching
BR_inst <= BE or BNE or BG or BGE;
BE <= op_code(5) and op_code(4) and not(op_code(3) or op_code(2) or op_code(1) or op_code(0));
BNE <= op_code(5) and op_code(4) and op_code(0) and not(op_code(3) or op_code(2) or op_code(1));
BG <= op_code(5) and op_code(4) and op_code(1) and not(op_code(3) or op_code(2) or op_code(0));
BGE <= op_code(5) and op_code(4) and op_code(1) and op_code(0) and not(op_code(3) or op_code(2));
test <= BR_inst and branch;
end architecture dataflow;

