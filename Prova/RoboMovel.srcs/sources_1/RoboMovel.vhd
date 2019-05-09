----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:24:50
-- Module Name: RoboMovel - Rtl
----------------------------------------------------------------------------------

--! @file RoboMovel.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;
--============================================================================
-- ENTITY declaration for RoboMovel.vhd
--============================================================================
--! @brief Realizar a fusao sensorial de dois sensores no intuito de melhorar a
--! estimativa do valor de distancia medida pelo robo.
------------------------------------------------------------------------------
entity RoboMovel is
	port (
		clock_in   : in STD_LOGIC;
		reset_in   : in STD_LOGIC;
		start_in   : in STD_LOGIC;
		xir_in     : in STD_LOGIC_VECTOR (26 downto 0);
		xul_in     : in STD_LOGIC_VECTOR (26 downto 0);
		ready_out  : out STD_LOGIC;
		xfusao_out : out STD_LOGIC_VECTOR (26 downto 0));
end RoboMovel;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the RoboMovel for RoboMovel project.
--! @details Optional field
--============================================================================
architecture Rtl of RoboMovel is
	component Erro
		port (
			clock_in  : in STD_LOGIC;
			reset_in  : in STD_LOGIC;
			start_in  : in STD_LOGIC;
			ganho_in  : in STD_LOGIC_VECTOR (26 downto 0);
			covK_in   : in STD_LOGIC_VECTOR (26 downto 0);
			ready_out : out STD_LOGIC;
			covK_out  : out STD_LOGIC_VECTOR (26 downto 0)
		);
	end component Erro;

	component Ganho
		port (
			clock_in  : in STD_LOGIC;
			reset_in  : in STD_LOGIC;
			start_in  : in STD_LOGIC;
			covZ_in   : in STD_LOGIC_VECTOR (26 downto 0);
			covK_in   : in STD_LOGIC_VECTOR (26 downto 0);
			ready_out : out STD_LOGIC;
			ganho_out : out STD_LOGIC_VECTOR (26 downto 0)
		);
	end component Ganho;

	component Fusao
		port (
			clock_in   : in STD_LOGIC;
			reset_in   : in STD_LOGIC;
			start_in   : in STD_LOGIC;
			xir_in     : in STD_LOGIC_VECTOR (26 downto 0);
			xul_in     : in STD_LOGIC_VECTOR (26 downto 0);
			ganho_in   : in STD_LOGIC_VECTOR (26 downto 0);
			ready_out  : out STD_LOGIC;
			xfusao_out : out STD_LOGIC_VECTOR (26 downto 0)
		);
	end component Fusao;

	signal ready_ganho : STD_LOGIC                      := '0';
	signal ready_erro  : STD_LOGIC                      := '0';
	signal ready_fusao : STD_LOGIC                      := '0';
	signal gain        : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');

	signal covK        : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
	signal covK_new    : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
	constant covK_init : STD_LOGIC_VECTOR (26 downto 0) := "001111011100110011001100110";

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin
	Ganho_i : Ganho
	port map(
		clock_in  => clock_in,
		reset_in  => reset_in,
		start_in  => start_in,
		covZ_in   => "001111110000000000000000000", --! 0.5
		covK_in   => covK,
		ready_out => ready_ganho,
		ganho_out => gain
	);

	Fusao_i : Fusao
	port map(
		clock_in   => clock_in,
		reset_in   => reset_in,
		start_in   => ready_ganho,
		xir_in     => xir_in,
		xul_in     => xul_in,
		ganho_in   => gain,
		ready_out  => ready_fusao,
		xfusao_out => xfusao_out
	);

	Erro_i : Erro
	port map(
		clock_in  => clock_in,
		reset_in  => reset_in,
		start_in  => ready_fusao,
		ganho_in  => gain,
		covK_in   => covK,
		ready_out => ready_erro,
		covK_out  => covK_new
	);

	--============================================================================
	-- PROCESS Covariance
	--! @param[in] reset_in: reset to constatn value of covK = 0.1
	--============================================================================
	Covariance : process (reset_in, clock_in)
	begin
		if reset_in = '1' then
			covK <= covK_init;
		elsif rising_edge(clock_in) then
			if ready_erro = '1' then
				covK <= covK_new;
				-- else
				--   covK <= covk;
			end if;
		end if;
	end process Covariance;
	--
	-- -- ready_out<= ready_erro and ready_fusao ;
	ready_out <= ready_erro;
end Rtl;
--=============================================================================
-- architecture end
--=============================================================================
