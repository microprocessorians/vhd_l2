library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stack_memory is

	port
	(	clk : in std_logic;
		read_signal : in std_logic;
		write_signal : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0)
	);

end entity;

architecture behavioral of stack_memory is

type memory_type is array (0 to 127) of std_logic_vector(31 downto 0);
signal memory : memory_type;
signal stack_pointer  : std_logic_vector(6 downto 0) := "0000000";

begin

process(clk)
begin

	if(clk'event and clk = '1')then
		if(write_signal = '1')then
			memory(conv_integer(stack_pointer)) <= data_in;
		end if;
		if(read_signal = '1')then
			data_out <= memory(conv_integer(stack_pointer-1));
		end if;	
	end if;

end process;

process(clk,reset)
begin

	if(reset = '1')then
		stack_pointer <= "0000000";
	elsif(clk'event and clk = '1')then
		if(write_signal = '1')then
			stack_pointer <= stack_pointer + 1;
		end if;
		if(read_signal = '1')then
			stack_pointer <= stack_pointer - 1;
		end if;	
	end if;

end process;

end behavioral;

