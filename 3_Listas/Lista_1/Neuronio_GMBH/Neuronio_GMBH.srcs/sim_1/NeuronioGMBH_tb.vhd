----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: NeuronioGMBH_tb - testbench
----------------------------------------------------------------------------------
--! @file NeuronioGMBH_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;

use work.entities.all;
use work.fpupack.all;

-----------------------------------------------------------

entity NeuronioGMBH_tb is
	--  Port ( );
end entity NeuronioGMBH_tb;

-----------------------------------------------------------

architecture testbench of NeuronioGMBH_tb is

	-- Testbench DUT ports as signals
	signal reset_in  : STD_LOGIC;
	signal clock_in  : STD_LOGIC;
	signal start_in  : STD_LOGIC;
	signal x_in      : STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);
	signal ready_out : STD_LOGIC;
	signal fx_out    : STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);

	signal first_start : std_logic := '0';

	-- Other constants
	constant C_CLK_PERIOD : real := 10.0e-9; -- NS

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin
	-----------------------------------------------------------
	-- Clocks and Reset and Fist Start
	-----------------------------------------------------------
	CLK_GEN : process
	begin
		clock_in <= '1';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
		clock_in <= '0';
		wait for C_CLK_PERIOD / 2.0 * (1 SEC);
	end process CLK_GEN;

	-- reset generator
	reset_in <= '0', '1' after 15 ns, '0' after 25 ns;

	-- cria o start
	first_start <= '0', '1' after 55 ns, '0' after 65 ns;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
	--============================================================================
	-- PROCESS ROM_X
	--============================================================================
	ROM_X : process
		file infile     : text is in "binX.txt"; -- input file declaration
		variable inline : line;                  -- line number declaration
		variable dataf  : std_logic_vector(FP_WIDTH - 1 downto 0);
	begin
		while (not endfile(infile)) loop
			wait until rising_edge(clock_in);
			if first_start = '1' or ready_out = '1' then
				readline(infile, inline);
				read(inline, dataf);
				x_in     <= dataf;
				start_in <= '1';
			else
				start_in <= '0';
			end if;
		end loop;
		assert not endfile(infile) report "FIM DA LEITURA" severity warning;
		wait;
	end process;

	--============================================================================
	-- PROCESS WOM_fusao
	--============================================================================
	WOM_Fx : process (clock_in, ready_out)
		variable out_line : line;
		file out_file     : text is out "res_neuron.txt";
	begin
		-- write line to file every clock
		if (rising_edge(clock_in)) then
			if ready_out = '1' then
				write (out_line, fx_out);
				writeline (out_file, out_line);
			end if;
		end if;
	end process;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.NeuronioGMBH
	port map
	(
		reset_in  => reset_in,
		clock_in  => clock_in,
		start_in  => start_in,
		x_in      => x_in,
		ready_out => ready_out,
		fx_out    => fx_out
	);
end architecture testbench;
--=============================================================================
-- architecture end
--=============================================================================
