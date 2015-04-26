`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: uart_rx
//////////////////////////////////////////////////////////////////////////////////


module uart_rx #(parameter DATA_WIDTH = 8)(
    input wire clk,reset,
    input wire rx,s_tick,
    output wire [DATA_WIDTH-1:0]dout,
    output reg rx_done
    );
        
    localparam [1:0]
        idle = 2'b00,
        start = 2'b01,
        data = 2'b10,
        stop = 2'b11;
    
    reg [1:0]state,state_next;
    reg [3:0]s,s_next;
    reg [3:0]n,n_next;    
    reg [DATA_WIDTH-1:0]rx_reg,rx_next;
    reg rx_done_next;
    
    always@(posedge clk)
    if(reset)begin
        state <= 0;
        s <= 0;
        n <= 0;
        rx_reg <= 0;
        rx_done <= 0;
    end
    else begin
        state <= state_next;
        s <= s_next;
        n <= n_next;
        rx_reg <= rx_next;
        rx_done <= rx_done_next;
    end
    
    always@(state or s_tick or rx)begin
        state_next = state;
        s_next = s;
        n_next = n;
        rx_next = rx_reg;
        rx_done_next = rx_done;
        case(state)
            idle:begin
                if(~rx)begin
                    state_next = start;
                    s_next = 0;  
                    rx_done_next = 0;                
                end
            end
            
            start:begin
                if(s_tick)begin
                    s_next = s + 1'b1;
                    if(s == 4'd7)begin
                        state_next = data;
                        s_next = 0;
                        n_next = 0;
                    end
                end
            end
            
            data:begin
                if(s_tick)
                    if(s == 4'd15)begin
                        rx_next = {rx,rx_reg[7:1]};
                        s_next = 0;
                        if(n == DATA_WIDTH-1)
                            state_next = stop;
                        else
                            n_next = n + 1'b1;
                    end
                    else
                        s_next = s + 1;
            end
            
            stop:begin
                if(s_tick)
                    if(s == 15)begin
                        state_next = idle;
                        rx_done_next = 1'b1;
                    end
                    else
                        s_next = s + 1'b1;
            end
        
        endcase
    
    end
    
    assign dout = rx_done ? rx_reg : 8'b0;    
    
endmodule
