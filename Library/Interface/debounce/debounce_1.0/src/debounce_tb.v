`timescale 1ns / 1ps
// Define Module for Test Fixture
module DeBounce_tb();
// Inputs
    reg clk;
    reg reset;
    reg button_in;

// Outputs
    wire DB_out;
    
    parameter PERIOD = 10;

// Instantiate the DUT
// Please check and add your parameters manually
    debounce #(
    .DEBOUNCE_TIME(10), 
    .CLK_INPUT(100))
    DUT (
        .clk(clk), 
        .clr(reset), 
        .i(button_in), 
        .o(DB_out)
        );

// Initialize Inputs
    initial begin
			$display ($time, " << Starting the Simulation >> ");
            clk = 1'b0;
            reset = 1'b1;
			#(PERIOD*4) reset = 1'b0;      // release the reset after 2 clock cycles
            button_in = 1'b0;
    end

	always 
			#(PERIOD/2) clk = ~clk;    // every ten nanoseconds invert the clock

	initial 
		begin
			#(PERIOD*20000) button_in = 1'b1;
			
			#(PERIOD*4000) button_in = 1'b0;		
			
			#(PERIOD*8000) button_in = 1'b1;	
			
			#(PERIOD*8000) button_in = 1'b0;				
			
			#(PERIOD*40000) button_in = 1'b1;

			#(PERIOD*1001000) button_in = 1'b0; // 10 ms delay
			
			#(PERIOD*4000) button_in = 1'b1;		
			
			#(PERIOD*40000) button_in = 1'b0;

		end





endmodule // DeBounce_tf