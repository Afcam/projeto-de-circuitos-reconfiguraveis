----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: ShiftRight - Behavioral
----------------------------------------------------------------------------------
--! @file ShiftRight.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--============================================================================
-- ENTITY declaration for ShiftRight
--============================================================================
--! @brief Shift barrel for anado.
------------------------------------------------------------------------------
entity ShiftRight is
	port
	(
		reset_in  : in STD_LOGIC;
		clock_in  : in STD_LOGIC;
		anado_out : out STD_LOGIC_VECTOR (3 downto 0));
end ShiftRight;

--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #ShiftRight.
------------------------------------------------------------------------------
architecture Behavioral of ShiftRight is

	signal anado : STD_LOGIC_VECTOR(3 downto 0) := "1110";
--=============================================================================
-- architecture begin
--=============================================================================
begin
	process (clock_in, reset_in)
	begin
		if (reset_in = '1') then
			anado <= "1110";
		elsif rising_edge(clock_in) then
			anado <= anado(2 downto 0) & anado(3);
		end if;
		anado_out <= anado;
	end process;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
