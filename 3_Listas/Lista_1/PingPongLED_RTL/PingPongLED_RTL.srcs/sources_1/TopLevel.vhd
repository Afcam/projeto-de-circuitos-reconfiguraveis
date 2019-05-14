----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: TopLevel - Behavioral
----------------------------------------------------------------------------------
--! @file TopLevel.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for TopLevel
--============================================================================
--! @brief Implementation to basys
------------------------------------------------------------------------------
entity TopLevel is
    Port ( reset_in : in STD_LOGIC;
           clock_in : in STD_LOGIC;
           sw_in : in STD_LOGIC_VECTOR (1 downto 0);
           anado_out : out STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out STD_LOGIC_VECTOR (7 downto 0);
           led_out : out STD_LOGIC_VECTOR (15 downto 0));
end TopLevel;
--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #PingPongLED_RTL.
------------------------------------------------------------------------------
architecture Behavioral of TopLevel is
  component PingPongLED_RTL
port (
  reset_in   : in  STD_LOGIC;
  clock_in   : in  STD_LOGIC;
  paddle1_in : in  STD_LOGIC;
  paddle2_in : in  STD_LOGIC;
  score1_out : out std_logic_vector(3 downto 0);
  score2_out : out std_logic_vector(3 downto 0);
  led_out    : out STD_LOGIC_VECTOR (15 downto 0)
);
end component PingPongLED_RTL;

component Display
port (
  reset_in  : in  STD_LOGIC;
  clock_in  : in  STD_LOGIC;
  binA_in   : in  STD_LOGIC_VECTOR (3 downto 0);
  binB_in   : in  STD_LOGIC_VECTOR (3 downto 0);
  binC_in   : in  STD_LOGIC_VECTOR (3 downto 0);
  binD_in   : in  STD_LOGIC_VECTOR (3 downto 0);
  anado_out : out STD_LOGIC_VECTOR (3 downto 0);
  seg_out   : out STD_LOGIC_VECTOR (7 downto 0)
);
end component Display;



signal score1 : std_logic_vector(3 downto 0);
signal score2 : std_logic_vector(3 downto 0);

  --=============================================================================
	-- architecture begin
	--=============================================================================
begin
  PingPongLED_RTL_i : PingPongLED_RTL
port map (
  reset_in   => reset_in,
  clock_in   => clock_in,
  paddle1_in => sw_in(0),
  paddle2_in => sw_in(1),
  score1_out => score1,
  score2_out => score2,
  led_out    => led_out
);


Display_i : Display
port map (
  reset_in  => reset_in,
  clock_in  => clock_in,
  binA_in   => score2,
  binB_in   => "1111",
  binC_in   => "1111",
  binD_in   => score1,
  anado_out => anado_out,
  seg_out   => seg_out
);

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
