`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: xup_shift_nbit
/////////////////////////////////////////////////////////////////

module xup_shift_nbit#(parameter SIZE=4, DELAY=3, NBITS=1)
(
    input wire [SIZE-1:0]parallel_in,
    input wire dir,
    input wire shift_type,
    output wire [SIZE-1:0] parallel_out
 );

    wire signed [SIZE-1:0]in1_signed;
    reg [SIZE-1:0] shift_reg; 
    
    assign in1_signed = parallel_in;
    always @(*)
      case(shift_type)
		1'b1 : begin  // shift_type=1 => arithmetic
                    if (dir) // dir=1 then left shift
                        shift_reg <= {parallel_in[SIZE-NBITS-1:0], {NBITS{1'b0}}};
                    else
                        shift_reg <= in1_signed >>> NBITS; 
			   end
		1'b0 : begin  // shift_type=0 => logical
		            if(dir)
                        shift_reg <= {parallel_in[SIZE-NBITS-1:0], {NBITS{1'b0}}};
                    else
                        shift_reg <= in1_signed >> NBITS; 	            
			   end
		default : begin // default is logical
		            if(dir)
                        shift_reg <= {parallel_in[SIZE-NBITS-1:0], {NBITS{1'b0}}};
                    else
                        shift_reg <= in1_signed >> NBITS; 
				end
	  endcase
    assign #DELAY parallel_out = shift_reg;
    
endmodule
