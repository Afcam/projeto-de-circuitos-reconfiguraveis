--------------------------------------------------------------------------------
-- Title       : RoboMovel_tb
-- Project     : RoboMovel
--------------------------------------------------------------------------------
-- File        : RoboMovel_tb.vhd
-- Author      : User Name <user.email@user.company.com>
-- Company     : User Company Name
-- Created     : Wed May  8 12:06:22 2019
-- Last update : Wed May  8 12:06:22 2019
-- Platform    : Default Part Number
-- Standard    : <VHDL-2008 | VHDL-2002 | VHDL-1993 | VHDL-1987>
--------------------------------------------------------------------------------
-- Copyright (c) 2019 User Company Name
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
--! @file RoboMovel_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;

use work.entities.all;
use work.fpupack.all;

-----------------------------------------------------------

entity RoboMovel_tb is
--  Port ( );
end entity RoboMovel_tb;

-----------------------------------------------------------

architecture testbench of RoboMovel_tb is

	-- Testbench DUT generics as constants


	-- Testbench DUT ports as signals
	signal clock_in   : STD_LOGIC;
	signal reset_in   : STD_LOGIC;
	signal start_in   : STD_LOGIC;
	signal xir_in     : STD_LOGIC_VECTOR (26 downto 0);
	signal xul_in     : STD_LOGIC_VECTOR (26 downto 0);
	signal ready_out  : STD_LOGIC;
	signal xfusao_out : STD_LOGIC_VECTOR (26 downto 0);

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

  -- clock_in <= not clock_in after 5 ns;
  -- reset generator
  reset_in <= '0', '1' after 15 ns, '0' after 25 ns;

  -- clock generator
  -- clock_in <= not clk after 5 ns;

	-- RESET_GEN : process
	-- begin
	-- 	reset_in <= '1',
	-- 	         '0' after 20.0*C_CLK_PERIOD * (1 SEC);
	-- 	wait;
	-- end process RESET_GEN;

  -- cria o start
  first_start <= '0', '1' after 55 ns, '0' after 65 ns;

	-----------------------------------------------------------
	-- Testbench Stimulus
	-----------------------------------------------------------
  --============================================================================
	-- PROCESS ROM_XIR
	--============================================================================
  ROM_XIR: process
  file infile	: text is in "bin_xir.txt"; -- input file declaration
  variable inline : line; -- line number declaration
  variable dataf  : std_logic_vector(FP_WIDTH-1 downto 0);
  begin
      while (not endfile(infile)) loop
          wait until rising_edge(clock_in);
              if first_start='1' or ready_out='1' then
                  readline(infile, inline);
                  read(inline,dataf);
                  xir_in <= dataf;
                  start_in <= '1';
              else
                  start_in <= '0';
              end if;
      end loop;
      assert not endfile(infile) report "FIM DA LEITURA" severity warning;
      wait;
  end process;

  --============================================================================
	-- PROCESS ROM_XUL
	--============================================================================
  ROM_XUL: process
  file infile	: text is in "bin_xul.txt"; -- input file declaration
  variable inline : line; -- line number declaration
  variable dataf  : std_logic_vector(FP_WIDTH-1 downto 0);
  begin
      while (not endfile(infile)) loop
          wait until rising_edge(clock_in);
              if first_start='1' or ready_out='1' then
                  readline(infile, inline);
                  read(inline,dataf);
                  xul_in <= dataf;
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
  WOM_fusao : process(clock_in, ready_out)
  variable out_line : line;
  file out_file     : text is out "Resultados_RoboMovel.txt";
  begin
      -- write line to file every clock
      if (rising_edge(clock_in)) then
          if ready_out = '1' then
              write (out_line, xfusao_out);
              writeline (out_file, out_line);
          end if;
      end if;
  end process ;

	-----------------------------------------------------------
	-- Entity Under Test
	-----------------------------------------------------------
	DUT : entity work.RoboMovel
		port map (
			clock_in   => clock_in,
			reset_in   => reset_in,
			start_in   => start_in,
			xir_in     => xir_in,
			xul_in     => xul_in,
			ready_out  => ready_out,
			xfusao_out => xfusao_out
		);

end architecture testbench;
--=============================================================================
-- architecture end
--=============================================================================
