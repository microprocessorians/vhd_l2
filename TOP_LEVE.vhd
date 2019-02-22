----------------------------------------------------------------------------------
-- Company:mpor 
-- Engineer: ashour
-- 
-- Create Date:    12:04:49 02/22/2019 
-- Design Name: 
-- Module Name:    TOP_level - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_arith.all;
entity TOP_level is
port(
	in_port: in std_logic_vector(31 downto 0);
	clk: in std_logic;
	reset: in std_logic;
	out_port: out std_logic_vector(31 downto 0)--Generic
);
end TOP_level;

architecture Behavioral of TOP_level is
-------------------ins_memory-----------
component ins_mem is
generic(data_width: integer:=32;
        add_bits: integer := 7);
    Port ( pc : in  STD_LOGIC_VECTOR ( add_bits-1 downto 0);
           instruction : out  STD_LOGIC_VECTOR (data_width-1 downto 0));
end component;
--------------------------alu----------------
component ALU_32 is 
generic( XLEN:integer :=32);
port(
	Carry_flag : OUT std_logic;
	OverFlow_flag : OUT std_logic;
	Zero_flag :OUT std_logic;
	Sign_flag : OUT std_logic;
	Operand_1,Operand_2: in std_logic_vector(XLEN-1 downto 0);
	Func : in std_logic_vector (3 downto 0);
	Output : out std_logic_vector(XLEN-1 downto 0));
End component;
--------------------------cu---------
component CU is
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
end component;
---------------------------data_mem-----
component data_mem is
generic( data_width: integer:=32;
          add_width: integer :=7);
    Port ( address : in  STD_LOGIC_VECTOR (add_width-1 downto 0);
           data_in : in  STD_LOGIC_VECTOR (data_width-1 downto 0);
			  data_out : out STD_LOGIC_VECTOR(data_width-1 downto 0);
           RW : in  STD_LOGIC; 
           clck : in  STD_LOGIC);
end component;
----------------------reg_file----------
component register_file is
GENERIC(
	n : integer := 32
       );

  port(
    outA        : out std_logic_vector(n-1 downto 0);
    outB        : out std_logic_vector(n-1 downto 0);
    input       : in  std_logic_vector(n-1 downto 0);
    writeEnable : in  std_logic;
    regASel     : in  std_logic_vector(3 downto 0);
    regBSel     : in  std_logic_vector(3 downto 0);
    writeRegSel : in  std_logic_vector(3 downto 0);
    clk         : in  std_logic;
    reset       : in  std_logic );
end component;
-------------------------stack---------------
component stack_memory is

	port
	(	clk : in std_logic;
		read_signal : in std_logic;
		write_signal : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0)
	);

end component;
----------------------------------signals-----------------
signal pc:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal new_pc:std_logic_vector(31 downto 0);
signal inst,RD_1,RD_2,alu_operand,alu_result,input_rf,Data_memo,stack_out,stack_in,signal1,signal2,signal3,signal4:std_logic_vector(31 downto 0);
signal flags,alu_mux_res,rf_mux:std_logic_vector(3 downto 0);
signal alu_mux_sel,r_stack,w_stack,stack_data_sel,r_w_data_mem,w_rf:std_logic;
signal signals_sel:std_logic_vector(8 downto 1);

begin
-----pc _async----
process(clk,reset)
begin
if(reset='1') then
     pc<=(others=>'0');
  elsif( rising_edge(clk)) then
         pc<=new_pc;
end if;
end process;
----ins_mem--------
Inst_ins_mem: ins_mem
generic map(data_width=>32,
            add_bits=>7)   
 PORT MAP(
		pc => '0'&pc(5 downto 0) ,
		instruction => inst
	);
-----------------cu---------
Inst_CU: CU PORT MAP(
		op_code =>inst(31 downto 26) ,
		flag_reg_out =>flags ,
		alu_mux_sel =>alu_mux_sel ,
		r_stack =>r_stack ,
		w_stack =>w_stack ,
		stack_data_sel =>stack_data_sel ,
		s =>signals_sel ,
		w_r_n_data_mem =>r_w_data_mem ,
		w_rf =>w_rf 
	);
-------------alu------
Inst_ALU_32: ALU_32 generic map(XLEN=>32)
 PORT MAP(
		Carry_flag => flags(3),
		OverFlow_flag =>flags(2) ,
		Zero_flag => flags(0),
		Sign_flag =>flags(1) ,
		Operand_1 =>RD_1 ,
		Operand_2 =>alu_operand,
		Func =>alu_mux_res,
		Output =>alu_result 
	);
--------------rf---------------
Inst_register_file: register_file generic map(n=>32)
PORT MAP(
		outA =>RD_1 ,
		outB =>RD_2 ,
		input =>input_rf ,
		writeEnable =>w_rf ,
		regASel =>inst(25 downto 22),
		regBSel => inst(21 downto 18),
		writeRegSel =>Rf_mux ,
		clk =>clk ,
		reset =>reset 
	);
------------data_mem-------------
Inst_data_mem: data_mem 
generic map(data_width=>32,
            add_width=>7) 
PORT MAP(
		address =>'0'&alu_result(5 downto 0) ,
		data_in =>RD_2 ,
		data_out =>Data_memo ,
		RW => r_w_data_mem,
		clck =>clk 
	);
-----------------------------------stack-------------------
Inst_stack_memory: stack_memory PORT MAP(
		clk => clk,
		read_signal =>r_stack ,
		write_signal =>w_stack ,
		reset =>reset ,
		data_in =>stack_in ,
		data_out =>stack_out
	);
------------------mux to choose between rt,rd---------
Rf_mux<=inst(17 downto 14) when (signals_sel(1)='0') else
        inst(21 downto 18);
		  
-----------------mux to choose between second operand of alu--
signal1<=inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17)&inst(17 downto 0);

alu_operand<= RD_2 when (signals_sel(2)='0') else
              signal1;
--------------mux to choose  data in of reg_file--------------
with signals_sel(4 downto 3 ) select
input_rf<= stack_out when "00",
           in_port   when "01",
			  Data_memo when "10",
			  alu_result when others;
-----------------mux to select out data--------
out_port<= RD_1 when signals_sel(5)='1' else
           (others=>'0');
---------------mux to select pc-------------------			  
signal2<= signed(pc)+conv_signed(1,32);
signal3<= signed(pc)+conv_signed(1,32)+signed(inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25 downto 0)&'0');
signal4<= signed(pc)+conv_signed(1,32)+signed(inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(25)&inst(17 downto 0)&'0');

with signals_sel(8 downto 6 ) select
new_pc<= pc when "011",
         signal3 when"010",
			signal4 when"001",
			signal2 when others;
-----muxto select data enter stack-------
stack_in<= pc when stack_data_sel='1' else 
           RD_1;
----mux to select alu function----------
alu_mux_res<= inst(13 downto 10) when alu_mux_sel='0' else
              inst(29 downto 26);
end Behavioral;