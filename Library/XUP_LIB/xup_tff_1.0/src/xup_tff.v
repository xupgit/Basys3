`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tff
/////////////////////////////////////////////////////////////////
module xup_tff#(parameter DELAY = 3)(
    input wire t,
    input wire clk,
    output reg q
    );
    initial q=0;
    always @(posedge clk)
    begin 
        q <= #DELAY t^q;
    end
    
endmodule
