Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU_32 is 
generic( XLEN:integer :=32);
port(
	Carry_flag : OUT std_logic;
	OverFlow_flag : OUT std_logic;
	Zero_flag :OUT std_logic;
	Sign_flag : OUT std_logic;
	Operand_1,Operand_2: in std_logic_vector(XLEN-1 downto 0);
	Func : in std_logic_vector (3 downto 0);
	Output : out std_logic_vector(XLEN-1 downto 0));
End ALU_32;


architecture behaviour of ALU_32 is


	
begin
	Process(Operand_1,Operand_2,Func)
	variable S_Output : std_logic_vector(XLEN downto 0);
	variable temp : std_logic_vector(XLEN-1 downto 0);

	begin
		case Func is 
			--add
			when"0000"=>
				S_Output:= std_logic_vector(signed(Operand_1(XLEN-1)&Operand_1)+signed(Operand_2(XLEN-1)&Operand_2));
				Carry_flag<=S_Output(XLEN);
				OverFlow_flag<=S_Output(XLEN)  xor S_Output(XLEN-1);
				Sign_flag<=S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--sub
			when"0001"=>
				S_Output:= std_logic_vector(signed(Operand_1(XLEN-1)&Operand_1)-signed(Operand_2(XLEN-1)&Operand_2));
				Carry_flag<=S_Output(XLEN);
				OverFlow_flag<=S_Output(XLEN)  xor S_Output(XLEN-1);
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--multiply Lowers
			when"0010"=>
				S_Output:= '0'&(std_logic_vector(signed(Operand_1((XLEN/2)-1 downto 0))*signed(Operand_2((XLEN/2)-1 downto 0))));
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--multiply uppers
			when"0011"=>
				S_Output:= '0'&(std_logic_vector(signed(Operand_1(XLEN-1 downto (XLEN/2)))*signed(Operand_2(XLEN-1 downto (XLEN/2)))));
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--AND
			when"0100"=>
				S_Output:='0'& (Operand_1 and Operand_2);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--OR
			when"0101"=>
				S_Output:='0'& (Operand_1 OR Operand_2);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--XOR
			when"0110"=>
				S_Output:='0'& (Operand_1 xor Operand_2);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--XNOR
			when"0111"=>
				S_Output:='0'& (Operand_1 xnor Operand_2);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--Sll
			when "1000" =>
				S_Output:=Operand_1(XLEN-2 downto 1)&'0'&'0'&'0';
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--Srl
			when "1001" =>
				S_Output:='0'&'0'&Operand_1(XLEN-1 downto 1);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);
			--Sra
			when "1010" =>
				S_Output:='0'&Operand_1(XLEN-1)&Operand_1(XLEN-1 downto 1);
				OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= S_Output(XLEN-1);
				temp:=S_Output(XLEN-1 downto 0);

			when others=>	
			temp:=(others=>'0');
			OverFlow_flag<='0';
				Carry_flag<='0';
				Sign_flag<= '0';
			
			
		end case;
		Output <= temp;
		if (temp = (temp'range => '0') ) then
			Zero_flag <= '1';
		else
			Zero_flag<='0';
		end if;
	end process;
end behaviour;

