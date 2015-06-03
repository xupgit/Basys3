`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_range_comparator 
/////////////////////////////////////////////////////////////////
module xup_range_comparator #(parameter SIZE = 4 , DELAY = 3)(
  input wire [SIZE-1:0] in1,
  input wire [SIZE-1:0] in2,
  input wire sign,
  output wire lt,
  output wire le,
  output wire eq,
  output wire gt,
  output wire ge
  );

wire signed [SIZE-1:0] in1_signed;
wire signed [SIZE-1:0] in2_signed;
wire lower, lower_same, same, higher_same, higher;
wire less, less_equal, equal, greater_equal, greater;

    assign in1_signed = in1;
    assign in2_signed = in2;
    assign #DELAY lt = (sign) ? less : lower;
    assign #DELAY le = (sign) ? less_equal : lower_same;
    assign #DELAY eq = (sign) ? equal : same;
    assign #DELAY gt = (sign) ? greater : higher;
    assign #DELAY ge = (sign) ? greater_equal : higher_same;

// Unsigned data handling    
    assign lower = (in1 < in2)? 1'b1: 1'b0;
    assign lower_same = (in1 <= in2)? 1'b1: 1'b0;
    assign same = (in1 == in2)? 1'b1: 1'b0;
    assign higher_same = (in1 >= in2)? 1'b1: 1'b0;
    assign higher = (in1 > in2)? 1'b1: 1'b0;

// Signed data handling
    assign less = (in1_signed < in2_signed)? 1'b1: 1'b0;
    assign less_equal = (in1_signed <= in2_signed)? 1'b1: 1'b0;
    assign equal = (in1_signed == in2_signed)? 1'b1: 1'b0;
    assign greater_equal = (in1_signed >= in2_signed)? 1'b1: 1'b0;
    assign greater = (in1_signed > in2_signed)? 1'b1: 1'b0;

endmodule
