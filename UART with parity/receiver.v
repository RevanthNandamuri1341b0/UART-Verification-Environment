module receiver (rx,clk,clk_en,reset,ready,dout);
    input rx;
    input clk;
    input clk_en;
    input reset;
    output reg ready; //Verification purpose
    output reg [7:0]dout;

    initial 
    begin
        ready = 0;
        dout = 8'd0;
    end
    
    parameter RX_STATE_START	= 2'b00;
    parameter RX_STATE_DATA		= 2'b01;
    parameter RX_STATE_PARITY	= 2'b10;
    parameter RX_STATE_STOP		= 2'b11;

    reg [1:0] state     = RX_STATE_START; 
    reg [3:0] sample    = 0;
    reg [3:0] bit_pos   = 0;
    reg [7:0] op_reg    = 0;

    always @(posedge clk) 
    begin
        if(reset)   ready <= 0;

        if(clk_en)
        begin
            case (state)
                RX_STATE_START : 
                    begin
                        if(!rx || sample != 0) 
                            sample <= sample + 4'b1;

                        if(sample == 15)
                        begin
                            state   <= RX_STATE_DATA;
                            bit_pos <= 0;
                            sample  <= 0;
                            op_reg  <= 0;
                        end
                    end
                RX_STATE_DATA  : 
                    begin
                        sample <= sample + 4'b1;
                        if(sample == 4'h8)
                        begin
                            op_reg[bit_pos[2:0]] <= rx;
                            bit_pos <= bit_pos + 4'b1;
                        end
                        if(bit_pos == 8 && sample == 15)    state <= RX_STATE_PARITY;
                    end
                RX_STATE_PARITY:
                begin
                    if(rx != ^op_reg)
                    begin
                        $display("Mismatch in the transmission of data - Packet Dropped");
                        state  <= RX_STATE_START;
                        dout   <= op_reg;
                        ready <= 1'b1;
                        sample <= 0;
                    end
                end
                RX_STATE_STOP  : 
                    begin
                        if(sample == 15 || (sample >= 8 && !rx))
                        begin
                            state  <= RX_STATE_START;
                            dout   <= op_reg;
                            ready <= 1'b1;
				            sample <= 0;
                        end
                        else    sample <= sample + 4'b1;
                    end
                default: 
                    begin
                        state <= RX_STATE_START;
                    end
            endcase
        end
    end
endmodule