module transmitter (din,wr_en,clk,clk_en,tx,tx_busy);
    input [7:0] din;
    input wr_en;
    input clk;
    input clk_en;
    output reg tx;
    output tx_busy;
    
    initial 
    begin
	 tx = 1'b1;
    end
    
parameter STATE_IDLE	= 3'b00;
parameter STATE_START	= 3'b01;
parameter STATE_DATA	= 3'b10;
parameter STATE_PARITY	= 3'b11;
parameter STATE_STOP	= 3'b100;

    reg [7:0] data      = 8'h00;
    reg [2:0] bit_pos   = 3'h0;
    reg [2:0] state     = STATE_IDLE;

    always @(posedge clk ) 
    begin
        case (state)
            STATE_IDLE: 
            begin
                if (wr_en) 
                begin
                    state <= STATE_START;
                    data<=din;
                    bit_pos<=3'h0;
                end                 
            end
            STATE_START:
            begin
                if (clk_en) 
                begin
                    tx<=1'b0;
                    state<=STATE_DATA;
                end              
            end
            STATE_DATA:
            begin
                if (clk_en) 
                begin
                    if(bit_pos==3'h7)
                    begin
                        state<=STATE_PARITY;
                    end
                    else
                        bit_pos <= bit_pos + 3'h1;
                    tx<=data[bit_pos];    
                end
            end
            STATE_PARITY:
            begin
                if(clk_en)
                begin
                    tx <= ^data;
                    state <= STATE_STOP;
                end
            end
            
            STATE_STOP:
            begin
                if (clk_en) 
                begin
                    tx<=1'b1;
                    state<=STATE_IDLE;    
                end
            end

            default: 
            begin
                tx<=1'b1;
                state<=STATE_IDLE;    
            end
        endcase   
    end
assign tx_busy=(state!=STATE_IDLE);
endmodule