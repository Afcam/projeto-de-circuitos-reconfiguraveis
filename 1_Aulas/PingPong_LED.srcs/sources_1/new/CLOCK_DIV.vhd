----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.05.2019 11:14:29
-- Design Name:
-- Module Name: CLOCK_DIV - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY CLOCK_DIV IS
	GENERIC
		(Preset : INTEGER);
	PORT
	(
		Reset   : IN STD_LOGIC;
		CLK_in  : IN STD_LOGIC;
		CLK_out : OUT STD_LOGIC);
END CLOCK_DIV;

ARCHITECTURE Behavioral OF CLOCK_DIV IS

	SIGNAL count : INTEGER   := 1;
	SIGNAL tmp   : STD_LOGIC := '0';

BEGIN
	PROCESS (CLK_in, Reset)
	BEGIN
		IF (Reset = '1') THEN
			count <= 1;
			tmp   <= '0';
		ELSIF rising_edge(CLK_in) THEN
			count <= count + 1;
			IF (count = Preset) THEN
				tmp   <= NOT tmp;
				count <= 1;
			END IF;
		END IF;
	END PROCESS;
	
	CLK_out <= tmp;

END Behavioral;
