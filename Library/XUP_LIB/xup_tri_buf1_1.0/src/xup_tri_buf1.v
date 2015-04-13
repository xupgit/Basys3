`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tri_buf1
/////////////////////////////////////////////////////////////////
module xup_tri_buf1 #(parameter DELAY = 3)(
    input wire a,
    input wire enable,
    output wire y
    );
    
    bufif1 #DELAY (y,a,enable);
    
endmodule