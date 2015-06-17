`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: shift_nbit_tb
/////////////////////////////////////////////////////////////////

module shift_nbit_tb(
    );
    
    reg dir;
    reg shift_type;
    reg [5:0] p_in;
    wire [5:0] p_out;
    xup_shift_nbit  #(.SIZE(6),.DELAY(4), .NBITS(3)) DUT (.dir(dir), .shift_type(shift_type), .parallel_in(p_in), .parallel_out(p_out));
    
    
    initial
    begin
        dir=0;
        shift_type=0;
        p_in=6'b101101;
        #40;
        #10 dir=1;
        #40;
        #10 shift_type=1;
        #40;
        #10 dir=0;
        #40;
        $stop;
    end

endmodule
