`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: division_leds_tb
//////////////////////////////////////////////////////////////////////////////////

module division_leds_tb(
    );
    
        parameter PERIOD=20;
    
    reg sys_clock;
    reg start;
    reg [7:0] divisor_in;
    reg [7:0] dividend_in;
    wire done;
    wire [7:0] Remainder;
    wire [7:0] Quotient;
    
    division_leds_wrapper DUT (
    .sys_clock(sys_clock), .start(start), .divisor_in(divisor_in), .dividend_in(dividend_in),
    .done(done), .Quotient(Quotient), .Remainder(Remainder)
    );

    initial begin 
        sys_clock = 0;
        forever #(PERIOD/2) sys_clock = ~sys_clock;
    end
    
    initial
    begin
        start=0;
        @(posedge sys_clock);
        divisor_in = 8'b00000011; // 3
        dividend_in = 8'b0001011; // 11
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(posedge done);
        @(posedge sys_clock);
        divisor_in = 8'b10000000; // 128
        dividend_in = 8'b00000111; // 7
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(posedge done);
        @(posedge sys_clock);
        divisor_in = 8'b00000111; // 7
        dividend_in = 8'b11111100; // 252
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(posedge done);
        @(posedge sys_clock);
        divisor_in = 8'b00000111; // 7
        dividend_in = 8'b00000111; // 7
        #5;
        start = 1; 
        #(2*PERIOD);        
        start = 0;
        @(posedge done);
        @(posedge sys_clock);
        @(posedge sys_clock); 
        @(posedge sys_clock);
        @(posedge sys_clock); 
        $stop;
    end
endmodule

