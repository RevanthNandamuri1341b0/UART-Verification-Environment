/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 27 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Output Monitor for dut to collect output stimulus 
*File Name : oMonitor.sv
*File ID : 002205
*Modified by : #your name#
*/

class oMonitor extends uvm_monitor;
    
    `uvm_component_utils(oMonitor);
    virtual uart_if.tb_mon vif;
    bit[31:0] no_of_pkts_recvd;
    uvm_analysis_port#(packet) analysis_port;
    
    function new(string name = "oMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    
    
endclass: oMonitor

function void oMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase); 
    analysis_port = new("analysis_port",this);
endfunction: build_phase

function void oMonitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual uart_if.tb_mon)::get(get_parent(), "", "oMon_if", vif))
    begin
        `uvm_fatal(get_type_name(), "oMonitor DUT Interface not set");
    end  
endfunction: connect_phase

task oMonitor::run_phase(uvm_phase phase);
    bit[7:0] data_out;
    packet pkt;
    forever 
    begin
        @(posedge vif.mcb.ready);
        no_of_pkts_recvd++;
        while (1) 
        begin
            if(vif.mcb.ready == 0)
            begin
                pkt = new;
                pkt.data = data_out;
                analysis_port.write(pkt);
                `uvm_info("oMon", $sformatf("Sent packet[%0d] = %0d",no_of_pkts_recvd,data_out),UVM_MEDIUM);
                break;
            end
            data_out = vif.mcb.dout;
            @(vif.mcb);
        end  
    end
endtask: run_phase
