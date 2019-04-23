-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
--
-- Create Date:   07-May-2016
-- Design name:   HPSO
-- Module name:   fpupack
-- Deion:   This package defines types, subtypes and constants
-- Automatically generated using the vHPSOgen.m v1.0
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

PACKAGE fpupack IS

    	CONSTANT FRAC_WIDTH : INTEGER := 18;
    	CONSTANT EXP_WIDTH  : INTEGER := 8;
    	CONSTANT FP_WIDTH   : INTEGER := FRAC_WIDTH + EXP_WIDTH + 1;

    	CONSTANT bias     : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := "01111111";
    	CONSTANT int_bias : INTEGER                                  := 127;
    	CONSTANT int_alin : INTEGER                                  := 255;
    	CONSTANT EXP_DF   : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := "10000010";
    	CONSTANT bias_MAX : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := "10000110";
    	CONSTANT bias_MIN : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := "01110101";
    	CONSTANT EXP_ONE  : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := (OTHERS => '1');
    	CONSTANT EXP_INF  : std_logic_vector(EXP_WIDTH - 1 DOWNTO 0) := "11111111";
    	CONSTANT ZERO_V   : std_logic_vector(FP_WIDTH - 1 DOWNTO 0)  := (OTHERS => '0');

    	CONSTANT s_one     : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111111000000000000000000";
    	CONSTANT s_ten     : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000010010000000000000000";
    	CONSTANT s_twn     : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000011010000000000000000";
    	CONSTANT s_hundred : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000101100100000000000000";
    	CONSTANT s_pi2     : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111111100100100001111110";
    	CONSTANT s_pi      : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000000100100100001111110";
    	CONSTANT s_3pi2    : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000001001011011001011111";
    	CONSTANT s_2pi     : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "010000001100100100001111110";

    	CONSTANT Phyp   : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111111001101001000001111"; --PROD[cosh(atanh(1/2^i))]
    	CONSTANT log2e  : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111111011100010101010001";
    	CONSTANT ilog2e : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111110011000101110010000";
    	CONSTANT d_043  : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "001111010011000010001001101";

    	CONSTANT MAX_ITER_CORDIC : std_logic_vector(4 DOWNTO 0) := "01111";
    	CONSTANT MAX_POLY_MACKLR : std_logic_vector(3 DOWNTO 0) := "0011";

    	CONSTANT OneM  : std_logic_vector(FRAC_WIDTH DOWNTO 0)   := "1000000000000000000";
    	CONSTANT Zero  : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	CONSTANT Inf   : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "011111111000000000000000000";
    	CONSTANT NaN   : std_logic_vector(FP_WIDTH - 1 DOWNTO 0) := "011111111100000000000000000";
    	CONSTANT TSed  : POSITIVE                                := 15;
    	CONSTANT Niter : POSITIVE                                := 3;

    	CONSTANT num_mult_neuronio : INTEGER := 4;
    	SUBTYPE saida_mult IS std_logic_vector(FP_WIDTH - 1 DOWNTO 0);
    	TYPE t_mult IS ARRAY(0 TO num_mult_neuronio - 1) OF saida_mult;
END fpupack;

PACKAGE BODY fpupack IS
END fpupack;
