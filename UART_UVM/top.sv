/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 January 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : 
*File Name : top.sv
*File ID : 596283
*Modified by : #your name#
*/

`include "uart_if.sv"
`include "program_uart.sv"
module top;
	logic clk=0;	always #5 clk=~clk;
	uart_if uart_if_inst(clk);
	uart test_uart
	(
		.clk(clk), 
		.din(uart_if_inst.din),
		.wr_en(uart_if_inst.wr_en),
		.tx_busy(uart_if_inst.tx_busy),
		.ready(uart_if_inst.ready),
		.reset(uart_if_inst.reset),
		.dout(uart_if_inst.dout)
	);
	program_uart tb_inst ((uart_if_inst));
	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars(0);               
	end
endmodule: top
