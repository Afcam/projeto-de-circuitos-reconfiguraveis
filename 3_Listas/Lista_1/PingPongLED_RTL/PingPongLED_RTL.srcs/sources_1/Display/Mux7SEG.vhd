----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: Mux7SEG - Behavioral
----------------------------------------------------------------------------------
--! @file Mux7SEG.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for Mux7SEG
--============================================================================
--! @brief Displays Segment mux
------------------------------------------------------------------------------
entity Mux7SEG is
	port
	(
		reset_in : in STD_LOGIC;
		clock_in : in STD_LOGIC;
		binA_in  : in STD_LOGIC_VECTOR (3 downto 0);
		binB_in  : in STD_LOGIC_VECTOR (3 downto 0);
		binC_in  : in STD_LOGIC_VECTOR (3 downto 0);
		binD_in  : in STD_LOGIC_VECTOR (3 downto 0);
		bin_out  : out STD_LOGIC_VECTOR (3 downto 0));
end Mux7SEG;
--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #Mux7SEG.
------------------------------------------------------------------------------
architecture Behavioral of Mux7SEG is

	signal sel : STD_LOGIC_VECTOR (1 downto 0) := "00";
	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	with sel select
		bin_out <= binA_in when "00",
		binB_in when "01",
		binC_in when "10",
		binD_in when others;

	--============================================================================
	-- PROCESS
	--! @param[in] clock_in: Description (why is clock_in in sensitive_list?)
	--! @param[in] reset_in: Description (why is reset_in in sensitive_list?)
	--! Read: #signal_read1,#signal_read2
	--! Update: #signal_updated1,#signal_updated2
	--============================================================================
	process (clock_in, reset_in)
	begin
		if (reset_in = '1') then
			sel <= "00";
		elsif rising_edge(clock_in) then
			sel <= sel + "01";
		end if;
	end process;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
