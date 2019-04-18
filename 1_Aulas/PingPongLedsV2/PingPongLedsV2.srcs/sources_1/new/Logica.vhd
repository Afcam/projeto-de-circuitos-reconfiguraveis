library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Logica is
    Port ( reg : in std_logic_vector(15 downto 0) ;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(1 downto 0);
           cnt0 : out  std_logic_vector(3 downto 0) := "0000";
           cnt1 : out std_logic_vector(3 downto 0) := "0000";
           lr : out STD_LOGIC;
           player : out STD_LOGIC;
           enable : out STD_LOGIC);
end Logica;


architecture Behavioral of Logica is

   signal s_cnt0 		: std_logic_vector(3 downto 0) := "0000";
   signal s_cnt1 		: std_logic_vector(3 downto 0) := "0000";
   
begin


   -- process para controlar jogo
   process(clk,reset)
   begin
      if reset = '1' then
         s_cnt0 <= "0000";
         s_cnt1 <= "0000";
         lr <= '1';
         enable <= '0'; -- habilita jogo
         player <= '0';
      elsif rising_edge(clk) then
         if s_cnt0 = "1001" or s_cnt1 = "1001" then
            lr <= '1'; -- desloca à esquerda
            enable <= '1'; -- habilita o deslocamento
            player <= '0'; -- player 0 começa
            s_cnt0 <= "0000";
            s_cnt1 <= "0000";
         elsif reg="0000000000000001" and sw(0) = '1' then
            lr <= '1'; -- desloca à esquerda
            enable <= '1'; -- habilita o deslocamento
         elsif reg="0000000000000001" and sw(0) = '0' then
            lr <= '0'; -- desloca à direita
            enable <= '0'; -- deshabilita o deslocamento
            player <= '1'; -- player 1 joga
            s_cnt1 <= s_cnt1 + 1; -- incrementa placar player 1
         elsif reg="1000000000000000" and sw(1) = '1' then
            lr <= '0'; -- desloca à direita
            enable <= '1'; -- habilita o deslocamento
         elsif reg="1000000000000000" and sw(1) = '0' then
            lr <= '1'; -- desloca à esquerda
            enable <= '0'; -- deshabilita o deslocamento
            player <= '0'; -- player 0 joga
            s_cnt0 <= s_cnt0 + 1;	-- incrementa placar player 0
         end if;
      end if;
   end process;

cnt1 <= s_cnt1;
cnt0 <= s_cnt0;

end Behavioral;
