/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 24 January 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : Reset packet class
*File Name : reset_sequence.sv
*File ID : 062584
*Modified by : #your name#
*/

class reset_sequence extends uvm_sequence#(packet);
    `uvm_object_utils(reset_sequence);

    function new(string name = "reset_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new
    
    extern virtual task body();

endclass: reset_sequence

task reset_sequence::body();
    begin
        `uvm_info("RESET", "RESET Transaction STARTED", UVM_MEDIUM)
        `uvm_create(req);
        start_item(req);
        req.mode = RESET;
        req.reset_cycles = 2;
        finish_item(req);
        `uvm_info("RESET", "RESET Transaction ENDED", UVM_MEDIUM)
    end
endtask: body
