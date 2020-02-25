LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;


ENTITY UART_top IS
		PORT(	CLK 				: IN std_logic;
				btn_RST			: IN std_logic;
				--TO_SEND			: IN std_logic_vector(7 downto 0) --uncomment when using with other blocks
				RX_IN				: IN std_logic;
				TX_OUT 			: OUT std_logic;
				busy				: OUT std_logic
			);
		
END UART_top;


ARCHITECTURE testing OF UART_top IS

COMPONENT uart
		PORT(
				CLK         : in  std_logic; -- system clock
				RST         : in  std_logic; -- high active synchronous reset
				-- UART INTERFACE
				UART_TXD    : out std_logic;
				UART_RXD    : in  std_logic;
				-- USER DATA INPUT INTERFACE
				DATA_IN     : in  std_logic_vector(7 downto 0);
				DATA_SEND   : in  std_logic; -- when DATA_SEND = 1, data on DATA_IN will be transmit, DATA_SEND can set to 1 only when BUSY = 0
				BUSY        : out std_logic -- when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
				-- USER DATA OUTPUT INTERFACE
				--DATA_OUT    : out std_logic_vector(7 downto 0);
				--DATA_VLD    : out std_logic; -- when DATA_VLD = 1, data on DATA_OUT are valid
				--FRAME_ERROR : out std_logic  -- when FRAME_ERROR = 1, stop bit was invalid, current and next data may be invalid
    );
end COMPONENT;

SIGNAL is_busy, tx_send, btn_RST_inv : std_logic;
-- dummy data for hardware testing
CONSTANT  dummy_data: std_logic_vector(7 downto 0) := B"01000001";

BEGIN
btn_RST_inv <= not btn_RST;
busy <= is_busy;

controller1	: uart PORT MAP (
				CLK => CLK, 
				RST => btn_RST_inv,
				-- UART Interface
				UART_TXD => TX_OUT,
				UART_RXD => RX_IN,
				-- User data in
				DATA_IN => dummy_data,
				DATA_SEND => tx_send,
				BUSY => is_busy
				-- Data from PC
				--DATA_OUT => (others => '0'),
				--DATA_VLD => open,
				--FRAME_ERROR => open
									 );

	UART_send_char: PROCESS(CLK)
	BEGIN
		if rising_edge(CLK) then
				if btn_RST_inv = '1' then --synchronous active high reset
					tx_send <= '0';
					
				else
					if is_busy = '0' then
						tx_send <= '1';
					else
						tx_send <= '0';
					end if;
					
				end if;
		end if;
	END PROCESS;
END testing;