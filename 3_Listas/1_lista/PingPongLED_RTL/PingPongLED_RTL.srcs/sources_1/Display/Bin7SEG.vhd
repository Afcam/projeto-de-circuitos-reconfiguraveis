----------------------------------------------------------------------------------
-- Company: Unb / FGA
-- Engineer: Arthur Faria Campos 160024242
-- Module Name: Bin7SEG - Behavioral
----------------------------------------------------------------------------------
--! @file Bin7SEG.vhd
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--============================================================================
-- ENTITY declaration for Bin7SEG
--============================================================================
--! @brief Description with no more than two lines.
--! @details Optional field. It has to be present if two lines of brief description
--! aren't enoght
------------------------------------------------------------------------------
entity Bin7SEG is
	port
	(	bin_in : in STD_LOGIC_VECTOR (3 downto 0);
		seg_out : out STD_LOGIC_VECTOR (7 downto 0));
end Bin7SEG;
--============================================================================
--  ARCHITECTURE declaration
--============================================================================
--! @brief Architecture of #Bin7SEG.
------------------------------------------------------------------------------
architecture Behavioral of Bin7SEG is

	--=============================================================================
	-- architecture begin
	--=============================================================================
begin

	process (bin_in)
	begin
		case bin_in is
			when "0000" => seg_out <= "11000000";
			when "0001" => seg_out <= "11111001";
			when "0010" => seg_out <= "10100100";
			when "0011" => seg_out <= "10110000";
			when "0100" => seg_out <= "10011001";
			when "0101" => seg_out <= "10010010";
			when "0110" => seg_out <= "10000010";
			when "0111" => seg_out <= "11111000";
			when "1000" => seg_out <= "10000000";
			when "1001" => seg_out <= "10010000";
			when "1010" => seg_out <= "10001000";
			when "1011" => seg_out <= "10000011";
			when "1100" => seg_out <= "11000110";
			when "1101" => seg_out <= "10100001";
			when "1110" => seg_out <= "10000110";
			when "1111" => seg_out <= "11111111"; --! turned off
			when others => seg_out <= "11111111";
		end case;
	end process;

end Behavioral;
--=============================================================================
-- architecture end
--=============================================================================
