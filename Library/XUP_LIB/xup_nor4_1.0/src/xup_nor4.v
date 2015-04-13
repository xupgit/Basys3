`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nor4
/////////////////////////////////////////////////////////////////
module xup_nor4 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire y
    );
    
    nor #DELAY (y,a,b,c,d);
    
endmodule
