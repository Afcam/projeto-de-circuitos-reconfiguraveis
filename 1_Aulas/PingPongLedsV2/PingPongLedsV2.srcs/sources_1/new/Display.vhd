LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Display IS
    PORT
    (
        clk_256Hz : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        cnt0      : IN std_logic_vector(3 DOWNTO 0) := "0000";
        cnt1      : IN std_logic_vector(3 DOWNTO 0) := "0000";
        seg       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        an        : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END Display;

ARCHITECTURE Behavioral OF Display IS

SIGNAL s_an    : unsigned(3 DOWNTO 0) := "0000";
SIGNAL sel_mux : std_logic_vector(1 DOWNTO 0) := "00";
SIGNAL s_bin   : std_logic_vector(3 DOWNTO 0) := "0000";

BEGIN
    -- process para multiplexar anodos
    PROCESS (clk_256Hz, reset)
    BEGIN
        IF reset = '1' THEN
            s_an    <= "1110";
            sel_mux <= "00";
        ELSIF rising_edge(clk_256Hz) THEN
            s_an    <= s_an SRL 1;
            sel_mux <= sel_mux + 1;
        END IF;
    END PROCESS;
    an <= std_logic_vector(s_an);
    -- mux para decodificador
    WITH sel_mux SELECT
    s_bin <= cnt0 WHEN "00",
             "1111" WHEN "01",
             "1111" WHEN "10",
             cnt1 WHEN "11";

    -- process combinacional para decodificar segmentos
    PROCESS (s_bin)
        BEGIN
            CASE s_bin IS
                WHEN "0000" => seg <= "11000000";
                WHEN "0001" => seg <= "11111001";
                WHEN "0010" => seg <= "10100100";
                WHEN "0011" => seg <= "10110000";
                WHEN "0100" => seg <= "10011001";
                WHEN "0101" => seg <= "10010010";
                WHEN "0110" => seg <= "10000010";
                WHEN "0111" => seg <= "11111000";
                WHEN "1000" => seg <= "10000000";
                WHEN "1001" => seg <= "10010000";
                WHEN "1111" => seg <= "11111111";
                WHEN OTHERS => seg     <= "11111111";
            END CASE;
        END PROCESS;
END Behavioral;
