/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 27 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Input Monitor for dut to collect input stimulus 
*File Name : iMonitor.sv
*File ID : 002205
*Modified by : #your name#
*/

class iMonitor extends uvm_monitor;
    
    `uvm_component_utils(iMonitor);
    virtual uart_if.tb_mon vif;
    bit[31:0] no_of_pkts_recvd;
    
    uvm_analysis_port#(packet) analysis_port;

    function new(string name = "iMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void connect_phase(uvm_phase phase);    
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
endclass: iMonitor

function void iMonitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual uart_if.tb_mon)::get(get_parent(), "", "iMon_if", vif))
    begin
        `uvm_fatal("IMON_ERROR", "iMonitor DUT Interface not set");
    end 
endfunction: connect_phase


function void iMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);   
    analysis_port = new("analysis_port",this);
endfunction: build_phase

task iMonitor::run_phase(uvm_phase phase);
    bit [7:0] data_in;
  packet pkt;  
  `uvm_info("iMon","iMonitor RUN started",UVM_MEDIUM)
    
    forever 
    begin
        @(posedge vif.mcb.wr_en);
        no_of_pkts_recvd++;
        while (1) 
        begin
            if(vif.mcb.wr_en == 0)
            begin
                pkt = new;
                pkt.data = data_in;
                analysis_port.write(pkt);
                `uvm_info("iMon", $sformatf("Sent packet[%0d] = %0d",no_of_pkts_recvd,data_in),UVM_MEDIUM);
                break;
            end
            data_in = vif.mcb.din;
            @(vif.mcb);
        end  
    end
endtask: run_phase

