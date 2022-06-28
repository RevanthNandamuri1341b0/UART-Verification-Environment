typedef enum { IDLE,RESET,STIMULUS } pkt_type_t;
class packet;
    
    rand bit[7:0] data;
    bit [7:0]reset_cycles;
    pkt_type_t kind;
    
    extern constraint valid;
    extern virtual function void copy(packet rhs);
    extern virtual function bit compare(input packet dut_pkt);
    extern virtual function void print();


endclass: packet

constraint packet::valid 
{
    data inside {[0:250]};
}

function void packet::copy(packet rhs);
    if (rhs==null) 
    begin
        $display("[Error]NULL handle passed to copy");
        $finish;    
    end
    this.data=rhs.data;
endfunction: copy

function bit packet::compare(input packet dut_pkt);
    return (this.data == dut_pkt.data);
endfunction: compare

function void packet::print();
    $display("\n[data = %0d]\n",data);
endfunction: print

