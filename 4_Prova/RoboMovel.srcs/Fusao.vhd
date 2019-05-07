----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 07.05.2019 08:24:50
-- Module Name: Fusao - Behavioral
----------------------------------------------------------------------------------

--! @file Fusao.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity Fusao is
    Port ( clock_in     : in  STD_LOGIC;
           reset_in : in STD_LOGIC;
           enable_in : in STD_LOGIC;
           xir_in : in STD_LOGIC_VECTOR (26 downto 0);
           xul_in : in STD_LOGIC_VECTOR (26 downto 0);
           ganho_in : in STD_LOGIC_VECTOR (26 downto 0);
           ready_out : out STD_LOGIC;
           xfusao_out : out STD_LOGIC_VECTOR (26 downto 0));
end Fusao;

architecture Behavioral of Fusao is

signal sub : std_logic_vector(26 downto 0) := (others => '0');

component multiplierfsm_v2
port (
  reset     : in  std_logic;
  clk       : in  std_logic;
  op_a      : in  std_logic_vector(FP_WIDTH-1 downto 0);
  op_b      : in  std_logic_vector(FP_WIDTH-1 downto 0);
  start_i   : in  std_logic;
  mul_out   : out std_logic_vector(FP_WIDTH-1 downto 0);
  ready_mul : out std_logic
);
end component multiplierfsm_v2;

--=============================================================================
-- architecture begin
--=============================================================================
begin

 sub <= (xir_in-xul_in);
  multiplierfsm_v2_i : multiplierfsm_v2
  port map (
    reset     => reset_in,
    clk       => clock_in,
    op_a      => ganho_in,
    op_b      => sub,
    start_i   => enable_in,
    mul_out   => xfusao_out,
    ready_mul => ready_out
  );

  -- --============================================================================
  -- -- PROCESS Estimativa
  -- --! @param[in] reset_in: reset to inicial state of led
  -- --! @param[in] enable_in :
  -- --============================================================================
  -- Estimativa : process(clock_in, reset_in, enable_in)
  --   begin
  --     if (reset_in = '1') then
  --       ready_out <= '0';
  --       xfusao_out <= "000000000000000000000000000";
  --     elsif rising_edge(clock_in) then
  --       if (enable_in = '1') then
  --         -- xfusao <= xul_in + ganho_in*(xir_in-xul_in);
  --         ready_out <= '1';
  --       else
  --         ready_out <= '0';
  --       end if;
  --     end if;
  --     xfusao_out <= xfusao;
  -- end process Estimativa;


end Behavioral;
