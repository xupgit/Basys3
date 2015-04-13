`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////
// Module Name: syn_up_down_decade_counter
// Description: A presettable BCD/Decade Up/DOWN Counter with DELAY configuration parameter
// parameters: DELAY
/////////////////////////////////////////////////////////////////

module syn_up_down_decade_counter #(parameter DELAY = 10)(
    input wire cpu,cpd,pl_n,mr,
    input wire p3,p2,p1,p0,
    output wire tcu_n,tcd_n,
    output wire q3,q2,q1,q0
    );
	
    reg [3:0]q_r;
    reg [3:0]count;
    wire En;
    
    assign En = cpu && cpd;
    
    always@(negedge En,posedge mr,negedge pl_n)begin
        if(mr)
            count <= 0;
        else if(!pl_n)
            count <= {p3,p2,p1,p0};
        else begin
            if(!cpu && cpd)begin
                if(count < 9)
                    count <= count + 1;
                else
                    count <= 0;
            end                
            if(!cpd && cpu)begin
                if(count > 1)
                    count <= count - 1;
                else
                    count <= 9;
            end
        end
    end
    
    always@(posedge En,posedge mr,negedge pl_n)begin
        if(mr)
             q_r <= 4'b0;
        else if(!pl_n)
             q_r <= {p3,p2,p1,p0};
        else
             q_r <= count;
    end
	
	assign #DELAY q3 = q_r[3];
	assign #DELAY q2 = q_r[2];
	assign #DELAY q1 = q_r[1];
	assign #DELAY q0 = q_r[0];
    assign #DELAY tcu_n = q_r[0] && q_r[3] && (~cpu);
    assign #DELAY tcd_n = (~q_r[0]) && (~q_r[1]) && (~q_r[2]) && (~q_r[3]) && (~cpd);
		
endmodule
