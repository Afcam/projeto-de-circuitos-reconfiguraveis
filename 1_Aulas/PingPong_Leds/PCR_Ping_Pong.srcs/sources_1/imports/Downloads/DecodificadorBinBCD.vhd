library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodificadorBinBCD is
    Port ( BinA : in STD_LOGIC_VECTOR (3 downto 0);
           BinB : in STD_LOGIC_VECTOR (3 downto 0);
           reset: in STD_LOGIC;
           clk: in STD_LOGIC;
           Anodo : out STD_LOGIC_VECTOR (3 downto 0);
           Seg : out STD_LOGIC_VECTOR (7 downto 0));
end DecodificadorBinBCD;

architecture Behavioral of DecodificadorBinBCD is

---------------Constantes-----------
constant Hz10 : STD_LOGIC_VECTOR (15 downto 0):= "1100001101010000";

--------------Sinais---------------
signal clk10Hz : STD_LOGIC;
signal outMux :  STD_LOGIC_VECTOR (3 downto 0);
--------------Componentes------------

component BIN_7SEG is
    Port ( BIN : in std_logic_vector(3 downto 0);
           RES : out std_logic_vector(7 downto 0));

end component;

component Mux is
    Port ( reset    :  in   STD_LOGIC;
           BinA : in std_logic_vector(3 downto 0);
           BinB : in std_logic_vector(3 downto 0);
           clk_10Hz :  in   STD_LOGIC;
           outmux    :  out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component registrador_deslocamento is
	Port (  reset : in STD_LOGIC;
			clk : in STD_LOGIC;
			anodos : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component divisor_clk is
	port    (  reset : in STD_LOGIC;
			   preset : in std_logic_vector(15 downto 0);
			   clk : in STD_LOGIC;
			   outclk : out STD_LOGIC);
end component;

begin
    clk_256HZ: divisor_clk port map (
        reset   => reset,
        preset  => "0000000011000011",
		clk     => clk,
		outclk  => clk10Hz);

    MyAnodo: registrador_deslocamento port map(
        reset  => reset,
		clk    => clk10Hz,
		anodos => Anodo );

	MyMux :  Mux Port map (
	       reset =>reset,
           BinA     => BinA,
           BinB     => BinB,
           clk_10Hz => clk10Hz,
           outmux   => outMux);

    My7seg: BIN_7SEG Port map (
           BIN  => outMux,
           RES  => Seg);

end Behavioral;
