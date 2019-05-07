----------------------------------------------------------------------------------
-- Create Date: 05.05.2019 16:25:10
-- Module Name: PingPongLOGIC - Behavioral
----------------------------------------------------------------------------------

--! @file PingPongLOGIC.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for PingPongLOGIC
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity PingPongLOGIC is
	port	(
		clock_in      	: in STD_LOGIC;
		reset_in      	: in STD_LOGIC;
		sw_in         	: in STD_LOGIC_VECTOR (1 downto 0);
		led_in        	: in STD_LOGIC_VECTOR(15 downto 0);
		direction_out 	: out STD_LOGIC;
		endgame_out     : out STD_LOGIC);
end PingPongLOGIC;
--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the led shift for PingPongLED project.
--! @details Optional field
--============================================================================
architecture Behavioral of PingPongLOGIC is

	signal direction   : STD_LOGIC := '0';
	signal endgame     : STD_LOGIC := '0';

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	--============================================================================
	-- PROCESS LOGIC
	--! @param[in] clock_in: Define the timer to shift the led
	--! @param[in] reset_in: reset to inicial state of led
	--============================================================================
	-- LOGIC : process (clock_in, reset_in, sw_in, led_in)
	-- begin
	-- 	if (reset_in = '0') then
	-- 		direction <= '0';
	-- 		endgame     <= '0';
  --   elsif rising_edge(clock_in)  then
  -- 		if (led_in = "0000000000000000") then
  -- 			endgame <= '1';
  -- 		elsif (sw_in(0) = '1') then
  -- 			direction <= '1';
  -- 			endgame     <= '0';
  -- 		elsif (sw_in(1) = '1') then
  -- 			direction <= '0';
  -- 			endgame     <= '0';
  -- 		end if;
  --   end if;
	-- 	direction_out   <= direction;
	-- 	endgame_out     <= endgame;
	-- end process LOGIC;


	LOGIC : process(sw_in,led_in)
	begin
				case led_in is
					when "0000000000000000" =>
							endgame <= '1';
					when others =>
						 	endgame <= '0';
						 direction <= '0';
				end case;
				direction_out   <= direction;
				endgame_out     <= endgame;
	end process;

	-- when "0000000000000001" =>
 -- 							if Switch(0) = '1' then
 -- 								 s_LR <= not s_LR;
 -- 								 s_Over <= '0';
 -- 							else
 -- 								 s_Over <= '1';
 -- 								 Player <= s_LR;
 -- 							end if;
 -- 					 when "100000000000000" =>
 -- 							if Switch(1) = '1' then
 -- 								 s_LR <= not s_LR;
 -- 								 s_Over <= '0';
 -- 							else
 -- 								 s_Over <= '1';
 -- 								 Player <= s_LR;
 -- 							end if;
 -- -- Raquetada antecipada PERDEUUUUU
 -- 							when "0000000000000010" =>
 -- 								 if Switch(0) = '1'  and s_LR = '1' then
 -- 										s_Over <= '1';
 -- 										Player <= s_LR;
 -- 								 end if;
 -- 							when "010000000000000" =>
 -- 								 if Switch(1) = '1' and s_LR = '0' then
 -- 										s_Over <= '1';
 -- 										Player <= s_LR;
 -- 								 end if;

end Behavioral;
--=============================================================================
-- architecture end
