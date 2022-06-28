/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 24 January 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : Main Transaction sequence class
*File Name : main_sequence.sv
*File ID : 628091
*Modified by : #your name#
*/

class main_sequence extends uvm_sequence#(packet);
    `uvm_object_utils(main_sequence);
    int unsigned pkt_count;
    function new(string name = "main_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new

    extern virtual task pre_start();
    extern virtual task body();
    
endclass: main_sequence

task main_sequence::pre_start();
    if(!uvm_config_db#(int)::get(get_sequencer(), "", "item_count", pkt_count))
    begin
    `uvm_warning(get_full_name(),"Packet count is not set hence generating 3 transaction")
    pkt_count = 3;
    end
    `uvm_info("PKT_CNT",$sformatf("Packet count in sequence=%0d",pkt_count),UVM_NONE)
endtask: pre_start


task main_sequence::body();
    bit [31:0] count;
    REQ ref_pkt;
    ref_pkt = packet::type_id::create("ref_pkt",,get_full_name());
    repeat(pkt_count)
    begin
        `uvm_create(req);
        assert (ref_pkt.randomize());
        start_item(req);
        req.copy(ref_pkt);
        req.mode = STIMULUS;
        finish_item(req);
        count++;
	    `uvm_info("SEQ",$sformatf("Master Sequence : Transaction %0d packet[%0d]DONE ",count,ref_pkt.data),UVM_MEDIUM);
    end
endtask: body
