----------------------------------------------------------------------------------
-- Create Date: 05.05.2019 16:25:10
-- Module Name: PingPongTABLE - Behavioral
----------------------------------------------------------------------------------
--! @file PingPongTABLE.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for PingPongTABLE
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity PingPongTABLE is
	port	(
		clock_in     : in STD_LOGIC;                        --! 10Hz bus clock
		reset_in     : in STD_LOGIC;                        --! reset =0: reset active reset =1: no reset
		direction_in : in STD_LOGIC;                        --! direction =0: move left direction =1: move right
		led_out      : out STD_LOGIC_VECTOR (15 downto 0)); --! led bus
end PingPongTABLE;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the led shift for PingPongLED project.
--! @details Optional field
--============================================================================
architecture Behavioral of PingPongTABLE is

	signal led : std_logic_vector(15 downto 0) := (others => '0');
--=============================================================================
-- architecture begin
--=============================================================================
begin
	--============================================================================
	-- PROCESS TABLE
	--! @param[in] clock_in: Define the timer to shift the led
	--! @param[in] reset_in: reset to inicial state of led
	--! @param[in] enable_in: Enables led shift
	--! @param[in] direction_in: Defines the direction of led shift
	--============================================================================
	TABLE : process (clock_in, reset_in, direction_in)
	begin
		if (reset_in = '1') then
			led <= "0000000000000001";
		elsif rising_edge(clock_in)  then
			if (direction_in = '0') then
				led <= led(14 downto 0) & '0'; --! move left
			else
				led <= '0' & led(15 downto 1); --! move right
			end if;
		end if;
		led_out <= led;
	end process TABLE;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
