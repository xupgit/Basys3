`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nand3
/////////////////////////////////////////////////////////////////
module xup_nand3 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    input wire c,
    output wire y
    );
    
    nand #DELAY (y,a,b,c);
    
endmodule
