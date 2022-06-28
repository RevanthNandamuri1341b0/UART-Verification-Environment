class driver;
    packet pkt;
    virtual uart_if.tb_mod_port vif;
    mailbox#(packet) mbx;
    bit[31:0] no_of_pkts_recvd;

    function new(input mailbox#(packet) mbx,input virtual uart_if.tb_mod_port vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction: new
    
    extern virtual task run();
    extern virtual task drive(packet pkt);
    extern virtual task drive_reset(packet pkt);
    extern virtual task drive_stimulus(packet pkt);

endclass: driver

task driver::run();
    $display("[Driver] Run Started at time = %0t",$time);
    while (1) 
    begin
        mbx.get(pkt);
        $display("[Driver] Received %0s Packet %0d From the generator at time = %0t",pkt.kind.name(),pkt.data,$time);
        drive(pkt);
        $display("[Driver] Driven %0s Packet %0d to DUT at time = %0t",pkt.kind.name(),pkt.data,$time);
    end
endtask: run

task driver::drive(packet pkt);
    case (pkt.kind)
        RESET    : drive_reset(pkt); 
        STIMULUS : drive_stimulus(pkt);
        default  : $display("[DRIVER ERROR] Invalid Packet received"); 
    endcase
endtask: drive

task driver::drive_reset(packet pkt);
    $display("[Driver] Started Driving Reset transaction into DUT at time=%0t",$time); 
    vif.reset <= 1;
    repeat(pkt.reset_cycles)@(vif.cb)
    vif.reset <= 0;
    $display("[Driver] Completed Driving Reset transaction into DUT at time=%0t",$time); 
endtask: drive_reset

task driver::drive_stimulus(packet pkt);
    wait(vif.cb.tx_busy == 0);
    @(vif.cb)
    no_of_pkts_recvd++;
    $display("[Driver] Driving of packet %0d [%0d] started at time=%0t",no_of_pkts_recvd,pkt.data,$time);
    vif.cb.wr_en <= 1;
    vif.cb.din <= pkt.data;
    @(vif.cb);
    $display("[Driver] Driving of packet %0d [%0d] Ended at time=%0t",no_of_pkts_recvd,pkt.data,$time);
    vif.cb.wr_en <= 0;
    repeat(5)@(vif.cb);
endtask: drive_stimulus
