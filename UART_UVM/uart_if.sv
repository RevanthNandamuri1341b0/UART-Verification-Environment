/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Interface for the UART DUT
*File Name : uart_if.sv
*File ID : 200799
*Modified by : #your name#
*/

interface uart_if(input clk);
    logic [7:0] din;
	logic wr_en;
	logic reset;
	logic tx_busy;
	logic ready;
	logic [7:0] dout;

   clocking cb @(posedge clk);
       output din;
	   output wr_en;
	   input tx_busy;
	   input ready;
	   input dout;
	endclocking :cb
	
	clocking mcb @(posedge clk);
		input din;
		input wr_en;
		input reset;
		input tx_busy;
		input ready;
		input dout;
	endclocking :mcb
	modport tb_mod (clocking cb,output reset);
	modport tb_mon (clocking mcb);
	
endinterface //uart_if