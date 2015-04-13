`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: mux_8_to_1
// Description: A 8-input Digital Multiplexer with DELAY configuration parameter
// Parameters: DELAY
/////////////////////////////////////////////////////////////////

module mux_8_to_1 #(parameter DELAY = 10)(
    input wire s_n,a2,a1,a0,d7,d6,d5,d4,d3,d2,d1,d0,
    output wire q,q_n
    );
	
    reg q_r;
    wire [2:0]A;
    
    assign A = {a2,a1,a0};
    
    always@(*)begin
        if(s_n)
            q_r <= 1'b0;
        else
            case(A)
                3'b000: q_r <= d0;
                3'b001: q_r <= d1;
                3'b010: q_r <= d2;
                3'b011: q_r <= d3;
                3'b100: q_r <= d4;
                3'b101: q_r <= d5;
                3'b110: q_r <= d6;
                3'b111: q_r <= d7;
            endcase
    end
        
    assign #DELAY q = q_r;
    assign #DELAY q_n = ~q_r;
    
endmodule
