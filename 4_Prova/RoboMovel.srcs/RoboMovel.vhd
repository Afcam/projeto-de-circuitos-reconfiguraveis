----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:24:50
-- Module Name: RoboMovel - Rtl
----------------------------------------------------------------------------------

--! @file RoboMovel.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity RoboMovel is
    Port ( clock_in     : in  STD_LOGIC;
           reset_in : in STD_LOGIC;
           start_in : in STD_LOGIC;
           xir_in : in STD_LOGIC_VECTOR (26 downto 0);
           xul_in : in STD_LOGIC_VECTOR (26 downto 0);
           ready_out : out STD_LOGIC;
           xfusao_out : out STD_LOGIC_VECTOR (26 downto 0));
end RoboMovel;

architecture Rtl of RoboMovel is
  component Erro
  port (
    clock_in  : in  STD_LOGIC;
    reset_in  : in  STD_LOGIC;
    enable_in : in  STD_LOGIC;
    ganho_in  : in  STD_LOGIC_VECTOR (26 downto 0);
    covK_in   : in  STD_LOGIC_VECTOR (26 downto 0);
    ready_out : out STD_LOGIC;
    covK_out  : out STD_LOGIC_VECTOR (26 downto 0)
  );
  end component Erro;


  component Ganho
  port (
    clock_in  : in  STD_LOGIC;
    reset_in  : in  STD_LOGIC;
    enable_in : in  STD_LOGIC;
    covZ_in   : in  STD_LOGIC_VECTOR (26 downto 0);
    covK_in   : in  STD_LOGIC_VECTOR (26 downto 0);
    ready_out : out STD_LOGIC;
    ganho_out : out STD_LOGIC_VECTOR (26 downto 0)
  );
  end component Ganho;


  component Fusao
port (
  clock_in   : in  STD_LOGIC;
  reset_in   : in  STD_LOGIC;
  enable_in  : in  STD_LOGIC;
  xir_in     : in  STD_LOGIC_VECTOR (26 downto 0);
  xul_in     : in  STD_LOGIC_VECTOR (26 downto 0);
  ganho_in   : in  STD_LOGIC_VECTOR (26 downto 0);
  ready_out  : out STD_LOGIC;
  xfusao_out : out STD_LOGIC_VECTOR (26 downto 0)
);
end component Fusao;


signal ready_ganho  : STD_LOGIC;
signal ready_erro  : STD_LOGIC;
signal ready_fusao  : STD_LOGIC;
signal covK   : STD_LOGIC_VECTOR (26 downto 0);
signal gain   : STD_LOGIC_VECTOR (26 downto 0);




begin




  Ganho_i : Ganho
  port map (
  clock_in  => clock_in,
  reset_in  => reset_in,
  enable_in => start_in,
  covZ_in   => "100000000000000000000000000", --! 0.5
  covK_in   => covK,
  ready_out => ready_ganho,
  ganho_out => gain
  );

  Fusao_i : Fusao
  port map (
    clock_in   => clock_in,
    reset_in   => reset_in,
    enable_in  => ready_ganho,
    xir_in     => xir_in,
    xul_in     => xul_in,
    ganho_in   => gain,
    ready_out  => ready_fusao,
    xfusao_out => xfusao_out
  );

  Erro_i : Erro
port map (
  clock_in  => clock_in,
  reset_in  => reset_in,
  enable_in => ready_fusao,
  ganho_in  => gain,
  covK_in   => covK,
  ready_out => ready_erro,
  covK_out  => covK
);

ready_out <= ready_fusao;






end Rtl;
