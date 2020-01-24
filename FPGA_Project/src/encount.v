module ENCOUNT (
    input [25:0] max,
    input clk, CLR,
    output en
);

    reg [25:0] cnt = 26'b0;
    assign en = (cnt==max);

    always @(posedge clk) begin
	     if (CLR==1)
			   cnt <= 26'b0;
        else 
			 if (en==1)
            cnt <= 26'b0;
          else
            cnt <= cnt + 26'b1;
    end

endmodule 