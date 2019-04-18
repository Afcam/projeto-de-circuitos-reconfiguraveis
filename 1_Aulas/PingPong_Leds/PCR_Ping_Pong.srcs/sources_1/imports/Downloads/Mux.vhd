library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is

    Port ( reset    :  in   STD_LOGIC;
           BinA : in std_logic_vector(3 downto 0);
           BinB : in std_logic_vector(3 downto 0);
           clk_10Hz :  in   STD_LOGIC;
           outmux    :  out  STD_LOGIC_VECTOR (3 downto 0));
end Mux;

architecture Behavioral of Mux is

signal Contador : std_logic := '0';

begin
    process(reset,clk_10Hz)
        begin
            if reset = '1' then
                outmux<= "1111";
            end if;
            if rising_edge(clk_10Hz) then
                if Contador ='0' then
                    outmux<=BinA;
                else
                    outmux<=BinB;
                end if;
                Contador<= not Contador;
            end if;
    end process;

end Behavioral;
