-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   04-Sep-2012
-- Design name:   FPUs
-- Module name:   entities
-- Deion:   package defining IO of the components
-- Automatically generated using the vFPU_gen.m v1.0
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.fpupack.ALL;

PACKAGE Entities IS

	COMPONENT lfsr_fixtofloat_20bits IS
		PORT
		(
			reset    : IN std_logic;
			clk      : IN std_logic;
			start    : IN std_logic;
			istart   : IN std_logic;
			init     : IN std_logic_vector(15 DOWNTO 0);
			lfsr_out : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			ready    : OUT std_logic);
	END COMPONENT;

	COMPONENT addsubfsm_v6 IS
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
	END COMPONENT;

	COMPONENT multiplierfsm_v2 IS
		PORT
		(
			reset     : IN std_logic;
			clk       : IN std_logic;
			op_a      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			op_b      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			start_i   : IN std_logic;
			mul_out   : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			ready_mul : OUT std_logic);
	END COMPONENT;

	COMPONENT fixMul IS
		PORT
		(
			op_a    : IN std_logic_vector(FRAC_WIDTH DOWNTO 0);
			op_b    : IN std_logic_vector(FRAC_WIDTH DOWNTO 0);
			mul_out : OUT std_logic_vector(FRAC_WIDTH * 2 + 1 DOWNTO 0));
	END COMPONENT;

	COMPONENT divNR IS
		PORT
		(
			reset     : IN std_logic;
			clk       : IN std_logic;
			op_a      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			op_b      : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			start_i   : IN std_logic;
			div_out   : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			ready_div : OUT std_logic);
	END COMPONENT;

	COMPONENT cordic_exp
		PORT
		(
			reset : IN std_logic;
			clk   : IN std_logic;
			start : IN std_logic;
			Ain   : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			exp   : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			ready : OUT std_logic);
	END COMPONENT;

	COMPONENT decFP IS
		PORT
		(
			reset : IN std_logic;
			start : IN std_logic;
			clk   : IN std_logic;
			Xin   : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			quad  : OUT std_logic_vector(1 DOWNTO 0);
			decX  : OUT std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			ready : OUT std_logic);
	END COMPONENT;

	COMPONENT serialcoms
		PORT
		(
			reset    : IN std_logic;
			clk      : IN std_logic;
			start    : IN std_logic;
			d1       : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			d2       : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			d3       : IN std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
			din      : IN std_logic;
			data     : OUT std_logic_vector(7 DOWNTO 0);
			rdy_data : OUT std_logic;
			dout     : OUT std_logic);
	END COMPONENT;

	COMPONENT neuronio
		PORT
		(
			clk   : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			start : IN STD_LOGIC;
			x     : IN t_mult;
			w     : IN t_mult;
			bias  : IN STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0);
			saida : OUT STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0);
			ready : OUT STD_LOGIC);
	END COMPONENT;

END Entities;
