/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Program block to eliminate races and run the test case
*File Name : program_uart.sv
*File ID : 390919
*Modified by : #your name#
*/
`include "uart_pkg.sv"
program program_uart(uart_if pif);
    import uvm_pkg::*;
    import uart_pkg::*;
    // `include "b_test.sv"
    // `include "m_test.sv"
    `include "uart_test.sv"
    initial 
    begin
        $timeformat(-9, 1, "ns", 10);
        uvm_config_db#(virtual uart_if.tb_mod)::set(null, "uvm_test_top", "master_if", pif.tb_mod);
        uvm_config_db#(virtual uart_if.tb_mon)::set(null, "uvm_test_top", "mon_in", pif.tb_mon);
        uvm_config_db#(virtual uart_if.tb_mon)::set(null, "uvm_test_top", "mon_out", pif.tb_mon);
        run_test();
    end
endprogram:program_uart