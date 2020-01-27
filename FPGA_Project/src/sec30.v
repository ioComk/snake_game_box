module SEC30(
	input wire CLK, CLR, CA,
	output reg Q = 0
	
);
	
	always @( posedge CLK )begin
		if ( CLR == 1 )
			Q <= 0;
		else if ( CA == 1 )
			Q <= 1;
	end

endmodule
