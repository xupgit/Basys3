`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: carry_save_adder_tb
// Description: Testbench for carry_save_adder 
//////////////////////////////////////////////////////////////////////////////////


module carry_save_adder_tb(
    );
    
    reg [3:0] w, x, y, z;
    wire [5:0] s;
    
    integer i,j,k,l, error;
    
    carry_save_adder_wrapper DUT (.w0(w[0]), .w1(w[1]), .w2(w[2]), .w3(w[3]), .x0(x[0]), .x1(x[1]), .x2(x[2]), .x3(x[3]), 
    .y0(y[0]), .y1(y[1]), .y2(y[2]), .y3(y[3]), .z0(z[0]), .z1(z[1]), .z2(z[2]), .z3(z[3]), 
    .s0(s[0]), .s1(s[1]), .s2(s[2]), .s3(s[3]), .s4(s[4]), .s5(s[5])
    );
    
    initial
    begin
        w = 4'h0;
        x = 4'h0;
        y = 4'h0;
        z = 4'h0;
        error =0;
        for (i=0; i<16; i=i+1) begin
           z = i;
           for (j=0; j<16; j=j+1) begin
              y = j;
              for (k=0; k<16; k=k+1) begin
                 x = k;
                 for (l=0; l<16; l=l+1) begin
                    w = l;
                    #50;
                    if(s != i+j+k+l)
                       error = error +1;                   
                 end
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
