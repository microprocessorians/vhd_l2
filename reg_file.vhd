library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
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
end register_file;


architecture behavioral of register_file is
  type registerFile is array(0 to 15) of std_logic_vector(n-1 downto 0);
  signal registers : registerFile := (others => (others => '0'));
begin
  regFile : process (clk,reset) is
  begin
    if reset = '1'   then
	registers <= (others => (others => '0'));
	-- Write
    elsif rising_edge(clk) then
     
        if writeEnable = '1' then
        registers(to_integer(unsigned(writeRegSel))) <= input; 

        end if;
      end if;
  end process;
  outA <= registers(to_integer(unsigned(regASel)));
  outB <= registers(to_integer(unsigned(regBSel)));
end behavioral;
