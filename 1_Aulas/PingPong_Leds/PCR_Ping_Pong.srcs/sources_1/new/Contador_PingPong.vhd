----------------------------------------------------------------------------------
-- Company: Unb/ FGA
-- Engineer: Arthur Faria Campos e Gustavo Cavalcante Linhares
--
-- Create Date: 27.03.2019 20:39:00
-- Module Name: Contador_PingPong - Behavioral
-- Project Name: PingPong
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Contador_PingPong is
    Port ( Reset     : in  STD_LOGIC                     := '0';
           Enable    : in  STD_LOGIC                     := '0';
           Pontos    : out STD_LOGIC_VECTOR (3 downto 0) := (others=>'0'));
end Contador_PingPong;

architecture Behavioral of Contador_PingPong is
    signal s_pontos :  STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');

begin

  Contagem: process(Reset,Enable)
    begin
      if Reset = '1' then
          s_pontos <= (others=>'0');
      elsif rising_edge(Enable) then
          s_pontos <= s_pontos + '1';
      end if;
      Pontos <= s_pontos;
  end process;

end Behavioral;