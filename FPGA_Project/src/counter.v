module counter(
	input wire en, CLR, RESET,
	input wire [3:0]point_h, 
	input wire [3:0]point_l,
	output reg [3:0] DIN0, DIN1
);

	always @( posedge en ) begin
		if ( CLR == 1 || RESET == 1 ) begin
			DIN0 <= 4'h0;
			DIN1 <= 4'h0;
		end
		else begin
			DIN1 <= point_h;
			DIN0 <= point_l;
		end
	end
endmodule			