`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: booth_multiplier_leds_tb
//////////////////////////////////////////////////////////////////////////////////


module booth_multiplier_leds_tb(

    );
    
    parameter PERIOD=20;
    
    reg sys_clock;
    reg start;
    reg [7:0] multiplier_in;
    reg [7:0] multiplicand_in;
    wire [15:0] result;
    
    booth_multiplier_leds_wrapper DUT (
    .sys_clock(sys_clock), .start(start), .multiplier_in(multiplier_in), .multiplicand_in(multiplicand_in),
    .result(result)
    );

    initial begin 
        sys_clock = 0;
        forever #(PERIOD/2) sys_clock = ~sys_clock;
    end
    
    initial
    begin
        start=0;
        @(posedge sys_clock);
        multiplier_in = 8'b00000111; // 7
        multiplicand_in = 8'b00000111; // 7
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq);
        @(posedge sys_clock);
        multiplier_in = 8'b11111100; // -4
        multiplicand_in = 8'b11111100; // -4
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq);
        @(posedge sys_clock);
        multiplier_in = 8'b00000111; // 7
        multiplicand_in = 8'b11111100; // -4
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq);
        @(posedge sys_clock);
        multiplier_in = 8'b11111100; // -4
        multiplicand_in = 8'b11111100; // -4
        #5;
        start = 1;
        #(2*PERIOD);
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq);
        @(posedge sys_clock);
        multiplier_in = 8'b00000111; // 7
        multiplicand_in = 8'b00000111; // 7
        #5;
        start = 1; 
        #(2*PERIOD);        
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq);
        @(posedge sys_clock);
        multiplier_in = 8'b11111100; // -4
        multiplicand_in = 8'b00000111; // 7
        #5;
        start = 1; 
        #(2*PERIOD);
        start = 0;
        @(negedge booth_multiplier_leds_tb.DUT.booth_multiplier_leds_i.control_unit_eq); 
        @(posedge sys_clock);
        $stop;
    end
endmodule
