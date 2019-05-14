----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: PingPongLED_RTL - Behavioral
----------------------------------------------------------------------------------
--! @file PingPongLED_RTL.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for PingPongLED_RTL
--============================================================================
--! @brief Ping Pong LEDs logic
------------------------------------------------------------------------------
entity PingPongLED_RTL is
	port (
		reset_in   : in STD_LOGIC;
		clock_in   : in STD_LOGIC;
		paddle1_in : in STD_LOGIC;
		paddle2_in : in STD_LOGIC;
		score1_out : out std_logic_vector(3 downto 0);
		score2_out : out std_logic_vector(3 downto 0);
		led_out    : out STD_LOGIC_VECTOR (15 downto 0)
	);
end PingPongLED_RTL;
--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #PingPongLED_RTL.
------------------------------------------------------------------------------
architecture Behavioral of PingPongLED_RTL is

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

	constant const_10Hz : integer   := 5000000; --! 10 Hz
	signal clock_10Hz   : std_logic := '0';

	signal enable   : std_logic                     := '0';
	signal dir_ball : std_logic                     := '1';
	signal player   : std_logic                     := '0';
	signal reg_ball : std_logic_vector(15 downto 0) := (others => '0');
	signal score1   : std_logic_vector(3 downto 0)  := "0000";
	signal score2   : std_logic_vector(3 downto 0)  := "0000";

	signal start_p1 : std_logic := '0';
	signal start_p2 : std_logic := '0';
	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	ClockDivider_ii : ClockDivider
	generic map(
		preset_in => const_10Hz
	)
	port map(
		reset_in  => reset_in,
		clock_in  => clock_in,
		clock_out => clock_10Hz
	);

	-- process para registrador de deslocamento
	process (clock_10Hz, reset_in)
	begin
		if reset_in = '1' then
			reg_ball <= "0000000000000010";
		elsif rising_edge(clock_10Hz) then
			if start_p1 = '1' then
				reg_ball <= "0000000000000001";
			elsif start_p2 = '1' then
				reg_ball <= "1000000000000000";
			elsif (dir_ball = '0') then
				reg_ball <= '0' & reg_ball(15 downto 1);
			elsif (dir_ball = '1') then
				reg_ball <= reg_ball(14 downto 0) & '0';
			end if;
		end if;
	end process;

	led_out <= reg_ball;

	Logic : process (clock_in, reset_in)
	begin
		if reset_in = '1' then
			start_p1 <= '0';
			start_p2 <= '0';
			score1   <= "0000";
			score2   <= "0000";
			dir_ball <= '1';
		elsif rising_edge(clock_in) then
			if (reg_ball(15) = '1') and (paddle2_in = '1') then --! Player 2 rebateu
				start_p2 <= '0';
				dir_ball <= '0';
			elsif (reg_ball(15) = '1') and (paddle2_in = '0') and (start_p2 = '0') then --! Ponto para player 1
				start_p2 <= '1';
				dir_ball <= '0';
				score1 <= score1 + '1';
				if score1 = "1001" then
					score1 <= "0000";
				end if;
			elsif (reg_ball(0) = '1') and (paddle1_in = '1') then --! Player 2 rebateu
				start_p1 <= '0';
				dir_ball <= '1';
			elsif (reg_ball(0) = '1') and (paddle1_in = '0') and (start_p1 = '0') then --! Ponto para player 1
				start_p1 <= '1';
				dir_ball <= '1';
				score2 <= score2 + '1';
				if score2 ="1001" then
					score2 <= "0000";
				end if;
			end if;
			score1_out <= score1;
			score2_out <= score2;
		end if;
	end process Logic;

end Behavioral;
--=============================================================================
-- architecture end
