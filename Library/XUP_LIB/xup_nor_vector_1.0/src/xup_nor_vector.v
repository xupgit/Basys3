`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nor_vector
/////////////////////////////////////////////////////////////////
module xup_nor_vector #(parameter SIZE=2, DELAY=3)(
    input wire [SIZE-1:0] a,
    input wire [SIZE-1:0] b,
    output wire [SIZE-1:0] y
    );

   genvar i;
    generate
       for (i=0; i < SIZE; i=i+1) 
       begin: nor_i
          nor #DELAY(y[i], a[i], b[i]);
       end
    endgenerate

endmodule