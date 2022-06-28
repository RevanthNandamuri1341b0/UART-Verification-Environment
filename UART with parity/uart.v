/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 June 2022
*Project name : UART with Parity Check
*Domain : Verilog
*Description : 
*Refrence : 
*File Name : uart.v
*File ID : 508797
*Modified by : #your name#
*/

module uart(input wire [7:0] din,
	    input wire wr_en,
	    input wire clk,
	    output wire tx_busy,
	    output wire ready,
	    input wire reset,
	    output wire [7:0] dout);

wire rx_en, tx_en, tx_rx;

baud uart_baud(.clk(clk),
			.rx_en(rx_en),
			.tx_en(tx_en));

transmitter uart_tx(.din(din),
		    .wr_en(wr_en),
		    .clk(clk),
		    .clk_en(tx_en),
		    .tx(tx_rx),
		    .tx_busy(tx_busy));

receiver uart_rx(.rx(tx_rx),
		 	.ready(ready),
		 	.reset(reset),
		 	.clk(clk),
		 	.clk_en(rx_en),
		 	.dout(dout));

endmodule
