----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: PingPongLED_FSM - Behavioral
----------------------------------------------------------------------------------
--! @file PingPongLED_FSM.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for PingPongLED_FSM
--============================================================================
--! @brief Ping Pong LEDs logic
------------------------------------------------------------------------------
entity PingPongLED_FSM is
	port (
		reset_in   : in STD_LOGIC;
		clock_in   : in STD_LOGIC;
		paddle1_in : in STD_LOGIC;
		paddle2_in : in STD_LOGIC;
		score1_out : out std_logic_vector(3 downto 0);
		score2_out : out std_logic_vector(3 downto 0);
		led_out    : out STD_LOGIC_VECTOR (15 downto 0)
	);
end PingPongLED_FSM;

architecture Behavioral of PingPongLED_FSM is
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

	type state is (Init, LR0, LR1, LR3_13, LR14, LR15, Start_p1, Start_p2, Score1, Score2);
	signal current_state : state := Init;
	signal next_state    : state := Init;

	signal dir_ball : std_logic                     := '1';
	signal reg_ball : std_logic_vector(15 downto 0) := (others => '0');

	signal score_1 : std_logic_vector(3 downto 0) := "0000";
	signal score_2 : std_logic_vector(3 downto 0) := "0000";
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

	Estados : process (clock_10Hz, reset_in)
	begin
		if reset_in = '1' then
			current_state <= Init;
		elsif rising_edge(clock_10Hz) then
			current_state <= next_state;
		end if;
	end process;

	Transicao : process (current_state)
	begin
		case current_state is
			when Init =>
				reg_ball   <= "0000000000000010";
				dir_ball   <= '1';
				next_state <= LR3_13;

			when Start_p1 =>
				reg_ball   <= "0000000000000001";
				dir_ball   <= '1';
				next_state <= LR1;

			when Start_p2 =>
				reg_ball   <= "1000000000000000";
				dir_ball   <= '0';
				next_state <= LR14;

			when Score1 =>
				score_1 <= score_1 + '1';
				if score_1 = "1001" then
					score_1 <= "0000";
				end if;
				next_state <= Start_p2;

			when Score2 =>
				score_2 <= score_2 + '1';
				if score_2 = "1001" then
					score_2 <= "0000";
				end if;
				next_state <= Start_p1;

			when LR3_13 =>
				if (dir_ball = '0') then
					reg_ball <= '0' & reg_ball(15 downto 1);
					if (reg_ball(13) = '1') then
						next_state <= LR1;
					else
						next_state <= LR3_13;
					end if;
					dir_ball <= '0';
				else
					reg_ball <= reg_ball(14 downto 0) & '0';
					if (reg_ball(13) = '1') then
						next_state <= LR14;
					else
						next_state <= LR3_13;
					end if;
					dir_ball <= '1';
				end if;

			when LR14 =>
				if (dir_ball = '0') then
					reg_ball   <= '0' & reg_ball(15 downto 1);
					dir_ball   <= '0';
					next_state <= LR3_13;
				elsif (dir_ball = '1') then
					reg_ball   <= reg_ball(14 downto 0) & '0';
					dir_ball   <= '1';
					next_state <= LR15;
				end if;

			when LR1 =>
				if (dir_ball = '0') then
					reg_ball   <= '0' & reg_ball(15 downto 1);
					dir_ball   <= '0';
					next_state <= LR0;
				elsif (dir_ball = '1') then
					reg_ball   <= reg_ball(14 downto 0) & '0';
					dir_ball   <= '1';
					next_state <= LR3_13;
				end if;

			when LR15 =>
				if (paddle2_in = '1') and (dir_ball = '1') then --! Player 2 rebateu
					next_state <= LR14;
					dir_ball   <= '0';
					reg_ball   <= '0' & reg_ball(15 downto 1);
				else
					next_state <= Score1;
				end if;

			when LR0 =>
				if (paddle1_in = '1') and (dir_ball = '0') then --! Player 2 rebateu
					next_state <= LR1;
					dir_ball   <= '1';
					reg_ball   <= reg_ball(14 downto 0) & '0';
				else
					next_state <= Score2;
				end if;

		end case;
	end process Transicao;

	score1_out <= score_1;
	score2_out <= score_2;
	led_out    <= reg_ball;

end Behavioral;
