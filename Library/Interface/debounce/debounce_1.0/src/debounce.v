`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: debounce
// Description: This IP will debounce an input with a debounce period
// entered through configurable parameter. The default is 10 ms
// It expects input clock of 100 MHz which can be changed through
// the configurable parameter. The reset signal input is high level.
/////////////////////////////////////////////////////////////////

module debounce #(parameter DEBOUNCE_TIME=0.01, CLK_INPUT=100)
(
input wire clk,
input wire reset,
input wire i,
output wire o
);

function integer clogb2;
    input [31:0] value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

// ---------------- internal constants --------------
	`define N clogb2((CLK_INPUT*1000000)*DEBOUNCE_TIME) // N value corresponding to 10 ms debounce time
// ---------------- internal variables ---------------
	reg  [`N-1 : 0]	q_reg;				// timing regs
	reg  [`N-1 : 0]	q_next;
	reg DB_out;
	reg DFF1, DFF2;						// input flip-flops
	wire q_add;							// control flags
	wire q_reset;

// counter control
	assign q_reset = (DFF1  ^ DFF2);	// xor input flip flops to look for level chage to reset counter
	assign  q_add = ~(q_reg[`N-1]);		// add to counter when q_reg msb is equal to 0
	assign o = DB_out;
		
// combo counter to manage q_next	
	always @ ( q_reset, q_add, q_reg)
		begin
			case( {q_reset , q_add})
				2'b00 :
						q_next <= q_reg;
				2'b01 :
						q_next <= q_reg + 1;
				default :
						q_next <= { `N {1'b0} };
			endcase 	
		end
	
// Flip flop inputs and q_reg update
	always @ ( posedge clk )
		begin
			if(reset ==  1'b1)
				begin
					DFF1 <= 1'b0;
					DFF2 <= 1'b0;
					q_reg <= { `N {1'b0} };
				end
			else
				begin
					DFF1 <= i;
					DFF2 <= DFF1;
					q_reg <= q_next;
				end
		end
	
// counter control
	always @ ( posedge clk )
		begin
			if(reset ==  1'b1)
            begin
                DB_out <= 1'b0;
            end
        else if(q_reg[`N-1] == 1'b1)
				DB_out <= DFF2;
		else
				DB_out <= DB_out;
		end
endmodule
