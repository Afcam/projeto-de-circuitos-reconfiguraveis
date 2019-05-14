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

	signal ready_out_ganho : STD_LOGIC                      := '0';
	signal ready_out_erro  : STD_LOGIC                      := '0';
	signal ready_out_fusao : STD_LOGIC                      := '0';

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
		ready_out => ready_out_ganho,
		ganho_out => gain
	);

	Fusao_i : Fusao
	port map(
		clock_in   => clock_in,
		reset_in   => reset_in,
		start_in   => ready_out_ganho,
		xir_in     => xir_in,
		xul_in     => xul_in,
		ganho_in   => gain,
		ready_out  => ready_out_fusao,
		xfusao_out => xfusao_out
	);

	Erro_i : Erro
	port map(
		clock_in  => clock_in,
		reset_in  => reset_in,
		start_in  => ready_out_ganho,
		ganho_in  => gain,
		covK_in   => covK,
		ready_out => ready_out_erro,
		covK_out  => covK_new
	);


	--============================================================================
	-- PROCESS updateReadyFusao
	--! @brief It describes the operations realized in the states of the FSM.
	--! @param[in] clock_in: Clock signal. Process triggered by rising edge.
	--! @param[in] ready_out_fusao: Signal to set output
	--! @param[in] start_in: Signal to reset the xfusao_out
	--! Read: #clock_in, #ready_out_fusao, #start_in.
	--! Update: #ready_fusao.
	--============================================================================
	-- updateReadyFusao : process (reset_in,clock_in, ready_out_fusao, start_in)
	-- begin
	-- 	if (reset_in = '1') or (start_in = '1') then
	-- 		ready_fusao <= '0';
	-- 	elsif rising_edge(clock_in) then
	-- 		if ready_out_fusao = '1' then
	-- 			ready_fusao <= '1';
	-- 		end if;
	-- 	end if;
	-- end process updateReadyFusao;

	--============================================================================
	-- PROCESS updateReadyErro
	--! @brief It describes the operations realized in the states of the FSM.
	--! @param[in] clock_in: Clock signal. Process triggered by rising edge.
	--! @param[in] ready_out_erro: Signal to set output
	--! @param[in] start_in: Signal to reset the xfusao_out
	--! Read: #clock_in, #ready_out_erro, #start_in.
	--! Update: #ready_erro.
	--============================================================================
	updateReadyErro : process (reset_in, clock_in, ready_out_erro, start_in)
	begin
		if (reset_in = '1') or (start_in = '1') then
			ready_erro <= '0';
		elsif rising_edge(clock_in) then
			if ready_out_erro = '1' then
				ready_erro <= '1';
			end if;
		end if;
	end process updateReadyErro;

	--============================================================================
	-- PROCESS updateReadyErro
	--! @brief It describes the operations realized in the states of the FSM.
	--! @param[in] clock_in: Clock signal. Process triggered by rising edge.
	--! @param[in] ready_fusao: Signal to set output.
	--! @param[in] ready_erro: Signal to set output.
	--! @param[in] start_in: Signal to reset the xfusao_out.
	--! @param[in] reset_in: Asynchronous reset. When it is high, the system is
	--!                      initialized.
	--! Read: #clock_in, #ready_fusao, #ready_erro, #start_in.
	--! Update: #ready_out, #covK.
	--============================================================================
	updatefusao_out : process (reset_in, clock_in, ready_fusao, ready_erro, start_in,ready_out_fusao)
	begin
		if (reset_in = '1') then
			covK <= covK_init;
			-- ready_out   <= '0';
		elsif rising_edge(clock_in) then
			if (ready_out_fusao = '1') then
				-- ready_out <= '1';
				covK <= covK_new;
			end if;
		end if;
	end process updatefusao_out;
ready_out<=  ready_out_fusao;
-- covK <= covK_new;
end Rtl;
-- --=============================================================================
-- architecture end
--=============================================================================
