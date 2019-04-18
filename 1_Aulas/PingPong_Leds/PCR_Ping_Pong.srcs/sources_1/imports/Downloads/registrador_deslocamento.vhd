library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity registrador_deslocamento is
	Port (  reset : in STD_LOGIC;
			clk : in STD_LOGIC;
			anodos : out STD_LOGIC_VECTOR (3 downto 0));
end registrador_deslocamento;

architecture Behavioral of registrador_deslocamento is
begin
	
	process(clk,reset)
	variable aux_anodo : std_logic_vector(3 downto 0) := "1111";
	begin
       	if reset='1' then
			aux_anodo := "1111";	
		elsif rising_edge(clk) then
				if aux_anodo = "1110" then
				    aux_anodo := "0111";
				else
				    aux_anodo := "1110";
				end if;
	   end if;
       anodos <= aux_anodo;		
	end process;

end Behavioral;