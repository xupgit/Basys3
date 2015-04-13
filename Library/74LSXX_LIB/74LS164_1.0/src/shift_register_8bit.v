`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: shift_register_8bit
// Description: A 8-bit Parallel-Out Serial Shift Register with DELAY configuration parameter
// Parameters: DELAY
/////////////////////////////////////////////////////////////////

module shift_register_8bit #(parameter DELAY = 10)(
    input wire dsa,dsb,cp,mr_n,
    output wire q7,q6,q5,q4,q3,q2,q1,q0
    );
    
    reg [7:0]q_r;
    
    always@(posedge cp,negedge mr_n)begin
        if(!mr_n)
            q_r <= 8'b0;
        else begin
            q_r = q_r << 1;
            q_r[0] = dsa && dsb;
        end
    end
    
    assign #DELAY {q7,q6,q5,q4,q3,q2,q1,q0} = q_r;
    
endmodule
