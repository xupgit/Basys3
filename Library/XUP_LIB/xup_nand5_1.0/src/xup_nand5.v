`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nand5
/////////////////////////////////////////////////////////////////
module xup_nand5 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire e,
    output wire y
    );
    
    nand #DELAY (y,a,b,c,d,e);
    
endmodule
