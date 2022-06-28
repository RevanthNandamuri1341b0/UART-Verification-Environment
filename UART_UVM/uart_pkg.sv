/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Package class including all the files 
*File Name : uart_pkg.sv
*File ID : 607452
*Modified by : #your name#
*/

package uart_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "packet.sv"
    
   // `include "base_sequence.sv"
    `include "reset_sequence.sv"
    `include "main_sequence.sv"
    
    `include "sequencer.sv"
    `include "driver.sv"
    `include "iMonitor.sv"
    `include "master_agent.sv"
    
    `include "oMonitor.sv"
    `include "slave_agent.sv"

    `include "coverage.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
endpackage