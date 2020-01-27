module ENCOUNT (
    input [25:0] max,
    input clk, clr,
    output wire en
);

    reg [25:0] cnt = 26'b0;
    assign en = (cnt == max);

    always @(posedge clk) begin
	     if ( clr == 1 )
			   cnt <= 26'b0;
        else 
			 if ( en ==1 )
            cnt <= 26'b0;
          else
            cnt <= cnt + 26'b1;
    end

endmodule 