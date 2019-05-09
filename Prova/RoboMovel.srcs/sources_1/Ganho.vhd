---------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:24:50
-- Module Name: Ganho - Behavioral
----------------------------------------------------------------------------------

--! @file Ganho.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;

--============================================================================
-- ENTITY declaration for Ganho.vhd
--============================================================================
--! @brief Calcula o ganho de filtro no instante de tempo k.
--! @details Este modulo implementa a seguinte funçao:
--! ganho_(k+1) = sigma_(k) / (sigma_(k) + sigma_(z))
------------------------------------------------------------------------------
entity Ganho is
	port (
		clock_in  : in STD_LOGIC;                        --! local bus clock
		reset_in  : in STD_LOGIC;                        --! reset =0: reset active reset =1: no reset
		start_in  : in STD_LOGIC;                        --! enable =0: dont run enable =1: start to run
		covZ_in   : in STD_LOGIC_VECTOR (26 downto 0);   --! infravermelho cov error bus
		covK_in   : in STD_LOGIC_VECTOR (26 downto 0);   --! ultrassom cov error bus
		ready_out : out STD_LOGIC;                       --! ready =0: not calculate ready =1: calculated
		ganho_out : out STD_LOGIC_VECTOR (26 downto 0)); --! gain bus
end Ganho;
--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the Ganho for RoboMovel project.
--! @details Optional field
--============================================================================
architecture Behavioral of Ganho is

	signal ready_as   : STD_LOGIC                     := '0';
	signal addsub_out : std_logic_vector(26 downto 0) := (others => '0');
	-- 
	-- signal ganho : std_logic_vector(26 downto 0) := (others => '0');

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin
	addfsm_v6_ganho : addsubfsm_v6
	port map(
		reset      => reset_in,
		clk        => clock_in,
		op         => '0', --! op=0 soma  op=1 subtrai
		op_a       => covK_in,
		op_b       => covZ_in,
		start_i    => start_in,
		addsub_out => addsub_out,
		ready_as   => ready_as);

	divNR_ganho : divNR
	port map(
		reset     => reset_in,
		clk       => clock_in,
		start_i   => ready_as,
		op_a      => covK_in,
		op_b      => addsub_out,
		div_out   => ganho_out,
		ready_div => ready_out);

		-- ganho_out <= ganho;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
