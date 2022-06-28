/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 27 January 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : passive Slave agent 
*File Name : slave_agent.sv
*File ID : 065412
*Modified by : #your name#
*/

class slave_agent extends uvm_agent;
    `uvm_component_utils(slave_agent);

    oMonitor oMon;
    uvm_analysis_port#(packet) ap;

    function new(string name = "slave_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);    

endclass: slave_agent

function void slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap",this);
    oMon = oMonitor::type_id::create("oMon",this);   
endfunction: build_phase

function void slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    oMon.analysis_port.connect(this.ap);
endfunction: connect_phase

