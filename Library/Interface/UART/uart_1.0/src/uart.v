`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: uart
// Description: Default baud is 9600 with 100 MHz input clock
/////////////////////////////////////////////////////////////////

module uart #(parameter DVSR = 651,DATA_WIDTH = 8) (
    input wire clk,reset,
    input wire rx,send,
    input wire [DATA_WIDTH-1:0]data_in,
    output wire [DATA_WIDTH-1:0]data_out,
    output wire rx_done,tx_done,
    output wire tx
    );
    
    wire s_tick;
    wire [DATA_WIDTH-1:0]rx_reg;
    
    clk #(.DVSR(DVSR)) CLK_div(
        .clk(clk),
        .reset(reset),
        .tick(s_tick)
    );
    
    uart_rx #(.DATA_WIDTH(DATA_WIDTH)) RX(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .rx(rx),
        .dout(data_out),
        .rx_done(rx_done)
    );
        
    uart_tx #(.DATA_WIDTH(DATA_WIDTH)) TX(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .din(data_in),
        .tx_start(send),
        .tx(tx),
        .tx_done(tx_done)
    );
    
endmodule
