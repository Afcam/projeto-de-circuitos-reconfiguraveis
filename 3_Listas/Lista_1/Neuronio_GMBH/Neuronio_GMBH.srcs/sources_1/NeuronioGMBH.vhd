----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: NeuronioGMBH - Rtl
----------------------------------------------------------------------------------
--! @file NeuronioGMBH.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;

--============================================================================
-- ENTITY declaration for NeuronioGMBH
--============================================================================
--! @brief Implementation of GMBH neuronio
------------------------------------------------------------------------------
entity NeuronioGMBH is
	port (
		reset_in  : in STD_LOGIC;
		clock_in  : in STD_LOGIC;
		start_in  : in STD_LOGIC;
		x_in      : in STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);
		ready_out : out STD_LOGIC;
		fx_out    : out STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0));
end NeuronioGMBH;

--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #NeuronioGMBH.
------------------------------------------------------------------------------
architecture Rtl of NeuronioGMBH is

	constant a : std_logic_vector(FP_WIDTH - 1 downto 0) := "010000001010100000000000000"; --! a= 5.25
	constant b : std_logic_vector(FP_WIDTH - 1 downto 0) := "110000001110100110011001100"; --! b= -7.3
	constant c : std_logic_vector(FP_WIDTH - 1 downto 0) := "010000000000000000000000000"; --! c= 2

	signal Mult_X_out : std_logic_vector(FP_WIDTH - 1 downto 0) := (others => '0');
  signal Mult_A_out : std_logic_vector(FP_WIDTH - 1 downto 0) := (others => '0');
	signal Mult_B_out : std_logic_vector(FP_WIDTH - 1 downto 0) := (others => '0');
	signal Add_C_out  : std_logic_vector(FP_WIDTH - 1 downto 0) := (others => '0');

	signal readymul_x : std_logic := '0';
	signal readymul_A : std_logic := '0';
	signal readymul_B : std_logic := '0';
	signal readyadd_C : std_logic := '0';
	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	Mult_X : multiplierfsm_v2
	port map(
		reset     => reset_in,
		clk       => clock_in,
		op_a      => x_in,
		op_b      => x_in,
		start_i   => start_in,
		mul_out   => Mult_X_out,
		ready_mul => readymul_x
	);

	Mult_B : multiplierfsm_v2
	port map(
		reset     => reset_in,
		clk       => clock_in,
		op_a      => x_in,
		op_b      => b,
		start_i   => start_in,
		mul_out   => Mult_B_out,
		ready_mul => readymul_B
	);

	Mult_A : multiplierfsm_v2
	port map(
		reset     => reset_in,
		clk       => clock_in,
		op_a      => Mult_X_out,
		op_b      => a,
		start_i   => readymul_x,
		mul_out   => Mult_A_out,
		ready_mul => readymul_A
	);

	add_C : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '0', --! op=0 soma  op=1 subtrai
		op_a       => Mult_B_out,
		op_b       => c,
		start_i    => readymul_B,
		addsub_out => Add_C_out,
		ready_as   => readyadd_C
	);

	add_fx : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '0', --! op=0 soma  op=1 subtrai
		op_a       => Mult_A_out,
		op_b       => Add_C_out,
		start_i    => readymul_A,
		addsub_out => fx_out,
		ready_as   => ready_out
	);
end Rtl;
--=============================================================================
-- architecture end
--=============================================================================
