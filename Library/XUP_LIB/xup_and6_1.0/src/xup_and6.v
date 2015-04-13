`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: xup_and6
//////////////////////////////////////////////////////////////////////////////////
module xup_and6 #(parameter DELAY=3)(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    input wire e,
    input wire f,
    output wire y
    );
    
    and #DELAY (y,a,b,c,d,e,f);
    
endmodule
