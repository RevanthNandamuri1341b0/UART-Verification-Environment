/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 27 January 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : Master agent that connect Driver, Sequencer and input Monitor. 
*File Name : master_agent.sv
*File ID : 816644
*Modified by : #your name#
*/

class master_agent extends uvm_agent;

    `uvm_component_utils(master_agent);

    driver drvr;
    sequencer seqr;
    iMonitor iMon;
    uvm_analysis_port#(packet) ap;
    
    function new(string name = "master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);   

endclass: master_agent

function void master_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap",this);
    if(is_active == UVM_ACTIVE)
    begin
        seqr = sequencer::type_id::create("seqr",this);
        drvr = driver::type_id::create("drvr",this);
    end
    iMon = iMonitor::type_id::create("iMon",this);
endfunction: build_phase

function void master_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)
    begin
        drvr.seq_item_port.connect(seqr.seq_item_export);
    end
    iMon.analysis_port.connect(this.ap);
endfunction: connect_phase
