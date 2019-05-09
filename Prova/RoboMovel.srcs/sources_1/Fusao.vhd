----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:24:50
-- Module Name: Fusao - Behavioral
----------------------------------------------------------------------------------

--! @file Fusao.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;

--============================================================================
-- ENTITY declaration for Erro.vhd
--============================================================================
--! @brief Calcula a estimativa da fusao dos dois sensores em centimetros.
--! @details Este modulo implementa a seguinte funçao:
--! x_fusao = X_UL + gain_(k+1)*(X_IR - X_UL)
------------------------------------------------------------------------------
entity Fusao is
	port (
		clock_in   : in STD_LOGIC;                        --! local bus clock
		reset_in   : in STD_LOGIC;                        --! reset =0: reset active reset =1: no reset
		start_in   : in STD_LOGIC;                        --! enable =0: dont run enable =1: start to run
		xir_in     : in STD_LOGIC_VECTOR (26 downto 0);   --! xir bus
		xul_in     : in STD_LOGIC_VECTOR (26 downto 0);   --! xul bus
		ganho_in   : in STD_LOGIC_VECTOR (26 downto 0);   --! gain bus ganho_(k+1)
		ready_out  : out STD_LOGIC;                       --! ready =0: not calculate ready =1: calculated
		xfusao_out : out STD_LOGIC_VECTOR (26 downto 0)); --! fusao result bus
end Fusao;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the Fusao for RoboMovel project.
--! @details Optional field
--============================================================================
architecture Behavioral of Fusao is

	signal ready_as   : STD_LOGIC                     := '0';
	signal addsub_out : std_logic_vector(26 downto 0) := (others => '0');

	signal ready_mul : STD_LOGIC                     := '0';
	signal mul_out   : std_logic_vector(26 downto 0) := (others => '0');

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	subfsm_v6_fusao : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '1', --! op=0 soma  op=1 subtrai
		op_a       => xir_in,
		op_b       => xul_in,
		start_i    => start_in,
		addsub_out => addsub_out,
		ready_as   => ready_as);

	multiplierfsm_v2_fusao : multiplierfsm_v2
	port map(
		reset     => reset_in,
		clk       => clock_in,
		op_a      => ganho_in,
		op_b      => addsub_out,
		start_i   => ready_as,
		mul_out   => mul_out,
		ready_mul => ready_mul);

	addfsm_v6_fusao : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '0', --! op=0 soma  op=1 subtrai
		op_a       => xul_in,
		op_b       => mul_out,
		start_i    => ready_mul,
		addsub_out => xfusao_out,
		ready_as   => ready_out);

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
