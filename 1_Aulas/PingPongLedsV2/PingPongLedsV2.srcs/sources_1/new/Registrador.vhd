library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registrador is
    Port ( lr : in STD_LOGIC;
         reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           clk_10Hz : in STD_LOGIC;
           player : in STD_LOGIC;
           reg : out STD_LOGIC_VECTOR (15 downto 0));
end Registrador;

architecture Behavioral of Registrador is
   signal s_reg 			: std_logic_vector(15 downto 0) := (others=>'0');

begin

   -- process para registrador de deslocamento
	process(clk_10Hz,reset)
	begin
		if reset='1' then
			s_reg <= "0000000000000001";
		elsif rising_edge(clk_10Hz) then
			if enable = '1' then
				if lr = '0' then
					s_reg <= '0' & s_reg(15 downto 1);
				else
					s_reg <= s_reg(14 downto 0) & '0';
				end if;
			elsif player = '0' then
				s_reg <= "0000000000000001";
			else
				s_reg <= "1000000000000000";
			end if;
		end if;
	end process;
	reg <= s_reg;



end Behavioral;
