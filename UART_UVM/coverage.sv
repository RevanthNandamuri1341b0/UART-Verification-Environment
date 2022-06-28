/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 02 April 2022
*Project name : UART Verification Environment
*Domain : UVM
*Description : Functional coverage 
*File Name : coverage.sv
*File ID : 313454
*Modified by : #your name#
*/

class coverage extends uvm_subscriber#(packet);
    `uvm_component_utils(coverage);

    real coverage_score;
    packet pkt;

    covergroup cg_uart with function sample(packet pkt);
    coverpoint pkt.data
    {
        bins small_sata  = {[0:$]};
        // bins small_sata  = {[0:50]};
        // bins medium_sata = {[51:200]};
        // bins big_sata    = {[201:$]};
    }
    endgroup: cg_uart

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cg_uart = new;
    endfunction: new

   extern virtual function void write(T t);
   extern virtual function void extract_phase(uvm_phase phase);

endclass: coverage

function void coverage::write(T t);
    if(!$cast(pkt, t.clone))
    begin
        `uvm_fatal("COV", "Transaction object supplied is NULL in coverage component ")
    end
    cg_uart.sample(pkt);
    coverage_score = cg_uart.get_coverage();
    `uvm_info("COV",$sformatf("Coverage=%0f%%",coverage_score),UVM_MEDIUM);
endfunction: write

function void coverage::extract_phase(uvm_phase phase);
    uvm_config_db#(real)::set(null,"uvm_test_top.env","cov_score",coverage_score);
endfunction: extract_phase