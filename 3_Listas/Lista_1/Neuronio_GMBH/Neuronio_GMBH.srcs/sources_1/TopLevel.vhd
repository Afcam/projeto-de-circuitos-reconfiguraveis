----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: TopLevel - Rtl
----------------------------------------------------------------------------------
--! @file TopLevel.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.fpupack.all;
use work.entities.all;

--============================================================================
-- ENTITY declaration for TopLevel
--============================================================================
--! @brief Top level GMBH neuronio
------------------------------------------------------------------------------
entity TopLevel is
	port (
		reset_in : in STD_LOGIC;
		clock_in : in STD_LOGIC;
		start_in : in STD_LOGIC;
		btnU_in  : in STD_LOGIC;
		btnD_in  : in STD_LOGIC;
		sw_in    : in STD_LOGIC_VECTOR(15 downto 0);
		led_out  : out STD_LOGIC_VECTOR(15 downto 0));
end TopLevel;
--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #TopLevel.
------------------------------------------------------------------------------
architecture Rtl of TopLevel is
	component NeuronioGMBH
		port (
			reset_in  : in STD_LOGIC;
			clock_in  : in STD_LOGIC;
			start_in  : in STD_LOGIC;
			x_in      : in STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);
			ready_out : out STD_LOGIC;
			fx_out    : out STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0)
		);
	end component NeuronioGMBH;

	signal x_in      : STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);
	signal ready_out : STD_LOGIC;
	signal fx_out    : STD_LOGIC_VECTOR (FP_WIDTH - 1 downto 0);

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	NeuronioGMBH_i : NeuronioGMBH
	port map(
		reset_in  => reset_in,
		clock_in  => clock_in,
		start_in  => start_in,
		x_in      => x_in,
		ready_out => ready_out,
		fx_out    => fx_out
	);
  
	with btnD_in select
		led_out <= fx_out(26 downto 11) when '1',
		fx_out(15 downto 0) when others;

    process(clock_in)
    begin
        if rising_edge(clock_in) then
            if btnU_in='1' then
                x_in(26 downto 11) <= sw_in;
            else
                x_in(10 downto 0) <= sw_in(15 downto 5);
            end if;
        end if;
    end process;


end Rtl;
--=============================================================================
-- architecture end
--=============================================================================
