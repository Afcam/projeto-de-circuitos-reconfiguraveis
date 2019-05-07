----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.05.2019 11:34:15
-- Design Name:
-- Module Name: SHIFT_RIGHT - Behavioral
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

ENTITY SHIFT_RIGHT IS
	PORT
	(
		Reset      : IN STD_LOGIC;
		CLK_in     : IN STD_LOGIC;
		Anodos_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END SHIFT_RIGHT;

ARCHITECTURE Behavioral OF SHIFT_RIGHT IS

	SIGNAL s_Anodo : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";

BEGIN
	PROCESS (CLK_in, Reset)
	BEGIN
		IF (Reset = '1') THEN
			s_Anodo <= "1110";
		ELSIF rising_edge(CLK_in) THEN
			s_Anodo <= s_Anodo(2 DOWNTO 0) & s_Anodo(3);
		END IF;
		Anodos_out <= s_Anodo;
	END PROCESS;

END Behavioral;
