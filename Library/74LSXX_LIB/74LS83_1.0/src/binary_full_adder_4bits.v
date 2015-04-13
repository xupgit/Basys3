`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: binary_full_adder_4bits
// Description: 4-bit Binary Full Adder with Fast Carry and DELAY configuration parameter
// Parameters: DELAY
/////////////////////////////////////////////////////////////////

module binary_full_adder_4bits #(parameter DELAY = 10)(
    input wire a4,a3,a2,a1,b4,b3,b2,b1,
    input wire c0,
    output wire sum4,sum3,sum2,sum1,
    output wire c4
    );
    
    assign #DELAY {c4,sum4,sum3,sum2,sum1} =  {a4,a3,a2,a1} + {b4,b3,b2,b1} + {{3{0}},c0};
    
endmodule
