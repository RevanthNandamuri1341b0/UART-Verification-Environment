/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 24 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Stimulus Driver Class
*File Name : driver.sv
*File ID : 469263
*Modified by : #your name#
*/

class driver extends uvm_driver#(packet);
    `uvm_component_utils(driver);

    bit[31:0] pkt_id;
    virtual uart_if.tb_mod vif;
    
    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task drive(ref packet pkt);
    extern virtual task drive_reset(input packet pkt);
    extern virtual task drive_stimulus(input packet pkt);

        
endclass: driver


function void driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db#(virtual uart_if.tb_mod)::get(get_parent(), "", "drvr_if", vif);
    assert (vif!=null) else  `uvm_fatal(get_type_name(), "Virtual Interface is NULL");
endfunction: connect_phase

task driver::run_phase(uvm_phase phase);
    forever
    begin 
        seq_item_port.get_next_item(req);
        `uvm_info("DRVR RUN", $sformatf("Received %0s transaction[%0d]",req.mode.name(),pkt_id), UVM_MEDIUM)
        drive(req);
        seq_item_port.item_done();
        `uvm_info("DRVR RUN", $sformatf("%0s Transaction[%0d] DONE",req.mode.name(),pkt_id),UVM_MEDIUM)        
        pkt_id++;
    end
endtask: run_phase

task driver::drive(ref packet pkt);
    case (pkt.mode)
        RESET    : drive_reset(pkt);
        STIMULUS : drive_stimulus(pkt);
        default  : begin $display("[DRIVER] Unknown packet received ",pkt.mode.name()); end   
    endcase
endtask: drive

task driver::drive_reset(input packet pkt);
   `uvm_info("RESET", "<Reset_phase> Started, objection raised.", UVM_NONE)
    vif.reset<=1;
    repeat(pkt.reset_cycles)@(vif.cb);
    vif.reset<=0;
    `uvm_info("RESET", "<Reset_phase> Ended, objection raised.", UVM_NONE)
endtask: drive_reset

task driver::drive_stimulus(input packet pkt);
    wait(vif.cb.tx_busy == 0);
    @(vif.cb);
    `uvm_info("DRVR", $sformatf("[Stimulus] Driving of packet %0d [%0d] STARTED at time=%0t",pkt_id,pkt.data,$time), UVM_NONE);
    vif.cb.wr_en <= 1;
    vif.cb.din <= pkt.data;
    @(vif.cb);
    `uvm_info("DRVR", $sformatf("[Stimulus] Driving of packet %0d [%0d] ENDED at time=%0t",pkt_id,pkt.data,$time), UVM_NONE);
    vif.cb.wr_en <= 0;
    @(vif.cb);
    vif.cb.din <= 'z;
    repeat(5)@(vif.cb);
endtask: drive_stimulus
