`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_nand2
/////////////////////////////////////////////////////////////////
module xup_nand2 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    output wire y
    );
    
    nand #DELAY (y,a,b);
    
endmodule
