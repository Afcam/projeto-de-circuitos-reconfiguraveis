----------------------------------------------------------------------------------
-- Company: Unb/ FGA
-- Engineer: Arthur Faria Campos e Gustavo Cavalcante Linhares
--
-- Create Date: 27.03.2019 20:39:00
-- Module Name: Barrelshifter_PingPong - Behavioral
-- Project Name: PingPong
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Barrelshifter_PingPong is
    Port ( Reset     : in  STD_LOGIC;
           Clk       : in  STD_LOGIC;
           Enable    : in  STD_LOGIC;
           Switch    : in  STD_LOGIC_VECTOR (1 downto 0);
           Player    : out STD_LOGIC;
           Over      : out STD_LOGIC;
           Led       : out STD_LOGIC_VECTOR (15 downto 0));
end Barrelshifter_PingPong;

architecture Behavioral of Barrelshifter_PingPong is
   signal s_Led :  STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
   signal s_LR  : STD_LOGIC;
   signal s_Over : STD_LOGIC;

begin

   Raquete : process(Switch,s_Led)
   begin
         case s_Led is
            when "0000000000000001" =>
               if Switch(0) = '1' then
                  s_LR <= not s_LR;
                  s_Over <= '0';
               else
                  s_Over <= '1';
                  Player <= s_LR;
               end if;
            when "100000000000000" =>
               if Switch(1) = '1' then
                  s_LR <= not s_LR;
                  s_Over <= '0';
               else
                  s_Over <= '1';
                  Player <= s_LR;
               end if;
-- Raquetada antecipada PERDEUUUUU
               when "0000000000000010" =>
                  if Switch(0) = '1'  and s_LR = '1' then
                     s_Over <= '1';
                     Player <= s_LR;
                  end if;
               when "010000000000000" =>
                  if Switch(1) = '1' and s_LR = '0' then
                     s_Over <= '1';
                     Player <= s_LR;
                  end if;
               when others =>
                  s_LR <= s_LR;
                  s_Over <= '0';
         end case;
         Over <= s_Over;
   end process;
-- se der s_Over e s_LR = 1 esquerda ganha
   Mesa : process(Clk,Reset)
   begin
      if Reset = '1'  then
         s_Led <= "0000000000000001";
      elsif rising_edge(Clk) then
         if s_LR = '0' then -- Se 0 vai pra  <-----
            s_Led <= s_Led(14 downto 0) & s_Led(15);
         elsif s_LR = '1' then -- Se 1 vai pra  ----->
            s_Led <= s_Led(0) & s_Led(15 downto 1);
         end if;
      end if;
      Led <= s_Led;
   end process;

end Behavioral;
