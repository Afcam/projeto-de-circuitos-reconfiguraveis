----------------------------------------------------------------------------------
-- Create Date: 05.05.2019 15:40:28
-- Module Name: PingPongLED - Rtl
----------------------------------------------------------------------------------

--! @file PingPongLED.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--============================================================================
-- ENTITY declaration for PingPongLED
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity PingPongLED is
	port
	(
		clock_in    : in STD_LOGIC;                        --! local bus clock
		reset_in    : in STD_LOGIC;                        --! reset =0: reset active reset =1: no reset
		start_in    : in STD_LOGIC;                        --! start =0: start active start =1: no start
		sw_in       : in STD_LOGIC_VECTOR (1 downto 0);    --! sw[0]=player1 sw[1]=player2
		anado_out   : out STD_LOGIC_VECTOR (3 downto 0);   --! anodos bus
		segment_out : out STD_LOGIC_VECTOR (7 downto 0);   --! display segments bus
		led_out     : out STD_LOGIC_VECTOR (15 downto 0)); --! led bus
end PingPongLED;
--============================================================================
-- ARCHITECTURE declaration
--! @brief Architecture of #DemoEntity
--! @details Optional field
--============================================================================
architecture Rtl of PingPongLED is

	component DECOD_7SEG_BIN
		port (  Reset      : in STD_LOGIC;
      			CLK        : in STD_LOGIC;
      			BIN_A      : in STD_LOGIC_VECTOR (3 downto 0);
      			BIN_B      : in STD_LOGIC_VECTOR (3 downto 0);
      			BIN_C      : in STD_LOGIC_VECTOR (3 downto 0);
      			BIN_D      : in STD_LOGIC_VECTOR (3 downto 0);
      			SEG_out    : out STD_LOGIC_VECTOR (7 downto 0);
      			Anados_out : out STD_LOGIC_VECTOR (3 downto 0));
	end component DECOD_7SEG_BIN;

  component PingPongTABLE
    port (  clock_in     : in  STD_LOGIC;
            reset_in     : in  STD_LOGIC;
            direction_in : in  STD_LOGIC;
            led_out      : out STD_LOGIC_VECTOR (15 downto 0));
  end component PingPongTABLE;

  component PingPongSCORE
    port (  clock_in     : in STD_LOGIC;
            reset_in     : in  STD_LOGIC;
            enable_in    : in  STD_LOGIC;
            direction_in : in  STD_LOGIC;
            score1_out   : out STD_LOGIC_VECTOR (3 downto 0);
            score2_out   : out STD_LOGIC_VECTOR (3 downto 0);
            ready_out    : out STD_LOGIC);
   end component PingPongSCORE;

   component PingPongLOGIC
    port (  clock_in      : in  STD_LOGIC;
            reset_in      : in  STD_LOGIC;
            sw_in         : in  STD_LOGIC_VECTOR (1 downto 0);
            led_in        : in  STD_LOGIC_VECTOR(15 downto 0);
            direction_out : out STD_LOGIC;
            endgame_out     : out STD_LOGIC);
    end component PingPongLOGIC;

    component CLOCK_DIV is
      generic ( Preset : INTEGER);
      port (
        Reset   : in STD_LOGIC;
        CLK_in  : in STD_LOGIC;
        CLK_out : out STD_LOGIC
      );
    end component CLOCK_DIV;




  SIGNAL clock_10Hz : STD_LOGIC;

  signal score_player1   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  signal score_player2   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";


  signal resetTABLE     : STD_LOGIC;
  signal enableSCORE    : STD_LOGIC;
  signal direction      : STD_LOGIC;
  signal led            : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

--=============================================================================
-- architecture begin
--=============================================================================
begin

  CLOCK_DIV_10Hz : CLOCK_DIV
  GENERIC MAP(Preset => 5000000) --! 10 Hz
  PORT MAP(
    Reset   => reset_in,
    CLK_in  => clock_in,
    CLK_out => clock_10Hz
  );

	DECOD_7SEG_BIN_i : DECOD_7SEG_BIN
	port map (  Reset      => reset_in,
          		CLK        => clock_in,
          		BIN_A      => score_player1,
          		BIN_B      => "1111", --! segment turned off
          		BIN_C      => "1111", --! segment turned off
          		BIN_D      => score_player2,
          		SEG_out    => segment_out,
          		Anados_out => anado_out);

  PingPongTABLE_i : PingPongTABLE
  port map (  clock_in     => clock_10Hz,
              reset_in     => resetTABLE,
              direction_in => direction,
              led_out      => led);

  PingPongSCORE_i : PingPongSCORE
  port map (  clock_in     => clock_in,
              reset_in     => reset_in,
              enable_in    => enableSCORE,
              direction_in => direction,
              score1_out   => score_player1,
              score2_out   => score_player2,
              ready_out    => resetTABLE);

  PingPongLOGIC_i : PingPongLOGIC
  port map (  clock_in      => clock_in,
              reset_in      => reset_in,
              sw_in         => sw_in,
              led_in        => led,
              direction_out => direction,
              endgame_out     => enableSCORE);


led_out <= led;

end Rtl;
--=============================================================================
-- architecture end
--=============================================================================
