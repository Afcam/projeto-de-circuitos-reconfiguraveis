-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: Display - Behavioral
----------------------------------------------------------------------------------
--! @file Display.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for Display
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity Display is
	port (
		reset_in  : in STD_LOGIC;
		clock_in  : in STD_LOGIC;
		binA_in   : in STD_LOGIC_VECTOR (3 downto 0);
		binB_in   : in STD_LOGIC_VECTOR (3 downto 0);
		binC_in   : in STD_LOGIC_VECTOR (3 downto 0);
		binD_in   : in STD_LOGIC_VECTOR (3 downto 0);
		anado_out : out STD_LOGIC_VECTOR (3 downto 0);
		seg_out   : out STD_LOGIC_VECTOR (7 downto 0));
end Display;

--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #Display.
------------------------------------------------------------------------------
architecture Behavioral of Display is

	component ClockDivider
		generic (
			preset_in : integer
		);
		port (
			reset_in  : in STD_LOGIC;
			clock_in  : in STD_LOGIC;
			clock_out : out STD_LOGIC
		);
	end component ClockDivider;

	component Bin7SEG
		port (
			bin_in  : in STD_LOGIC_VECTOR (3 downto 0);
			seg_out : out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component Bin7SEG;

	component Mux7SEG
		port (
			reset_in : in STD_LOGIC;
			clock_in : in STD_LOGIC;
			binA_in  : in STD_LOGIC_VECTOR (3 downto 0);
			binB_in  : in STD_LOGIC_VECTOR (3 downto 0);
			binC_in  : in STD_LOGIC_VECTOR (3 downto 0);
			binD_in  : in STD_LOGIC_VECTOR (3 downto 0);
			bin_out  : out STD_LOGIC_VECTOR (3 downto 0)
		);
	end component Mux7SEG;
	component ShiftRight
		port (
			reset_in  : in STD_LOGIC;
			clock_in  : in STD_LOGIC;
			anado_out : out STD_LOGIC_VECTOR (3 downto 0)
		);
	end component ShiftRight;
	signal clock_aux : STD_LOGIC;
	signal bin       : STD_LOGIC_VECTOR (3 downto 0);

	constant clock_Display : integer := 195312; --! 256 Hz
	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	ClockDivider_i : ClockDivider
	generic map(
		preset_in => clock_Display
	)
	port map(
		reset_in  => reset_in,
		clock_in  => clock_in,
		clock_out => clock_aux
	);

	Mux7SEG_i : Mux7SEG
	port map(
		reset_in => reset_in,
		clock_in => clock_aux,
		binA_in  => binA_in,
		binB_in  => binB_in,
		binC_in  => binC_in,
		binD_in  => binD_in,
		bin_out  => bin
	);

	Bin7SEG_i : Bin7SEG
	port map(
		bin_in  => bin,
		seg_out => seg_out
	);

	ShiftRight_i : ShiftRight
	port map(
		reset_in  => reset_in,
		clock_in  => clock_aux,
		anado_out => anado_out
	);

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
