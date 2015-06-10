`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: array_multiplier_tb
// Description: Testbench for array_multiplier 
//////////////////////////////////////////////////////////////////////////////////


module array_multiplier_tb(
    );
    
    reg [7:0] a, b;
    wire [15:0] s;
    
    integer k,l, error;
    
    array_multiplier_wrapper DUT (.a0(a[0]), .a1(a[1]), .a2(a[2]), .a3(a[3]), .a4(a[4]), .a5(a[5]), .a6(a[6]), .a7(a[7]), 
    .b0(b[0]), .b1(b[1]), .b2(b[2]), .b3(b[3]), .b4(b[4]), .b5(b[5]), .b6(b[6]), .b7(b[7]),
    .s0(s[0]), .s1(s[1]), .s2(s[2]), .s3(s[3]), .s4(s[4]), .s5(s[5]), .s6(s[6]), .s7(s[7]),
    .s8(s[8]), .s9(s[9]), .s10(s[10]), .s11(s[11]), .s12(s[12]), .s13(s[13]), .s14(s[14]), .s15(s[15])
    );
    
    initial
    begin
        a = 8'h0;
        b = 8'h0;
        error =0;

        for (k=0; k<256; k=k+1) begin
           a = k;
           for (l=0; l<256; l=l+1) begin
              b = l;
              #150;
              if(s !== k*l)
                 begin
                 error = error +1;    
                 $display("Mismatch %d * %d = %d != %d ", k, l, (k*l), s); 
                 end                 
           end
        end

        if(error != 0)
           begin
           $display("***************************");
           $display("Test Failed; %d  mismatches", error);
           $display("***************************");
           end
        else 
           begin
           $display("*******************************************");
           $display("Test Passed! Outputs match expected results");
           $display("*******************************************");
           end
        $stop;        
    end
    
endmodule
