`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ripple_carry_adder_tb
// Description: Testbench for ripple_carry_adder 
//////////////////////////////////////////////////////////////////////////////////


module ripple_carry_adder_tb(
    );
    
    reg [7:0] a, b;
    reg c_in;
    wire [7:0] s;
    wire c_out;
    
    ripple_carry_adder_wrapper DUT (.a0(a[0]), .a1(a[1]), .a2(a[2]), .a3(a[3]), .a4(a[4]), .a5(a[5]), .a6(a[6]), .a7(a[7]), 
    .b0(b[0]), .b1(b[1]), .b2(b[2]), .b3(b[3]), .b4(b[4]), .b5(b[5]), .b6(b[6]), .b7(b[7]), .c_in(c_in),
    .s0(s[0]), .s1(s[1]), .s2(s[2]), .s3(s[3]), .s4(s[4]), .s5(s[5]), .s6(s[6]), .s7(s[7]), .c_out(c_out)
    );
    
    initial
    begin
        a = 8'h0;
        b = 8'h0;
        c_in = 1'b0;
        #50;
        a = 8'h0;
        b = 8'h2;
        c_in = 1'b0;
        #50;
        a = 8'h1;
        b = 8'h9;
        c_in = 1'b0;
        #50;
        a = 8'h4;
        b = 8'h40;
        c_in = 1'b0;
        #50;
        a = 8'h11;
        b = 8'h11;
        c_in = 1'b1;
        #50;
        a = 8'h23;
        b = 8'h29;
        c_in = 1'b0;
        #50;
        a = 8'h45;
        b = 8'h42;
        c_in = 1'b1;
        #50;
        a = 8'h89;
        b = 8'h94;
        c_in = 1'b0;
        #50;
        a = 8'hc1;
        b = 8'hc8;
        c_in = 1'b1;
        #50;
        a = 8'he1;
        b = 8'he2;
        c_in = 1'b0;
        #50;
        $stop;        
    end
    
endmodule
