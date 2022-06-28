
module uart_tx_test();
    reg [7:0] din = 0;
	reg clk=0; always #5 clk=~clk;
	reg reset=1; initial #15 reset = 0;
	reg wr_en;
    wire tx_busy;
	wire ready;
	wire [7:0] dout;
	//! reg wr_en=1; initial #10 wr_en = 0;
    
    uart test_uart(.din(din),
                   .wr_en(wr_en),
                   .clk(clk),
                   .tx_busy(tx_busy),
                   .ready(ready),
                   .reset(reset),
                   .dout(dout));

    initial 
    begin
        repeat(10)
        begin
            wr_en <= 1;
            din <= $random;
            @(posedge clk);
            wr_en <= 0;
            @(posedge ready);
            $display("Input = %0b   and     Output = %0b",din,dout);
            if(din!=dout)   $display("=========[FAIL]=========");
            else            $display("=========[PASS]=========");
        end

        repeat(2)@(posedge clk);

        wr_en <= 1;
        din <= 8'b11110000;
        @(posedge clk);
        wr_en <= 0;
        @(posedge ready);
        $display("Input = %0b   and     Output = %0b",din,dout);
        
        repeat(2)@(posedge clk);
        $finish;
    end

endmodule