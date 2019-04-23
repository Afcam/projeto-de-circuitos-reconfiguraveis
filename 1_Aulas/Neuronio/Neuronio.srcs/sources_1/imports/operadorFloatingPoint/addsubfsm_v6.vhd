-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MU�OZ ARBOLEDA
--
-- Create Date:   27-Apr-2015
-- Design name:   addsub
-- Module name:   addsub - behavioral
-- Description:   addition subtraction in floating-point
-- Automatically generated using the vFPUgen.m v1.0
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.fpupack.ALL;

ENTITY addsubfsm_v6 IS
    	PORT
    	(
    	    	reset      : IN std_logic;
    	    	clk        : IN std_logic;
    	    	op         : IN std_logic;
    	    	op_a       : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	op_b       : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	start_i    : IN std_logic;
    	    	addsub_out : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	    	ready_as   : OUT std_logic);
END addsubfsm_v6;

ARCHITECTURE Behavioral OF addsubfsm_v6 IS

    	SIGNAL comp_ab  : std_logic := '0';
    	SIGNAL comp_eq  : std_logic := '0';
    	SIGNAL compe_ab : std_logic := '0';
    	SIGNAL compe_eq : std_logic := '0';

    	SIGNAL sA     : std_logic                    := '0';
    	SIGNAL auxor  : std_logic_vector(2 DOWNTO 0) := "000";
    	SIGNAL oper   : std_logic                    := '0';
    	SIGNAL s_sign : std_logic                    := '0';

    	SIGNAL s_exp     : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0)  := (OTHERS => '0');
    	SIGNAL s_opa     : std_logic_vector(FRAC_WIDTH DOWNTO 0)     := (OTHERS => '0');
    	SIGNAL s_opb     : std_logic_vector(FRAC_WIDTH DOWNTO 0)     := (OTHERS => '0');
    	SIGNAL res_man   : std_logic_vector(FRAC_WIDTH + 1 DOWNTO 0) := (OTHERS => '0');
    	SIGNAL s_res_man : std_logic_vector(FRAC_WIDTH + 1 DOWNTO 0) := (OTHERS => '0');

    	SIGNAL update : std_logic;
    	TYPE t_state IS (waiting, addsub, output);
    	SIGNAL state, pr_state : t_state;

BEGIN

    	-- processo para comparar expoentes
    	PROCESS (op_a, op_b)
    	BEGIN
    	    	IF op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) > op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) THEN
    	    	    	compe_ab <= '1';
    	    	    	s_exp    <= op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH);
    	    	ELSE
    	    	    	compe_ab <= '0';
    	    	    	s_exp    <= op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH);
    	    	END IF;
    	END PROCESS;

    	-- processo de igualdade de expoentes
    	PROCESS (op_a, op_b)
    	BEGIN
    	    	IF op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) = op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) THEN
    	    	    	compe_eq <= '1';
    	    	ELSE
    	    	    	compe_eq <= '0';
    	    	END IF;
    	END PROCESS;

    	-- processo para comparar magnitude dos numeros
    	PROCESS (op_a, op_b)
    	BEGIN
    	    	IF op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO 0) > op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO 0) THEN
    	    	    	comp_ab <= '1';
    	    	ELSE
    	    	    	comp_ab <= '0';
    	    	END IF;
    	END PROCESS;

    	-- processo de igualdade dos numeros
    	PROCESS (op_a, op_b, compe_eq)
    	BEGIN
    	    	IF op_a(FRAC_WIDTH - 1 DOWNTO 0) = op_b(FRAC_WIDTH - 1 DOWNTO 0) THEN
    	    	    	IF compe_eq = '1' THEN
    	    	    	    	comp_eq <= '1';
    	    	    	ELSE
    	    	    	    	comp_eq <= '0';
    	    	    	END IF;
    	    	ELSE
    	    	    	comp_eq <= '0';
    	    	END IF;
    	END PROCESS;

    	sA <= op_a(FRAC_WIDTH + EXP_WIDTH);
    	--oper    <= (op xor (op_a(FP_WIDTH-1) xor op_b(FP_WIDTH-1)));
    	auxor <= op & op_a(FP_WIDTH - 1) & op_b(FP_WIDTH - 1);
    	WITH auxor SELECT
    	    	oper <= '0' WHEN "000",
    	    	'1' WHEN "001",
    	    	'1' WHEN "010",
    	    	'0' WHEN "011",
    	    	'1' WHEN "100",
    	    	'0' WHEN "101",
    	    	'0' WHEN "110",
    	    	'1' WHEN OTHERS;

    	-- processo para calcular signo
    	PROCESS (reset, clk)
    	    	VARIABLE sl : std_logic := '0';
    	BEGIN
    	    	IF rising_edge(clk) THEN
    	    	    	IF reset = '1' THEN
    	    	    	    	s_sign <= '0';
    	    	    	    	sl := '0';
    	    	    	ELSE
    	    	    	    	sl := (op_a(FP_WIDTH - 1) XOR op_b(FP_WIDTH - 1));
    	    	    	    	IF (op = '0' AND sl = '0' AND sA = '0' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '0' AND sl = '0' AND sA = '0' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '0' AND sl = '0' AND sA = '1' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '0' AND sl = '0' AND sA = '1' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '0' AND sl = '1' AND sA = '0' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '0' AND sl = '1' AND sA = '0' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '0' AND sl = '1' AND sA = '1' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '0' AND sl = '1' AND sA = '1' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '1' AND sl = '0' AND sA = '0' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '1' AND sl = '0' AND sA = '0' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '1' AND sl = '0' AND sA = '1' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '1' AND sl = '0' AND sA = '1' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '1' AND sl = '1' AND sA = '0' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '1' AND sl = '1' AND sA = '0' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '0';
    	    	    	    	ELSIF (op = '1' AND sl = '1' AND sA = '1' AND comp_ab = '0') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSIF (op = '1' AND sl = '1' AND sA = '1' AND comp_ab = '1') THEN
    	    	    	    	    	s_sign <= '1';
    	    	    	    	ELSE
    	    	    	    	    	s_sign <= '0';
    	    	    	    	END IF;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

    	-- processo para calcular alineamento das mantisas segundo diferencia de expoentes
    	PROCESS (op_a, op_b, compe_eq, compe_ab)
    	    	VARIABLE sub_exp : INTEGER RANGE 0 TO int_alin := 0;
    	BEGIN
    	    	IF compe_eq = '1' THEN
    	    	    	sub_exp := 0;
    	    	    	IF op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) = 0 THEN -- exception when 0+0 or 0-0
    	    	    	    	s_opa <= '0' & op_a(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	    	s_opb <= '0' & op_b(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	ELSE
    	    	    	    	s_opa <= '1' & op_a(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	    	s_opb <= '1' & op_b(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	END IF;
    	    	ELSIF compe_ab = '1' THEN
    	    	    	sub_exp := conv_integer(op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) - (op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH)));
    	    	    	s_opa <= '1' & op_a(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	s_opb <= to_stdlogicvector(to_bitvector('1' & op_b(FRAC_WIDTH - 1 DOWNTO 0)) SRL sub_exp);
    	    	ELSE
    	    	    	sub_exp := conv_integer(op_b(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) - (op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH)));
    	    	    	s_opb <= '1' & op_b(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	s_opa <= to_stdlogicvector(to_bitvector('1' & op_a(FRAC_WIDTH - 1 DOWNTO 0)) SRL sub_exp);
    	    	END IF;
    	END PROCESS;

    	-- processo para somar ou substrair as mantissas
    	PROCESS (s_opa, s_opb, oper, comp_ab)
    	BEGIN
    	    	IF oper = '0' THEN
    	    	    	s_res_man <= '0' & s_opa + s_opb;
    	    	ELSIF comp_ab = '1' THEN
    	    	    	s_res_man <= '0' & s_opa - s_opb;
    	    	ELSE
    	    	    	s_res_man <= '0' & s_opb - s_opa;
    	    	END IF;
    	END PROCESS;

    	-- registro intermediario
    	PROCESS (reset, clk)
    	BEGIN
    	    	IF rising_edge(clk) THEN
    	    	    	IF reset = '1' THEN
    	    	    	    	res_man <= (OTHERS => '0');
    	    	    	ELSE
    	    	    	    	res_man <= s_res_man;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

    	-- processo para normalizar resultado da mantisa quando necessario
    	PROCESS (clk, reset)
    	    	VARIABLE pos       : INTEGER RANGE 0 TO FRAC_WIDTH             := 0;
    	    	VARIABLE sign      : std_logic                                 := '0';
    	    	VARIABLE s_res_exp : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0)  := (OTHERS => '0');
    	    	VARIABLE out_man   : std_logic_vector(FRAC_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	BEGIN
    	    	IF rising_edge(clk) THEN
    	    	    	IF reset = '1' THEN
    	    	    	    	sign      := '0';
    	    	    	    	s_res_exp := (OTHERS  => '0');
    	    	    	    	out_man   := (OTHERS  => '0');
    	    	    	    	addsub_out <= (OTHERS => '0');
    	    	    	ELSE
    	    	    	    	IF update = '1' THEN
    	    	    	    	    	IF oper = '0' AND res_man(FRAC_WIDTH + 1) = '1' THEN
    	    	    	    	    	    	sign      := s_sign;
    	    	    	    	    	    	s_res_exp := s_exp + '1';
    	    	    	    	    	    	out_man   := res_man(FRAC_WIDTH DOWNTO 1);
    	    	    	    	    	ELSE
    	    	    	    	    	    	IF comp_eq = '1' AND oper = '0' THEN
    	    	    	    	    	    	    	sign      := s_sign;
    	    	    	    	    	    	    	s_res_exp := op_a(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH);
    	    	    	    	    	    	    	out_man   := op_a(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	    	    	    	ELSIF comp_eq = '1' AND oper = '1' THEN
    	    	    	    	    	    	    	sign      := '0';
    	    	    	    	    	    	    	s_res_exp := (OTHERS => '0');
    	    	    	    	    	    	    	out_man   := (OTHERS => '0');
    	    	    	    	    	    	ELSIF res_man(FRAC_WIDTH) = '1' THEN
    	    	    	    	    	    	    	sign      := s_sign;
    	    	    	    	    	    	    	s_res_exp := s_exp;
    	    	    	    	    	    	    	out_man   := res_man(FRAC_WIDTH - 1 DOWNTO 0);
    	    	    	    	    	    	ELSE
    	    	    	    	    	    	    	sign := s_sign;
    	    	    	    	    	    	    	FOR i IN 1 TO FRAC_WIDTH LOOP
    	    	    	    	    	    	    	    	pos := i;
    	    	    	    	    	    	    	    	EXIT WHEN res_man(FRAC_WIDTH - i) = '1';
    	    	    	    	    	    	    	END LOOP;
    	    	    	    	    	    	    	s_res_exp := s_exp - CONV_STD_LOGIC_VECTOR(pos, EXP_WIDTH);
    	    	    	    	    	    	    	out_man   := to_stdlogicvector(to_bitvector(res_man(FRAC_WIDTH - 1 DOWNTO 0)) SLL pos);
    	    	    	    	    	    	END IF;
    	    	    	    	    	END IF;
    	    	    	    	    	addsub_out(FRAC_WIDTH + EXP_WIDTH)                       <= sign;
    	    	    	    	    	addsub_out(FRAC_WIDTH + EXP_WIDTH - 1 DOWNTO FRAC_WIDTH) <= s_res_exp(EXP_WIDTH - 1 DOWNTO 0);
    	    	    	    	    	addsub_out(FRAC_WIDTH - 1 DOWNTO 0)                      <= out_man;
    	    	    	    	END IF;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

    	-- processo para actualizar estado
    	actualiza : PROCESS (clk, reset)
    	BEGIN
    	    	IF rising_edge(clk) THEN
    	    	    	IF reset = '1' THEN
    	    	    	    	state <= waiting;
    	    	    	ELSE
    	    	    	    	state <= pr_state;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

    	-- processo principal: FSM
    	principal : PROCESS (state, start_i)
    	BEGIN
    	    	CASE state IS
    	    	    	WHEN waiting =>
    	    	    	    	ready_as <= '0';
    	    	    	    	update   <= '0';
    	    	    	    	IF start_i = '1' THEN
    	    	    	    	    	pr_state <= addsub;
    	    	    	    	ELSE
    	    	    	    	    	pr_state <= waiting;
    	    	    	    	END IF;
    	    	    	WHEN addsub =>
    	    	    	    	ready_as <= '0';
    	    	    	    	update   <= '1';
    	    	    	    	pr_state <= output;
    	    	    	WHEN output =>
    	    	    	    	ready_as <= '1';
    	    	    	    	update   <= '0';
    	    	    	    	pr_state <= waiting;
    	    	    	WHEN OTHERS =>
    	    	    	    	ready_as <= '0';
    	    	    	    	update   <= '0';
    	    	    	    	pr_state <= waiting;
    	    	END CASE;
    	END PROCESS;

END Behavioral;
