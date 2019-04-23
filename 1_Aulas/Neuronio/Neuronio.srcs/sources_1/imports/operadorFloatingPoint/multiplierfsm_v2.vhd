----------------------------------------------------------------------------------
-- Company: 		 GRACO
-- Engineer: 		 Daniel Mauricio Mu�oz
--
-- Create Date:    11:20:25 03/25/2011
-- Design Name:
-- Module Name:    miltiplierfsm_v2 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.fpupack.ALL;

ENTITY multiplierfsm_v2 IS
    	PORT
    	(
    	    	reset     : IN std_logic;
    	    	clk       : IN std_logic;
    	    	op_a      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	op_b      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	start_i   : IN std_logic;
    	    	mul_out   : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	ready_mul : OUT std_logic);
END multiplierfsm_v2;

ARCHITECTURE Behavioral OF multiplierfsm_v2 IS
    	SIGNAL s_add_exp : std_logic_vector(EXP_WIDTH DOWNTO 0);
    	SIGNAL s_mul_out : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	SIGNAL s_mul_man : std_logic_vector((FRAC_WIDTH * 2) + 1 DOWNTO 0);
    	SIGNAL update    : std_logic;
    	TYPE t_state IS (waiting, postmul, exception);
    	SIGNAL state, pr_state : t_state;

BEGIN

    	PROCESS (clk, reset)
    	BEGIN
    	    	IF rising_edge(clk) THEN
    	    	    	IF reset = '1' THEN
    	    	    	    	state     <= waiting;
    	    	    	    	mul_out   <= (OTHERS => '0');
    	    	    	    	ready_mul <= '0';
    	    	    	ELSE
    	    	    	    	state     <= pr_state;
    	    	    	    	ready_mul <= '0';
    	    	    	    	IF update = '1' THEN
    	    	    	    	    	mul_out   <= s_mul_out;
    	    	    	    	    	ready_mul <= '1';
    	    	    	    	END IF;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

    	PROCESS (op_a, op_b, start_i, state)
    	    	VARIABLE v_add_exp : std_logic_vector(EXP_WIDTH DOWNTO 0);
    	    	VARIABLE s_exponen : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0);
    	    	VARIABLE s_mantisa : std_logic_vector(FRAC_WIDTH - 1 DOWNTO 0);
    	BEGIN
    	    	update <= '0';
    	    	CASE state IS
    	    	    	WHEN waiting         =>
    	    	    	    	s_exponen := (OTHERS => '0');
    	    	    	    	s_mantisa := (OTHERS => '0');
    	    	    	    	v_add_exp := (OTHERS => '0');
    	    	    	    	s_mul_out <= (OTHERS => '0');
    	    	    	    	IF start_i = '1' THEN
    	    	    	    	    	IF op_a(FP_WIDTH - 2 DOWNTO 0) = 0 OR op_b(FP_WIDTH - 2 DOWNTO 0) = 0 THEN --(others => '0') or op_b = (others => '0') then
    	    	    	    	    	    	update   <= '0';
    	    	    	    	    	    	pr_state <= exception;
    	    	    	    	    	ELSE
    	    	    	    	    	    	update   <= '0';
    	    	    	    	    	    	pr_state <= postmul;
    	    	    	    	    	END IF;
    	    	    	    	ELSE
    	    	    	    	    	update   <= '0';
    	    	    	    	    	pr_state <= waiting;
    	    	    	    	END IF;

    	    	    	WHEN postmul =>
    	    	    	    	IF s_mul_man((FRAC_WIDTH * 2) + 1) = '1' THEN
    	    	    	    	    	v_add_exp := s_add_exp + '1';
    	    	    	    	    	s_mantisa := s_mul_man(FRAC_WIDTH * 2 DOWNTO FRAC_WIDTH + 1);
    	    	    	    	ELSE
    	    	    	    	    	v_add_exp := s_add_exp;
    	    	    	    	    	s_mantisa := s_mul_man((FRAC_WIDTH * 2) - 1 DOWNTO FRAC_WIDTH);
    	    	    	    	END IF;

    	    	    	    	IF s_add_exp(EXP_WIDTH) = '1' OR s_add_exp(EXP_WIDTH - 1 DOWNTO 0) = EXP_ONE OR op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) = EXP_ONE OR op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) = EXP_ONE THEN -- infinite
    	    	    	    	    	v_add_exp(EXP_WIDTH - 1 DOWNTO 0) := (OTHERS => '1');                                                                                                                                                             --"11111111";
    	    	    	    	    	s_mantisa                         := (OTHERS => '0');                                                                                                                                                             --"00000000000000000000000";  -- (others => '0');
    	    	    	    	END IF;
    	    	    	    	s_exponen := v_add_exp(EXP_WIDTH - 1 DOWNTO 0);
    	    	    	    	s_mul_out(FP_WIDTH - 1)                                 <= op_a(FP_WIDTH - 1) XOR op_b(FP_WIDTH - 1);
    	    	    	    	s_mul_out(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) <= s_exponen;
    	    	    	    	s_mul_out(FRAC_WIDTH - 1 DOWNTO 0)                      <= s_mantisa;
    	    	    	    	update                                                  <= '1';
    	    	    	    	pr_state                                                <= waiting;

    	    	    	WHEN exception       =>
    	    	    	    	s_exponen := (OTHERS => '0');
    	    	    	    	s_mantisa := (OTHERS => '0');
    	    	    	    	v_add_exp := (OTHERS => '0');
    	    	    	    	s_mul_out <= (OTHERS => '0');
    	    	    	    	update    <= '1';
    	    	    	    	pr_state  <= waiting;

    	    	    	WHEN OTHERS          =>
    	    	    	    	s_exponen := (OTHERS => '0');
    	    	    	    	s_mantisa := (OTHERS => '0');
    	    	    	    	v_add_exp := (OTHERS => '0');
    	    	    	    	s_mul_out <= (OTHERS => '0');
    	    	    	    	update    <= '0';
    	    	    	    	pr_state  <= waiting;

    	    	END CASE;
    	END PROCESS;

    	--	s_mul_man <= op_a(FRAC_WIDTH-1 downto 0) * op_b(FRAC_WIDTH-1 downto 0);
    	s_mul_man <= ('1' & op_a(FRAC_WIDTH - 1 DOWNTO 0)) * ('1' & op_b(FRAC_WIDTH - 1 DOWNTO 0));
    	s_add_exp <= ('0' & op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH)) + ('0' & op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH)) - bias;
END Behavioral;
