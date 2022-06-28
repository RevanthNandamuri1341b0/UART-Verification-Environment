class scoreboard;

    packet ref_pkt,got_pkt;
    mailbox#(packet) mbx_in,mbx_out;
    bit[31:0] total,m_matched,m_mismatched;

    function new(input mailbox#(packet) mbx_in,input mailbox#(packet) mbx_out);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
    endfunction: new
    
    extern virtual task run();
    extern virtual function void report();

endclass: scoreboard

task scoreboard::run();
    $display("[Scoreboard] run started at time=%0t",$time); 
    while (1) 
    begin
        mbx_in.get(ref_pkt);
        mbx_out.get(got_pkt);
        total++;
        $display("[Scoreboard] Packet %0d @time = %0t",total,$time);
        if(ref_pkt.compare(got_pkt))
        begin
            m_matched++;
            $display("\n[Scoreboard] Packet %0d Matched @time = %0t",total,$time);
            $display("[Scoreboard] *** Expected Packet to DUT****");
            ref_pkt.print();
            $display("[Scoreboard] *** Received Packet From DUT****");
            got_pkt.print();
        end
        else
        begin
            m_mismatched++;
            $display("\n[Scoreboard] Packet %0d Mismatched @time = %0t",total,$time);
            $display("[Scoreboard] *** Expected Packet to DUT ***");
            ref_pkt.print();
            $display("[Scoreboard] *** Received Packet From DUT ***");
            got_pkt.print();
        end
    end    
    $display("[Scoreboard] run ended at time=%0t",$time);
endtask: run

function void scoreboard::report();
    $display("[Scoreboard] Report: Total Packets Received=%0d",total); 
    $display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d",m_matched,m_mismatched);   
endfunction: report
