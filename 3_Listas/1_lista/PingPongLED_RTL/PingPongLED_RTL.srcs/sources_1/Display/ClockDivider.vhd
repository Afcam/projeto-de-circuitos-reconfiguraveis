----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: ClockDivider - Behavioral
----------------------------------------------------------------------------------
--! @file ClockDivider.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for ClockDivider
--============================================================================
--! @brief Clock Divisor with preset
------------------------------------------------------------------------------
entity ClockDivider is
	generic
		(preset_in : integer);
	port
	(
		reset_in  : in STD_LOGIC;
		clock_in  : in STD_LOGIC;
		clock_out : out STD_LOGIC);
end ClockDivider;

--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #ClockDivider.
------------------------------------------------------------------------------
architecture Behavioral of ClockDivider is

	signal count : integer   := 1;
	signal clock : STD_LOGIC := '0';

--=============================================================================
-- architecture begin
--=============================================================================
begin
	process (clock_in, reset_in)
	begin
		if (reset_in = '1') then
			count <= 1;
			clock <= '0';
		elsif rising_edge(clock_in) then
			count <= count + 1;
			if (count = preset_in) then
				clock <= not clock;
				count <= 1;
			end if;
		end if;
	end process;

	clock_out <= clock;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
