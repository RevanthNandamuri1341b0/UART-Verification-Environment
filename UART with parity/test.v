module uart_tx_test();
    reg [7:0] din = 0;
    reg clk = 0;
    reg wr_en = 0;
    
    wire tx_busy;
    wire ready;
    wire [7:0] dout;
    
    reg reset = 0;
    
    uart test_uart(.din(din),
                   .wr_en(wr_en),
                   .clk(clk),
                   .tx_busy(tx_busy),
                   .ready(ready),
                   .reset(reset),
                   .dout(dout));

initial begin
	$dumpfile("uart.vcd");
	$dumpvars(0, uart_tx_test);
	wr_en <= 1'b1;
	#2 wr_en <= 1'b0;
end

always begin
	#1 clk = ~clk;
end

always @(posedge ready) begin
	#2 reset <= 1;
	#2 reset <= 0;
	if (dout != din) 
	begin
		$display("FAIL: rx din %x does not match tx %x", dout, din);
		$finish;
	end 
	else 
	begin
		if (dout == 8'hff) 
		begin
			$display("SUCCESS: all bytes verified");
			$finish;
		end
		din <= din + 1'b1;
		wr_en <= 1'b1;
		#2 wr_en <= 1'b0;
		#10;
		$display("Input = %0b | Output = %0b",din,dout);
	end
end

endmodule