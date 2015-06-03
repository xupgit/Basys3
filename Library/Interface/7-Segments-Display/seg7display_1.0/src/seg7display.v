`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: seg7display
// Description: 7-segment display module driving either 4 or 8 7-segments module(s) 
// Input clock is 100 MHz, reset is high-level logic, input x is either 4 or 8 nibbles input
// Decimal point is turned OFF
// Segments are refreshed at approximately 50 Hz.
// MODULES=1 will use 4 modules where as MODULES=2 will use 8 modules
/////////////////////////////////////////////////////////////////
//           a
//          ---
//        f|    | b
//         | g  |
//          ---
//        e|    | c
//         |    |
//          ---
//           d
/////////////////////////////////////////////////////////////////

module seg7display#(parameter MODULES=1, 
        DP_0=1, DP_1=1, DP_2=1, DP_3=1, 
        DP_4=1, DP_5=1, DP_6=1, DP_7=1)
(
    input wire [15:0] x_l,
    input wire [15:0] x_h=0,
    input wire clk,
    input wire reset,
    output reg [6:0] a_to_g,
    output wire [3:0] an_l,
    output wire [3:0] an_h,
    output reg dp_l,
    output reg dp_h 
);

wire [2:0] s;     
reg [3:0] digit;
wire [3:0] aen_l;
wire [3:0] aen_h;
wire [7:0] aen;
reg [7:0] an;
reg [20:0] clkdiv;

wire [3:0] dp_l_i;
wire [3:0] dp_h_i;
wire [7:0] dpen;

assign dp_l_i[0] = (DP_0) ? 1'b0 : 1'b1;
assign dp_l_i[1] = (DP_1) ? 1'b0 : 1'b1;
assign dp_l_i[2] = (DP_2) ? 1'b0 : 1'b1;
assign dp_l_i[3] = (DP_3) ? 1'b0 : 1'b1;
assign dp_h_i[0] = (DP_4) ? 1'b0 : 1'b1;
assign dp_h_i[1] = (DP_5) ? 1'b0 : 1'b1;
assign dp_h_i[2] = (DP_6) ? 1'b0 : 1'b1;
assign dp_h_i[3] = (DP_7) ? 1'b0 : 1'b1;
assign s = (MODULES==1) ? {1'b0,clkdiv[19:18]} : clkdiv[20:18];
assign aen_l = 4'b1111; // all turned off initially
assign aen_h = 4'b1111; // all turned off initially
assign aen = (MODULES==1) ? {4'b0000,aen_l} : {aen_h,aen_l};
assign {an_h,an_l}=an;

assign dpen = (MODULES==1) ? {4'b0000,dp_l_i} : {dp_h_i,dp_l_i};

// MUX
always @(posedge clk)
    case(s)
        0:digit = x_l[3:0]; // s is 000 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
        1:digit = x_l[7:4]; // s is 001 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
        2:digit = x_l[11:8]; // s is 010 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
        3:digit = x_l[15:12]; // s is 011 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
        4:digit = x_h[3:0]; // s is 100 -->4 ;  digit gets assigned 4 bit value assigned to x[19:16]
        5:digit = x_h[7:4]; // s is 101 -->5 ;  digit gets assigned 4 bit value assigned to x[23:20]
        6:digit = x_h[11:8]; // s is 110 -->6 ;  digit gets assigned 4 bit value assigned to x[27:24]
        7:digit = x_h[15:12]; // s is 111 -->7 ;  digit gets assigned 4 bit value assigned to x[31:28]
        default:digit = x_l[3:0];
    endcase

//decoder or truth-table for 7a_to_g display values
always @(*)

    case(digit)
        //////////////gfedcba///////////
        0:a_to_g = 7'b1000000;   //0000                                                                    
        1:a_to_g = 7'b1111001;   //0001                                                
        2:a_to_g = 7'b0100100;   //0010                                                
        3:a_to_g = 7'b0110000;   //0011                                             
        4:a_to_g = 7'b0011001;   //0100                                               
        5:a_to_g = 7'b0010010;   //0101                                               
        6:a_to_g = 7'b0000010;   //0110
        7:a_to_g = 7'b1111000;   //0111
        8:a_to_g = 7'b0000000;   //1000
        9:a_to_g = 7'b0010000;   //1001
        'hA:a_to_g = 7'b0001000; //1010
        'hB:a_to_g = 7'b0000011; //1011
        'hC:a_to_g = 7'b1000110; //1100
        'hD:a_to_g = 7'b0100001; //1101
        'hE:a_to_g = 7'b0000110; //1110
        'hF:a_to_g = 7'b0001110; //1111
        default: a_to_g = 7'b0000000; // all segments ON
    endcase

always @(*)begin
    if(MODULES==1)
    begin
        an=8'b00001111;
        if(aen_l[s] == 1)
            an[s] = 0;
    end
    else
    begin
        an=8'b11111111;
        if(aen[s] == 1)
            an[s] = 0;
    end       
end

always @(*)begin
    if(MODULES==1)
    begin
        if(aen_l[s] == 1)
            dp_l = dpen[s];
    end
    else
    begin
        if(aen[s] == 1) begin
            if(s<4) 
                dp_l = dpen[s];
            else
                dp_h = dpen[s];
        end
    end       
end

//clkdiv
always @(posedge clk) begin
    if ( reset == 1)
        clkdiv <= 0;
    else
        clkdiv <= clkdiv+1;
end

endmodule

