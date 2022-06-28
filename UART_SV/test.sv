`include "environment.sv"
class test;
    bit[31:0] no_of_pkts;
    virtual uart_if.tb_mod_port vif;
    virtual uart_if.tb_mon vif_mon_in;
    virtual uart_if.tb_mon vif_mon_out;

    environment env;

    function new(input virtual uart_if.tb_mod_port vif,
                 input virtual uart_if.tb_mon vif_mon_in,
                 input virtual uart_if.tb_mon vif_mon_out);
        
        this.vif = vif;
        this.vif_mon_in = vif_mon_in;
        this.vif_mon_out = vif_mon_out;
    
    endfunction: new
    
    extern virtual function void build();
    extern virtual task run();

endclass: test

function void test::build();
    env = new(vif,vif_mon_in,vif_mon_out,no_of_pkts);
    env.build();
endfunction: build

task test::run();
    $display("[Testcase] run Started at time=%0t",$time);
    no_of_pkts=4;
    build();
    env.run();
    $display("[Testcase] run Ended at time=%0t",$time);
endtask: run

