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

entity Ganho is
    Port ( clock_in     : in  STD_LOGIC;
           reset_in : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           covZ_in : in  STD_LOGIC_VECTOR (26 downto 0);
           covK_in : in  STD_LOGIC_VECTOR (26 downto 0);
           ready_out : out STD_LOGIC;
           ganho_out : out STD_LOGIC_VECTOR (26 downto 0));
end Ganho;

architecture Behavioral of Ganho is

signal ganho : std_logic_vector(26 downto 0) := (others => '0');

--=============================================================================
-- architecture begin
--=============================================================================
begin

	--============================================================================
	-- PROCESS Filtro
	--! @param[in] reset_in: reset to inicial state of led
	--! @param[in] enable_in :
	--============================================================================
  Filtro : process(clock_in, reset_in, enable_in)
    begin
      if (reset_in = '1') then
        ready_out <= '0';
        ganho_out <= "000000000000000000000000000";
      elsif rising_edge(clock_in) then
        if (enable_in = '1') then
          -- divisao
          ready_out <= '1';
        else
          ready_out <= '0';
        end if;
      end if;
      ganho_out <= ganho;
  end process Filtro;


end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
