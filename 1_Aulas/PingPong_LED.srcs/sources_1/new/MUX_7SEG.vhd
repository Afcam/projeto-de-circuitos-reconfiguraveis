----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 05.05.2019 12:01:27
-- Design Name:
-- Module Name: MUX_7SEG - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_7SEG is
	port (
		Reset   : in STD_LOGIC;
		CLK_in  : in STD_LOGIC;
		BIN_A   : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_B   : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_C   : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_D   : in STD_LOGIC_VECTOR (3 downto 0);
		BIN_out : out STD_LOGIC_VECTOR (3 downto 0));
end MUX_7SEG;

architecture Behavioral of MUX_7SEG is

	signal SEL : STD_LOGIC_VECTOR (1 downto 0) := "00";

begin

	with SEL select
		BIN_out <= BIN_A when "00",
		BIN_B when "01",
		BIN_C when "10",
		BIN_D when others;

--============================================================================
-- PROCESS <ProcessName>
--! @param[in] clock_in: Description (why is clock_in in sensitive_list?)
--! @param[in] reset_in: Description (why is reset_in in sensitive_list?)
--! Read: #signal_read1,#signal_read2
--! Update: #signal_updated1,#signal_updated2
--============================================================================
	process (CLK_in, Reset)
	begin
		if (Reset = '1') then
			SEL <= "00";
		elsif rising_edge(CLK_in) then
			SEL <= SEL + "01";
		end if;
	end process;

end Behavioral;
