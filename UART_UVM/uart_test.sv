/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 03 February 2022
*Project name : UART Verification Environment
*Domain : UVM 
*Description : Test Case Generation
*File Name : uart_test.sv
*File ID : 229234
*Modified by : #your name#
*/

class uart_test extends uvm_test;
    `uvm_component_utils(uart_test);
    
    int unsigned item_count;
    environment env;
    virtual uart_if.tb_mod mvif;
    virtual uart_if.tb_mon vif_min;
    virtual uart_if.tb_mon vif_mout;

    function new(string name = "uart_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);

endclass: uart_test

function void uart_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_count = 10;
    env = environment::type_id::create("env",this);
    uvm_config_db#(virtual uart_if.tb_mod)::get(this, "", "master_if", mvif);
    uvm_config_db#(virtual uart_if.tb_mon)::get(this, "", "mon_in", vif_min);
    uvm_config_db#(virtual uart_if.tb_mon)::get(this, "", "mon_out", vif_mout);
    
    uvm_config_db#(virtual uart_if.tb_mod)::set(this, "env.m_agent", "drvr_if", mvif);
    uvm_config_db#(virtual uart_if.tb_mon)::set(this, "env.m_agent", "iMon_if", vif_min);
    uvm_config_db#(virtual uart_if.tb_mon)::set(this, "env.s_agent", "oMon_if", vif_mout);

    uvm_config_db#(int)::set(this, "env.*", "item_count", item_count);

    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seqr.main_phase","default_sequence",main_sequence::get_type());
   
endfunction: build_phase

task uart_test::main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
    objection = phase.get_objection();
  objection.set_drain_time(this,2000000ns);
endtask: main_phase

