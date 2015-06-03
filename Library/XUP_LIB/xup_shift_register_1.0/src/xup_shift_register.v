`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_shift_register
/////////////////////////////////////////////////////////////////

module xup_shift_register#(parameter SIZE=4, DELAY=3, PARALLEL_IN=1, EN=1, LOAD=1, DIR=1, PARALLEL_OUT=1)
(
    input wire clk,
    input wire shift_in,
    input wire [SIZE-1:0]parallel_in,
    input wire load,
    input wire en,
    input wire dir,
    output wire shift_out,
    output wire [SIZE-1:0] parallel_out
 );

    reg [SIZE-1:0] shift_reg; 
    always @(posedge clk)
       if(load)
          shift_reg <= parallel_in;
       else if (en)
            if (dir) // dir=1 then left shift
                shift_reg <= {shift_reg[SIZE-2:0], shift_in};
            else
                shift_reg <= {shift_in, shift_reg[SIZE-1:1]};
                
    assign #DELAY shift_out = dir ? shift_reg[SIZE-1] : shift_reg[0];
    assign #DELAY parallel_out = shift_reg;
    
endmodule
