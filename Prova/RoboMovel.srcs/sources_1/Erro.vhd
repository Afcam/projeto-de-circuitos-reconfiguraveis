----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:50:23
-- Module Name: Erro - Behavioral
----------------------------------------------------------------------------------
--! @file Erro.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;

--============================================================================
-- ENTITY declaration for Erro.vhd
--============================================================================
--! @brief Calcula o erro de covariância associado ao sensor de ultrasom no
--! instante K+1.
--! @details Este modulo implementa a seguinte funçao:
--! sigma_(k+1) = sigma_(k) - ganho(k+1)*sigma_(k)
------------------------------------------------------------------------------
entity Erro is
	port (
		clock_in  : in STD_LOGIC;                        --! local bus clock
		reset_in  : in STD_LOGIC;                        --! reset =0: reset active reset =1: no reset
		start_in  : in STD_LOGIC;                        --! start =0: dont run start =1: start to run
		ganho_in  : in STD_LOGIC_VECTOR (26 downto 0);   --! gain bus ganho_(k+1)
		covK_in   : in STD_LOGIC_VECTOR (26 downto 0);   --! Old sigma_(k) value
		ready_out : out STD_LOGIC;                       --! ready =0: not calculate ready =1: calculated
		covK_out  : out STD_LOGIC_VECTOR (26 downto 0)); --! New sigma_(k+1) value
end Erro;
--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the Erro for RoboMovel project.
--! @details Optional field
--============================================================================
architecture Behavioral of Erro is
	signal ready : STD_LOGIC                     := '0';
	signal covK  : std_logic_vector(26 downto 0) := (others => '0');

	signal ready_mul : STD_LOGIC                     := '0';
	signal mul_out   : std_logic_vector(26 downto 0) := (others => '0');

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	multiplierfsm_v2_erro : multiplierfsm_v2
	port map(
		reset     => reset_in,
		clk       => clock_in,
		op_a      => ganho_in,
		op_b      => covK_in,
		start_i   => start_in,
		mul_out   => mul_out,
		ready_mul => ready_mul);

	subfsm_v6_erro : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '1',
		op_a       => covK_in,
		op_b       => mul_out,
		start_i    => ready_mul,
		addsub_out => covK_out,
		ready_as   => ready_out);

	-- covK_out  <= covK;
	-- ready_out <= ready;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
