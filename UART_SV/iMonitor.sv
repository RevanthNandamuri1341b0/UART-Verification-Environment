class iMonitor;
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

endclass: iMonitor

task iMonitor::run();
    bit[7:0]din_data;
    $display("[iMon] run started at time=%0t ",$time);
    forever 
    begin
        @(posedge vif.mcb.wr_en);
        no_of_pkts_recvd++;
        $display("[iMon] Started collecting packet %0d at time=%0t ",no_of_pkts_recvd,$time); 
        while (1) 
        begin
            if(vif.mcb.wr_en == 0)
            begin
                pkt = new;
                pkt.data = din_data;
                mbx.put(pkt);
                // begin
                //     packet temp;
                //     #0 while(mbx.num>=1) void'(mbx.try_get(temp));
                // end
            	$display("[iMon] Sent packet %0d [%0d] to scoreboard at time=%0t ",no_of_pkts_recvd,din_data,$time);
                din_data = 'z;
                break;
            end
            din_data = vif.mcb.din;
            @(vif.mcb);
        end
    end
    $display("[iMon] run ended at time=%0t ",$time);
endtask: run

function void iMonitor::report();
    $display("[iMon] Report: total_packets_collected=%0d ",no_of_pkts_recvd); 
endfunction: report