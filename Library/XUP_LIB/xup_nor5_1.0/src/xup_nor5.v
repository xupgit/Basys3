`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nor5
/////////////////////////////////////////////////////////////////
module xup_nor5 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire e,
    output wire y
    );
    
    nor #DELAY (y,a,b,c,d,e);
    
endmodule
