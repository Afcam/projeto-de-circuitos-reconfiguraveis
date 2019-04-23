----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 18.04.2019 09:02:18
-- Design Name:
-- Module Name: neuronio - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Deion:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;

USE work.fpupack.ALL;
USE work.entities.ALL;

ENTITY neuronio IS
    	PORT
    	(
    	    	clk   : IN STD_LOGIC;
    	    	reset : IN STD_LOGIC;
    	    	start : IN STD_LOGIC;
    	    	x     : IN t_mult;
    	    	w     : IN t_mult;
    	    	bias  : IN STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0);
    	    	saida : OUT STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0);
    	    	ready : OUT STD_LOGIC);
END neuronio;

ARCHITECTURE Behavioral OF neuronio IS

    	SIGNAL outmul : t_mult                                           := (OTHERS => (OTHERS => '0'));
    	SIGNAL rdymul : std_logic_vector(num_mult_neuronio - 1 DOWNTO 0) := (OTHERS => '0');

    	SIGNAL outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	SIGNAL outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	SIGNAL outadd_2 : STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    	SIGNAL outadd_3 : STD_LOGIC_VECTOR (FP_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');

    	SIGNAL rdyadd_0 : std_logic := '0';
    	SIGNAL rdyadd_1 : std_logic := '0';
    	SIGNAL rdyadd_2 : std_logic := '0';
    	SIGNAL rdyadd_3 : std_logic := '0';
BEGIN

    	mult_gen : FOR i IN outmul'RANGE GENERATE
    	    	mul : multiplierfsm_v2 PORT MAP
    	    	(
    	    	    	reset     => reset,
    	    	    	clk       => clk,
    	    	    	op_a      => x(i),
    	    	    	op_b      => w(i),
    	    	    	start_i   => start,
    	    	    	mul_out   => outmul(i),
    	    	    	ready_mul => rdymul(i));
    	END GENERATE mult_gen;

    	add0 : addsubfsm_v6 PORT
    	MAP(
    	reset      => reset,
    	clk        => clk,
    	op         => '0',
    	op_a       => outmul(0),
    	op_b       => outmul(1),
    	start_i    => rdymul(0),
    	addsub_out => outadd_0,
    	ready_as   => rdyadd_0);

    	add1 : addsubfsm_v6 PORT
    	MAP(
    	reset      => reset,
    	clk        => clk,
    	op         => '0',
    	op_a       => outmul(2),
    	op_b       => outmul(3),
    	start_i    => rdymul(0),
    	addsub_out => outadd_1,
    	ready_as   => rdyadd_1);

    	add2 : addsubfsm_v6 PORT
    	MAP(
    	reset      => reset,
    	clk        => clk,
    	op         => '0',
    	op_a       => outadd_0,
    	op_b       => outadd_1,
    	start_i    => rdyadd_0,o
    	addsub_out => outadd_2,
    	ready_as   => rdyadd_2);

    	add3 : addsubfsm_v6 PORT
    	MAP(
    	reset      => reset,
    	clk        => clk,
    	op         => '0',
    	op_a       => outadd_2,
    	op_b       => bias,
    	start_i    => rdyadd_2,
    	addsub_out => outadd_3,
    	ready_as   => rdyadd_3);

    	-- processo para realizar a saida linear
    	PROCESS (clk, reset)
    	BEGIN
    	    	IF reset = '1' THEN
    	    	    	saida <= (OTHERS => '0');
    	    	    	ready <= '0';
    	    	ELSIF rising_edge(clk) THEN
    	    	    	ready <= '0';
    	    	    	IF rdyadd_3 = '1' THEN
    	    	    	    	ready       <= '1';
    	    	    	    	IF outadd_3 <= ZERO_V THEN
    	    	    	    	    	saida       <= (OTHERS => '0');
    	    	    	    	ELSIF outadd_3 >= s_one THEN
    	    	    	    	    	saida <= s_one;
    	    	    	    	ELSE
    	    	    	    	    	saida <= outadd_3;
    	    	    	    	END IF;
    	    	    	END IF;
    	    	END IF;
    	END PROCESS;

END Behavioral;
