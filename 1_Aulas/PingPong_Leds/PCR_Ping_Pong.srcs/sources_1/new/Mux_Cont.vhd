----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 28.03.2019 08:19:03
-- Design Name:
-- Module Name: Mux_Cont - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux_Cont is
    Port ( Player : in STD_LOGIC;
           Over : in STD_LOGIC;
           Enable : out STD_LOGIC_VECTOR (1 downto 0));
end Mux_Cont;

architecture Behavioral of Mux_Cont is

begin

   Contagem: process(Over)
   begin
         if Over ='1' then
            if Player = '1' then
               Enable <= "01";
            else
               Enable <= "10";
            end if;
         else
            Enable <= "00";
         end if;
   end process;


end Behavioral;
