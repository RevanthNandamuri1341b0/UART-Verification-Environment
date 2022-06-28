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
	modport tb_mod_port (clocking cb,output reset);
	modport tb_mon (clocking mcb);
	
endinterface //uart_if

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
	testbench tb_inst (.vif(uart_if_inst));
	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars(0);               
	end
endmodule: top
