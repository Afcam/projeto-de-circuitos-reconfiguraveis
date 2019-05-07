----------------------------------------------------------------------------------
-- Create Date: 05.05.2019 12:09:44
-- Module Name: DECOD_7SEG_BIN - Behavioral
----------------------------------------------------------------------------------

--! @file DECOD_7SEG_BIN.vhd
--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for DECOD_7SEG_BIN
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity DECOD_7SEG_BIN is
	port	(
		Reset      : in STD_LOGIC;
		CLK        : in STD_LOGIC;
		BIN_A      : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_B      : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_C      : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_D      : in STD_LOGIC_VECTOR (3 downto 0);
		SEG_out    : out STD_LOGIC_VECTOR (7 downto 0);
		Anados_out : out STD_LOGIC_VECTOR (3 downto 0));
end DECOD_7SEG_BIN;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Architecture of #DemoEntity
--! @details Optional field
--============================================================================
architecture Behavioral of DECOD_7SEG_BIN is

	component CLOCK_DIV is
		generic	(	Preset : INTEGER);
		port	(	Reset   : in STD_LOGIC;
						CLK_in  : in STD_LOGIC;
						CLK_out : out STD_LOGIC);
	end component CLOCK_DIV;

	signal CLK_256Hz : STD_LOGIC;

	component MUX_7SEG is
		port	(	Reset   : in STD_LOGIC;
						CLK_in  : in STD_LOGIC;
						BIN_A   : in STD_LOGIC_VECTOR (3 downto 0);
						BIN_B   : in STD_LOGIC_VECTOR (3 downto 0);
						BIN_C   : in STD_LOGIC_VECTOR (3 downto 0);
						BIN_D   : in STD_LOGIC_VECTOR (3 downto 0);
						BIN_out : out STD_LOGIC_VECTOR (3 downto 0));
	end component MUX_7SEG; --use UNISIM.VComponents.all;

	signal s_BIN_out : STD_LOGIC_VECTOR (3 downto 0);

	component BIN_7SEG is
		port(	BIN : in STD_LOGIC_VECTOR (3 downto 0);
					SEG : out STD_LOGIC_VECTOR (7 downto 0));
	end component BIN_7SEG;

	component SHIFT_RIGHT is
		port (	Reset      : in STD_LOGIC;
						CLK_in     : in STD_LOGIC;
						Anodos_out : out STD_LOGIC_VECTOR (3 downto 0));
	end component SHIFT_RIGHT;
--=============================================================================
-- architecture begin
--=============================================================================
begin
	CLOCK_DIV_i : CLOCK_DIV
	generic	map(Preset => 195312) --! 256 Hz
	port map (	Reset   => Reset,
							CLK_in  => CLK,
							CLK_out => CLK_256Hz);

	SHIFT_RIGHT_i : SHIFT_RIGHT
	port	map(	Reset      => Reset,
							CLK_in     => CLK_256Hz,
							Anodos_out => Anados_out);

	BIN_7SEG_i : BIN_7SEG
	port map( BIN => s_BIN_out,
						SEG => SEG_out);

	MUX_7SEG_i : MUX_7SEG
	port map(	Reset   => Reset,
						CLK_in  => CLK_256Hz,
						BIN_A   => BIN_A,
						BIN_B   => BIN_B,
						BIN_C   => BIN_C,
						BIN_D   => BIN_D,
						BIN_out => s_BIN_out);

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
