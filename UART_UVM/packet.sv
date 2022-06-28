/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 22 January 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Transaction Packet class
*File Name : packet.sv
*File ID : 272122
*Modified by : #your name#
*/
typedef enum  { IDLE,RESET,STIMULUS } pkt_type;

class packet extends uvm_sequence_item;

    rand logic [7:0]data;
    pkt_type mode;
    bit[7:0] reset_cycles;
    bit [7:0] prev_data;

   `uvm_object_utils_begin(packet)
       `uvm_field_int(data,UVM_ALL_ON|UVM_NOCOMPARE|UVM_DEC)
   `uvm_object_utils_end

    extern constraint valid;
    extern function void post_randomize();
    extern virtual function string input2string();
    extern virtual function string convert2string();
    // extern virtual function bit do_compare(uvm_object rhs ,uvm_comparer comparer);

    function new(string name = "packet");
        super.new(name);
    endfunction: new
    
endclass: packet

constraint packet::valid 
{
    data inside {[1:100]};
    data != prev_data;
}

function void packet::post_randomize();
    prev_data = data;
endfunction: post_randomize

function string packet::convert2string();
    return $sformatf("data=%0d",data);
endfunction: convert2string

function string packet::input2string();
    return $sformatf("| data = %0d |",data);
endfunction: input2string



