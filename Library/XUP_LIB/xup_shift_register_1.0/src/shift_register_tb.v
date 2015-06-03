`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: shift_register_tb
/////////////////////////////////////////////////////////////////

module shift_register_tb(
    );
    
    reg clk;
    reg shift_in;
    reg load, en, dir;
    reg [5:0] p_in;
    wire shift_out;
    wire [5:0] p_out;
    
    xup_shift_register  #(.SIZE(6),.DELAY(4)) DUT (.clk(clk), .shift_in(shift_in), .load(load), .en(en), .dir(dir), .parallel_in(p_in), .shift_out(shift_out), .parallel_out(p_out));
    
    always 
            #5 clk = ~clk;    // every ten nanoseconds invert the clock
    
    initial
    begin
        clk=0;
        load=0;
        en=0;
        dir=0;
        shift_in=1;
        p_in=5'b101101;
        #10 load=1;
        #10 load=0;
        #30 en=1;
        #40;
        #10 dir=1;
        #40;
        #10 load=1;
        #10 load=0;
        #20;
        #10 en=0;
        #20;
        #10 en=1;
        #30;
        #10 shift_in=0;
        #40;
        #10 dir=0;
        #40;
    end

endmodule
