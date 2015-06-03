`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: bin2bcd
// Description: Binary to BCD converter. SIZE valid range is 4 to 8.
//////////////////////////////////////////////////////////////////////////////////

module bin2bcd #(parameter SIZE = 8)(
    input wire [SIZE-1:0] a_in,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds
    );
    
    // Internal variable for storing bits
    reg [19:0] temp_shift_reg;
    integer i;
    
    always @(a_in)
    begin
       // Clear previous number and store new number in temp_shift_reg register
       temp_shift_reg[19:8] = 0;
       temp_shift_reg[7:0] = {a_in,{(8-SIZE){1'b0}}};
       
       // Loop input width times
       for (i=0; i<SIZE; i=i+1) begin
          if (temp_shift_reg[11:8] >= 5)
             temp_shift_reg[11:8] = temp_shift_reg[11:8] + 3;
             
          if (temp_shift_reg[15:12] >= 5)
             temp_shift_reg[15:12] = temp_shift_reg[15:12] + 3;
             
          if (temp_shift_reg[19:16] >= 5)
             temp_shift_reg[19:16] = temp_shift_reg[19:16] + 3;
          
          // Shift entire register left once
          temp_shift_reg = temp_shift_reg << 1;
       end
       
       // Push decimal numbers to output
       hundreds = temp_shift_reg[19:16]; // hundreds
       tens = temp_shift_reg[15:12]; // tens
       ones = temp_shift_reg[11:8];  // ones
    end
endmodule
