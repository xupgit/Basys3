`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_tff_en_reset
/////////////////////////////////////////////////////////////////
module xup_tff_en_reset #(parameter DELAY = 3)(
    input wire t,
    input wire clk,
    input wire en,
    input wire reset,
    output reg q
    );
    
    initial q=0;
    always @(posedge clk)
    begin 
        if(reset)
		 q<= #DELAY 0;
        else if(en)
            q<= #DELAY t^q;
    end
endmodule
