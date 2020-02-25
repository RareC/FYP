LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;


ENTITY UART_top_tb IS
END UART_top_tb;

ARCHITECTURE tb OF UART_top_tb IS

   constant T : time := 20 ns; 

   signal CLK: std_logic;  -- clock	
	signal output: std_logic; -- output data
	signal data_in: std_logic; --input data
	signal busy_tb: std_logic; --UART busy line
	signal reset: std_logic; --reset line

BEGIN

	UUT : entity work.UART_top
	port map (CLK=>CLK, TX_OUT=>output, RX_IN => data_in, busy => busy_tb, btn_RST => reset);

	
	reset <= '0', '1' after T*2; --reset for first 2 clock cycles


	 -- continuous clock
    cont_clk: process
    begin
        CLK <= '0';
        wait for T/2;
        CLK <= '1';
        wait for T/2;
    end process;

END tb;