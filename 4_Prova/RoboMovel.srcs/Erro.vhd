----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07.05.2019 08:50:23
-- Design Name:
-- Module Name: Erro - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
--! @file Erro.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Erro is
    Port ( clock_in : in STD_LOGIC;
           reset_in : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           ganho_in : in STD_LOGIC_VECTOR (26 downto 0);
           covK_in : in  STD_LOGIC_VECTOR (26 downto 0);
           ready_out : out STD_LOGIC;
           covK_out : out  STD_LOGIC_VECTOR (26 downto 0));
end Erro;

architecture Behavioral of Erro is
  signal ready  : STD_LOGIC                    := '0';
  signal covK : std_logic_vector(26 downto 0) := (others => '0');

begin


  Erro_covK : process(clock_in, reset_in, enable_in)
      begin
        if (reset_in = '1') then
          ready <= '0';
          covK <= "000000000000000000000000000"; --! covK = 0.1
        elsif rising_edge(clock_in) then
          if (enable_in = '1') then
            -- covK <= covK_in - ganho_in*covK_in;
            ready <= '1';
          else
            ready <= '0';
          end if;
        end if;
        covK_out <= covK;
        ready_out <= ready;
    end process ;


end Behavioral;
