----------------------------------------------------------------------------------
-- Company: mpor
-- Engineer: Ashour
-- 
-- Create Date:    21:10:10 02/14/2019 
-- Design Name: 
-- Module Name:    data_mem - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
entity data_mem is
generic( data_width: integer:=32;
          add_width: integer :=5);
    Port ( address : in  STD_LOGIC_VECTOR (add_width-1 downto 0);
           data_in : in  STD_LOGIC_VECTOR (data_width-1 downto 0);
			  data_out : out STD_LOGIC_VECTOR(data_width-1 downto 0);
           RW : in  STD_LOGIC; 
           clck : in  STD_LOGIC);
end data_mem;

architecture Behavioral of data_mem is
type ram is array (integer range<>) of std_logic_vector(data_width-1 downto 0);
signal mem : ram (0 to 2**add_width-1 );
begin
--- write data  RW=0
Write_data:process(clck)
begin
if (rising_edge(clck)) then
   if ( RW='0') then
	  mem(conv_integer(unsigned(address)))<= data_in;
	 end if;
end if;
end process;
--Read Data  RW=1
data_out<= mem(conv_integer(unsigned(address))) when (RW='1' ) else
       (others=>'0');
end Behavioral;

