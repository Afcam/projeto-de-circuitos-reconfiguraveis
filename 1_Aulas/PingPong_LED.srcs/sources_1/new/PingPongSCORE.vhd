------------------------------------------------------------------------------
-- Create Date: 05.05.2019 16:25:10
-- Module Name: PingPongSCORE - Behavioral
------------------------------------------------------------------------------

--! @file PingPongSCORE.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for PingPongSCOREvhd
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity PingPongSCORE is
	port (
		clock_in     : in  STD_LOGIC;
		reset_in     : in  STD_LOGIC; --! reset =0: reset active reset =1: no reset
		enable_in    : in  STD_LOGIC;
		direction_in : in  STD_LOGIC;
		score1_out   : out STD_LOGIC_VECTOR (3 downto 0);
		score2_out   : out STD_LOGIC_VECTOR (3 downto 0);
		ready_out    : out STD_LOGIC);
end PingPongSCORE;

--============================================================================
-- ARCHITECTURE declaration
--! @brief Defines the led shift for PingPongLED project.
--! @details Optional field
--============================================================================
architecture Behavioral of PingPongSCORE is

	signal ready  : STD_LOGIC                    := '0';
	signal score1 : std_logic_vector(3 downto 0) := (others => '0');
	signal score2 : std_logic_vector(3 downto 0) := (others => '0');

--=============================================================================
-- architecture begin
--=============================================================================
begin
	--============================================================================
	-- PROCESS SCORE
	--! @param[in] reset_in: reset to inicial state of led
	--! @param[in] enable_in: Enables led shift
	--! @param[in] direction_in: Defines the direction of led shift
	--============================================================================
	SCORE : process (clock_in, reset_in, enable_in, direction_in)
	begin
		if (reset_in = '1') then
			score1 <= "0000";
			score2 <= "0000";
      ready <= '1';
		elsif rising_edge(clock_in) then
			if (enable_in = '1') and (ready = '0') then
				if (direction_in = '0') then
					score1 <= score1 + '1';
				else
					score2 <= score2 + '1';
				end if;
        ready <= '1';
			else
				ready <= '0';
			end if;
		end if;
    ready_out  <= ready;
    score1_out <= score1;
    score2_out <= score2;
	end process SCORE;


end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
