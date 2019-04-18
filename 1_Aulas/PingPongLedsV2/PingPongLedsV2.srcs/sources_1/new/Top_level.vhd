LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Top_level IS
	PORT
	(
		clk   : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		sw    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		seg   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		an    : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		led   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END Top_level;
ARCHITECTURE Behavioral OF Top_level IS
	COMPONENT Logica
		PORT
		(
			reg    : IN std_logic_vector(15 DOWNTO 0);
			clk    : IN STD_LOGIC;
			reset  : IN STD_LOGIC;
			sw     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			cnt0   : OUT std_logic_vector(3 DOWNTO 0) := "0000";
			cnt1   : OUT std_logic_vector(3 DOWNTO 0) := "0000";
			lr     : OUT STD_LOGIC;
			player : OUT STD_LOGIC;
			enable : OUT STD_LOGIC
		);
	END COMPONENT Logica;
	COMPONENT Registrador
		PORT
		(
			lr       : IN STD_LOGIC;
			reset    : IN STD_LOGIC;
			enable   : IN STD_LOGIC;
			clk_10Hz : IN STD_LOGIC;
			player   : IN STD_LOGIC;
			reg      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT Registrador;
	COMPONENT Display
		PORT
		(
			clk_256Hz : IN STD_LOGIC;
			reset     : IN STD_LOGIC;
			cnt0      : IN std_logic_vector(3 DOWNTO 0) := "0000";
			cnt1      : IN std_logic_vector(3 DOWNTO 0) := "0000";
			seg       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			an        : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT Display;
	SIGNAL cnt_10Hz : INTEGER RANGE 0 TO 5000000 := 0;
	SIGNAL clk_10Hz : std_logic := '0';
	SIGNAL cnt_40Hz : INTEGER RANGE 0 TO 1250000 := 0;
	SIGNAL clk_40Hz : std_logic := '0';
	SIGNAL s_enable : std_logic := '0';
	SIGNAL s_lr     : std_logic := '1';
	SIGNAL s_player : std_logic := '0';
	SIGNAL s_reg    : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL s_cnt0   : std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL s_cnt1   : std_logic_vector(3 DOWNTO 0) := "0000";
	SIGNAL s_an     : unsigned(3 DOWNTO 0) := "0000";
	SIGNAL sel_mux  : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL s_bin    : std_logic_vector(3 DOWNTO 0) := "0000";
BEGIN
	Display_i : Display
	PORT MAP
	(
		clk_256Hz => clk_40Hz,
		reset     => reset,
		cnt0      => s_cnt0,
		cnt1      => s_cnt1,
		seg       => led,
		an        => an
	);
	Registrador_i : Registrador
	PORT MAP
	(
		lr       => s_lr,
		reset    => reset,
		enable   => s_enable,
		clk_10Hz => clk_10Hz,
		player   => s_player,
		reg      => s_reg
	);
	Logica_i : Logica
	PORT MAP
	(
		reg    => s_reg,
		clk    => clk,
		reset  => reset,
		sw     => sw,
		cnt0   => s_cnt0,
		cnt1   => s_cnt1,
		lr     => s_lr,
		player => s_player,
		enable => s_enable
	);
	-- process para dividir o clock 10Hz
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			cnt_10Hz <= 0;
			clk_10Hz <= '0';
		ELSIF rising_edge(clk) THEN
			IF cnt_10Hz = 5000000 THEN
				cnt_10Hz <= 0;
				clk_10Hz <= NOT clk_10Hz;
			ELSE
				cnt_10Hz <= cnt_10Hz + 1;
			END IF;
		END IF;
	END PROCESS;
	-- process para divisor de clock do multiplexador de anodos a 40Hz
	PROCESS (clk, reset)
		BEGIN
			IF reset = '1' THEN
				cnt_40Hz <= 0;
				clk_40Hz <= '0';
			ELSIF rising_edge(clk) THEN
				IF cnt_40Hz = 500000 THEN
					cnt_40Hz <= 0;
					clk_40Hz <= NOT clk_40Hz;
				ELSE
					cnt_40Hz <= cnt_40Hz + 1;
				END IF;
			END IF;
		END PROCESS;
END Behavioral;
