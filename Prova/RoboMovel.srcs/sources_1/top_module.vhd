----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Create Date: 09.05.2019 01:11:38
-- Module Name: top_module - Behavioral
----------------------------------------------------------------------------------
--! @file RoboMovel.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


--============================================================================
-- ENTITY declaration for top_module.vhd
--============================================================================
--! @brief Realizar a fusao sensorial de dois sensores no intuito de melhorar a
--! estimativa do valor de distancia medida pelo robo.
------------------------------------------------------------------------------
entity top_module is
    Port ( clock_in : in STD_LOGIC;
           reset_in : in STD_LOGIC;
           start_in : in STD_LOGIC;
            sw_in   : in  STD_LOGIC;
          addr_in   : in STD_LOGIC_VECTOR (6 downto 0);
           led_out : out STD_LOGIC_VECTOR (15 downto 0));
end top_module;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the top_module for RoboMovel project.
--! @details Optional field
--============================================================================
architecture Behavioral of top_module is

  component RoboMovel
  port (
    clock_in   : in  STD_LOGIC;
    reset_in   : in  STD_LOGIC;
    start_in   : in  STD_LOGIC;
    xir_in     : in  STD_LOGIC_VECTOR (26 downto 0);
    xul_in     : in  STD_LOGIC_VECTOR (26 downto 0);
    ready_out  : out STD_LOGIC;
    xfusao_out : out STD_LOGIC_VECTOR (26 downto 0)
  );
  end component RoboMovel;

  component Memory_Xir
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
    );
  END component;


  component Memory_Xul
    PORT (
      clka : IN STD_LOGIC;
      addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
    );
  end component;


  signal xir     : STD_LOGIC_VECTOR (26 downto 0):= (others => '0');
  signal xul     : STD_LOGIC_VECTOR (26 downto 0):= (others => '0');
  signal ready_out  : STD_LOGIC;
  signal xfusao_out : STD_LOGIC_VECTOR (26 downto 0):= (others => '0');

  signal  addra :  STD_LOGIC_VECTOR(6 DOWNTO 0):= (others => '0');


--=============================================================================
-- architecture begin
--=============================================================================
begin

  RoboMovel_i : RoboMovel
  port map (
    clock_in   => clock_in,
    reset_in   => reset_in,
    start_in   => start_in,
    xir_in     => xir,
    xul_in     => xul,
    ready_out  => ready_out,
    xfusao_out => xfusao_out
  );

  Mem_XIR : Memory_Xir
  PORT MAP (
    clka => clock_in,
    addra => addr_in,
    douta => xir
  );

  Mem_XUL : Memory_Xul
  PORT MAP (
    clka => clock_in,
    addra => addr_in,
    douta => xul
  );



    -- Memory : process (reset_in, clock_in, start_in)
  	-- begin
  	-- 	if reset_in = '1' then
  	-- 		addra <= (others => '0');
  	-- 	elsif rising_edge(clock_in) then
  	-- 		if start_in = '1' then
    --       if  addra = "1100100" then
    --         addra <= (others => '0');
    --       else
    --         addra <= addra + '1';
    --       end if;
  	-- 		end if;
  	-- 	end if;
  	-- end process Memory;

    with sw_in select
  		led_out <= xfusao_out(26 downto 11) when '0',
  		xfusao_out(15 downto 0) when others;



end Behavioral;

--=============================================================================
-- architecture end
--=============================================================================
