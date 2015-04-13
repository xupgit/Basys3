`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tff_en
/////////////////////////////////////////////////////////////////
module xup_tff_en#(parameter DELAY = 3)(
    input wire t,
    input wire clk,
    input wire en,
    output reg q
    );
    
    initial q=0;
    always @(posedge clk)
    begin 
        if(en)
            q<= #DELAY t^q;
    end
endmodule
