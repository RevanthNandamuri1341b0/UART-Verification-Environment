class generator;
    
    bit[31:0]pkt_count;
    packet ref_pkt;
    mailbox#(packet) mbx;

    function new(input mailbox#(packet) mbx,input bit[31:0] pkt_count);
        this.mbx = mbx;
        this.pkt_count = pkt_count;
        ref_pkt = new;
    endfunction: new

    extern virtual task run();

endclass: generator

task generator::run();
    bit[31:0]pkt_id;
    packet gen_pkt;
    gen_pkt = new;
    gen_pkt.kind = RESET;
    gen_pkt.reset_cycles = 2;
    $display("[GENERATOR]: Sending %0s Packet %0d to Driver at time = %0t",gen_pkt.kind.name(),pkt_id,$time);
    mbx.put(gen_pkt);
    repeat(pkt_count)
    begin
        pkt_id++;
        assert(ref_pkt.randomize()); 
        gen_pkt = new;
        gen_pkt.kind = STIMULUS;
        gen_pkt.copy(ref_pkt);
        mbx.put(gen_pkt);
        $display("[GENERATOR]: Sending %0s Packet %0d to Driver at time = %0t",gen_pkt.kind.name(),pkt_id,$time);
    end
endtask: run

