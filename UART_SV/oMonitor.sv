class oMonitor;
    packet pkt;
    virtual uart_if.tb_mon vif;
    mailbox#(packet) mbx;
    bit[31:0] no_of_pkts_recvd;

    function new(input mailbox#(packet) mbx,input virtual uart_if.tb_mon vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction: new
    
    extern virtual task run();
    extern virtual function void report();

endclass: oMonitor

task oMonitor::run();
    bit[7:0] dout_data;
    $display("[oMon] run started at time=%0t ",$time);
    forever 
    begin
        @(posedge vif.mcb.ready);
        no_of_pkts_recvd++;
        $display("[oMon] Started collecting packet %0d at time=%0t ",no_of_pkts_recvd,$time); 
        while (1) 
        begin
            if(vif.mcb.ready == 0)
            begin 
                pkt = new;
                pkt.data = dout_data;
                mbx.put(pkt);
                $display("[oMon] Sent packet %0d [%0d] to scoreboard at time=%0t ",no_of_pkts_recvd,dout_data,$time);
                //dout_data = 'z;
                break;            
            end
            dout_data = vif.mcb.dout;
            @(vif.mcb);
        end
    end
    $display("[oMon] run ended at time=%0t ",$time);
endtask: run


function void oMonitor::report();
    $display("[oMon] Report: total_packets_collected=%0d ",no_of_pkts_recvd); 
endfunction: report