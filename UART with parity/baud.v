/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 June 2022
*Project name : UART with Parity Check
*Domain : Verilog
*Description : 
*Refrence : 
*File Name : baud.v
*File ID : 274492
*Modified by : #your name#
*/

module baud (clk,rx_en,tx_en);
    input clk;
    output rx_en,tx_en;
    
    parameter RX_MAX   = 50000000/(115200*16);    
    parameter TX_MAX   = 50000000/115200;    
    parameter RX_WIDTH = $clog2(RX_MAX);
    parameter TX_WIDTH = $clog2(TX_MAX);
    reg [RX_WIDTH-1:0] rx_acc = 0;
    reg [TX_WIDTH-1:0] tx_acc = 0;

    assign rx_en = (rx_acc == 5'd0);
    assign tx_en = (tx_acc == 9'd0);

    always @(posedge clk)
    begin
        if(rx_acc == RX_MAX[RX_WIDTH-1:0])  rx_acc <= 0;
        else                                rx_acc <= rx_acc + 1;
    end
    
    always @(posedge clk)
    begin
        if(tx_acc == TX_MAX[TX_WIDTH-1:0])  tx_acc <= 0;
        else                                tx_acc <= tx_acc + 1;
    end

endmodule