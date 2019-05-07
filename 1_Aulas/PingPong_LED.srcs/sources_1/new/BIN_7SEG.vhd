----------------------------------------------------------------------------------
-- Create Date: 05.05.2019 11:07:11
-- Module Name: BIN_7SEG - Behavioral
----------------------------------------------------------------------------------
--! @file BIN_7SEG.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for BIN_7SEG
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity BIN_7SEG is
	port
	(
		BIN : in STD_LOGIC_VECTOR (3 downto 0);
		SEG : out STD_LOGIC_VECTOR (7 downto 0));
end BIN_7SEG;
--============================================================================
-- ARCHITECTURE declaration
--! @brief Architecture of #DemoEntity
--! @details Optional field
--============================================================================
architecture Behavioral of BIN_7SEG is

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	process (BIN)
	begin
		case BIN is
			when "0000" => SEG <= "11000000";
			when "0001" => SEG <= "11111001";
			when "0010" => SEG <= "10100100";
			when "0011" => SEG <= "10110000";
			when "0100" => SEG <= "10011001";
			when "0101" => SEG <= "10010010";
			when "0110" => SEG <= "10000010";
			when "0111" => SEG <= "11111000";
			when "1000" => SEG <= "10000000";
			when "1001" => SEG <= "10010000";
			when "1010" => SEG <= "10001000";
			when "1011" => SEG <= "10000011";
			when "1100" => SEG <= "11000110";
			when "1101" => SEG <= "10100001";
			when "1110" => SEG <= "10000110";
			when "1111" => SEG <= "11111111"; --! turned off
			when others => SEG <= "11111111";
		end case;
	end process;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
