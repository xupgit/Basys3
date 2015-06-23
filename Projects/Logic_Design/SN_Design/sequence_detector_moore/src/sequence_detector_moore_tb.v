`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: sequence_detector_moore_tb
//////////////////////////////////////////////////////////////////////////////////

module sequence_detector_moore_tb(
    );

    reg clk;
    reg reset;
    reg ain;
    wire [3:0] count;
    wire detected;
    parameter PERIOD=20;
    
    sequence_detector_moore_wrapper DUT (.sys_clock(clk), .reset(reset), .ain(ain), .count(count), .detected(detected));

    initial
    begin
        clk = 0;
        forever
        begin
          #(PERIOD/2) clk = 1;
          #(PERIOD/2) clk = 0;
        end
    end
    
    initial
       begin
        reset = 1'b1;
		ain = 1'b0;
		#(2*PERIOD); // wait for 2 clock cycles
        reset = 1'b0;
		#(PERIOD) ain = 1'b0;
		#(PERIOD) ain = 1'b1;
		#(2*PERIOD) ain = 1'b0;
		#(6*PERIOD) ain = 1'b1;
		#(4*PERIOD) ain = 1'b0;
		#(2*PERIOD) ain = 1'b1;
		#(2*PERIOD); 
		#(PERIOD) reset = 1'b1;
		#(PERIOD) reset = 1'b0;
		#(PERIOD) ain = 1'b0;
		#(3*PERIOD) ain = 1'b1;
		#(4*PERIOD);
       end 

endmodule
