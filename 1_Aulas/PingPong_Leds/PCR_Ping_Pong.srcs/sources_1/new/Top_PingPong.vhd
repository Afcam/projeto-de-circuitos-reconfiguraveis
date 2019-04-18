--------------------------------------------------------------------------------
-- Company: Unb/ FGA
-- Engineer: Arthur Faria Campos e Gustavo Cavalcante Linhares
--
-- Create Date: 27.03.2019 20:18:17
-- Module Name: Top_PingPong - Behavioral
-- Project Name: PingPong
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Top_PingPong is
    Port ( Clk    : in  STD_LOGIC;
           Reset  : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           sw     : in  STD_LOGIC_VECTOR (1 downto 0);
           led    : out STD_LOGIC_VECTOR (15 downto 0);
           Anodo  : out STD_LOGIC_VECTOR (3 downto 0);
           seg    : out STD_LOGIC_VECTOR (7 downto 0));
end Top_PingPong;


architecture Behavioral of Top_PingPong is
--------------------------------------------------------------------------------
-- Contador_PingPong
--------------------------------------------------------------------------------
   component Contador_PingPong is
      Port (
         Reset     : in  STD_LOGIC                     := '0';
         Enable    : in  STD_LOGIC                     := '0';
         Pontos    : out STD_LOGIC_VECTOR (3 downto 0) := (others=>'0'));
   end component;

   signal s_PontosA : STD_LOGIC_VECTOR (3 downto 0) := (others=>'0');
   signal s_PontosB : STD_LOGIC_VECTOR (3 downto 0) := (others=>'0');
   signal s_EnableA : STD_LOGIC;
   signal s_EnableB : STD_LOGIC;
   signal Clk_10Hz  : STD_LOGIC;
--------------------------------------------------------------------------------
-- Barrelshifter_PingPong
--------------------------------------------------------------------------------
component Barrelshifter_PingPong
port (
  Reset  : in  STD_LOGIC;
  Clk    : in  STD_LOGIC;
  Enable : in  STD_LOGIC;
  Switch : in  STD_LOGIC_VECTOR (1 downto 0);
  Player : out STD_LOGIC;
  Over   : out STD_LOGIC;
  Led    : out STD_LOGIC_VECTOR (15 downto 0)
);
end component Barrelshifter_PingPong;

signal s_Enable  : STD_LOGIC_VECTOR(1 downto 0);
signal s_Over : STD_LOGIC := '0';
signal s_Player  : STD_LOGIC := '0';
signal s_Reset : STD_LOGIC;
--------------------------------------------------------------------------------
-- DecodificadorBinBCD
--------------------------------------------------------------------------------
   component DecodificadorBinBCD
      port (
        BinA  : in  STD_LOGIC_VECTOR (3 downto 0);
        BinB  : in  STD_LOGIC_VECTOR (3 downto 0);
        reset : in  STD_LOGIC;
        clk   : in  STD_LOGIC;
        Anodo : out STD_LOGIC_VECTOR (3 downto 0);
        Seg   : out STD_LOGIC_VECTOR (7 downto 0)
      );
   end component DecodificadorBinBCD;

--------------------------------------------------------------------------------
-- divisor_clk
--------------------------------------------------------------------------------
   component divisor_clk is
   	port    (  reset : in STD_LOGIC;
   			   preset : in std_logic_vector(15 downto 0);
   			   clk : in STD_LOGIC;
   			   outclk : out STD_LOGIC);
   end component;


   component Mux_Cont
   port (
     Player : in  STD_LOGIC;
     Over   : in  STD_LOGIC;
     Enable : out STD_LOGIC_VECTOR (0 to 1)
   );
   end component Mux_Cont;


--------------------------------------------------------------------------------
begin

   Contador_PlayerA  : Contador_PingPong   port map ( Reset  => Reset,
                                                      Enable => s_Enable(0),
                                                      Pontos => s_PontosA);

   Contador_PlayerB  : Contador_PingPong   port map ( Reset  => Reset,
                                                      Enable => s_Enable(1),
                                                      Pontos => s_PontosB);

   Decod             : DecodificadorBinBCD port map ( BinA  => s_PontosA,
                                                      BinB  => s_PontosB,
                                                      reset => Reset,
                                                      clk   => Clk,
                                                      Anodo => Anodo,
                                                      Seg   => seg);

   clock_10Hz          : divisor_clk port map ( reset   => Reset,
                                              preset  => "1100001101010000",
                                              clk     => Clk,
                                              outclk  => Clk_10Hz);

   Campo : Barrelshifter_PingPong  port map (
                                             Reset  => s_Reset,
                                             Clk    => Clk,
                                             Enable => Enable,
                                             Switch => sw,
                                             Player => s_Player,
                                             Over   => s_Over,
                                             Led    => led );

   Mux_Cont_i : Mux_Cont  port map (          Player => s_Player,
                                               Over   => s_Over,
                                               Enable => s_Enable
                                             );


Reseta : process(Reset,s_Over)
begin
   if Reset = '1' or s_Over = '1' then
      s_Reset <= '1';
   else
      s_Reset <= '0';
   end if;
end process;
end Behavioral;
