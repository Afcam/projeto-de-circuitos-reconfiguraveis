library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ClockDiv is
   generic (preset : std_logic_vector(24 downto 0):= (others=>'0'));
    Port ( reset : in STD_LOGIC;
           clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end ClockDiv;

architecture Behavioral of ClockDiv is

   	signal count : std_logic_vector(24 downto 0) := (others=>'0');
   	signal clkaux : std_logic := '0';
begin

   clk_out <= clkaux;
	process(clk_in,reset)
	begin
		if rising_edge(clk_in) then
			if reset='1' then
				count <= (others=>'0');
				clkaux <= '0';
			elsif count=preset then
				clkaux <= not clkaux;
				count <= (others=>'0');
			else
				count <= count + '1';
			end if;
		end if;

end Behavioral;
