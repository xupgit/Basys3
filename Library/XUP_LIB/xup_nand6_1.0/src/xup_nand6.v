`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nand6
/////////////////////////////////////////////////////////////////
module xup_nand6 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire e,
    input wire f,
    output wire y
    );
    
    nand #DELAY (y,a,b,c,d,e,f);
    
endmodule
