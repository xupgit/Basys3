`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: counters
// Description: Models Binary, Gray, and BCD counters
/////////////////////////////////////////////////////////////////

module counters #(parameter COUNT_SIZE = 8)
(
    input wire clk,
    input wire up_dn,
    input wire clr,
    input wire enable,
    output reg [COUNT_SIZE-1:0] bin_count,
    output wire [COUNT_SIZE-1:0] gray_count,
    output wire [COUNT_SIZE-1:0] bcd_count
);
 
reg [COUNT_SIZE-1:0] binary_value = {{COUNT_SIZE{1'b0}}, 1'b1};
reg [COUNT_SIZE-1:0] gray_value = {COUNT_SIZE{1'b0}};

    always @(posedge clk)
        if (clr)
           bin_count <= 0;
        else if (enable)
           if (up_dn)
              bin_count <= bin_count + 1;
           else
              bin_count <= bin_count - 1;

   assign gray_count = gray_value;
   
   always @(posedge clk)
      if (clr) begin
         binary_value <= {{COUNT_SIZE{1'b0}}, 1'b1};
         gray_value <= {COUNT_SIZE{1'b0}};
      end
      else if (enable) begin
         binary_value <= binary_value + 1;
         gray_value <= (binary_value >> 1) ^ binary_value;
      end
   
   reg [15:0] count_i;

   assign bcd_count = count_i[COUNT_SIZE-1:0];
   
   always @(posedge clk) begin
      if (clr) 
         count_i <= 0;
      else begin
        if (COUNT_SIZE < 4) 
            count_i[COUNT_SIZE-1:0] <= count_i[COUNT_SIZE-1:0] + 1;
        else
        begin
         if (count_i[3:0] == 9) begin // 3
            count_i[3:0] <= 0;
                if (count_i[7:4] == 9) begin //2
                   count_i[7:4] <= 0;
                       if (count_i[11:8] == 9) begin 
                          count_i[11:8] <= 0;
                          if (count_i[15:12] == 9) 
                             count_i[15:12] <= 0;
                          else 
                             count_i[15:12] <= count_i[15:12] + 1; 
                       end 
                   else 
                      count_i[11:8] <= count_i[11:8] + 1;
                end
                else 
                   count_i[7:4] <= count_i[7:4] + 1;   
            end
         else 
            count_i[3:0] <= count_i[3:0] + 1;
        end
      end
   end
endmodule // bcd_count

