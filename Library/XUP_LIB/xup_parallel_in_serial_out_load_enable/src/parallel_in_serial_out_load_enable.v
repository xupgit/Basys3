`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: parallel_in_serial_out_load_enable
/////////////////////////////////////////////////////////////////

module parallel_in_serial_out_load_enable #(parameter SIZE=4, DELAY=3)
(
    input wire clk,
    input wire shift_in,
    input wire [SIZE-1:0]parallel_in,
    input wire load,
    input wire en,
    output wire shift_out,
    output wire [SIZE-1:0] parallel_out
 );

    reg [SIZE-1:0] shift_reg; 
    always @(posedge clk)
       if(load)
          shift_reg <= parallel_in;
       else if (en)
          shift_reg <= {shift_reg[SIZE-2:0], shift_in};
    assign #DELAY shift_out = shift_reg[SIZE-1];
    assign #DELAY parallel_out = shift_reg;
    
endmodule
