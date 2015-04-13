`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_xnor2
/////////////////////////////////////////////////////////////////
module xup_xnor2 #(parameter DELAY = 3)(
    input wire a,
    input wire b,
    output wire y
    );
    
    xnor #DELAY (y,a,b);
    
endmodule
