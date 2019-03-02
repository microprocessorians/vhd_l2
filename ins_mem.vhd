

----------------------------------------------------------------------------------
-- Company:MPOR 
-- Engineer:maher and ashour
-- 
-- Create Date:    15:35:52 02/14/2019 
-- Design Name: 
-- Module Name:    ins_mem - Behavioral 
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
use IEEE.STD_logic_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;
entity ins_mem is
generic(data_width: integer:=32;
        add_bits: integer := 5);
    Port ( pc : in  STD_LOGIC_VECTOR ( add_bits-1 downto 0);
           instruction : out  STD_LOGIC_VECTOR (data_width-1 downto 0));
end ins_mem;



architecture Behavioral of ins_mem is

type ins_type is array (0 to 11) of std_logic_vector(data_width-1 downto 0);

signal ins_mem : ins_type;

begin

ins_mem <= (x"81940002",
 x"80840005",
x"0054C400",
x"B4C00000",
x"B4400000",
x"B5400000",
x"B8180000",
x"B81C0000",
x"B8200000",
x"AD440002",
x"B1A40002",
x"C197FFFF"
);

instruction<= ins_mem(conv_integer(unsigned(pc)));
end Behavioral;
