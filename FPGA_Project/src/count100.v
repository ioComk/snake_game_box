module COUNT100(
	input wire  en, CLK, CLR, Q, RESET,
	output reg [4-1:0] QL = 4'b0,
	output reg [4-1:0] QH = 4'b0,
	output wire CA
			
);

	always @( posedge CLK ) begin
		if ( CLR == 1 || RESET == 1) begin
			QL <= 4'h0;
			QH <= 4'h0;
		end
		else if ( en && !Q ) begin
			// 下位
			if ( QL == 4'h9 )
				QL <= 4'h0;
			else
				QL <= QL + 4'h1;

			// 上位
			if ( QL == 4'h9 ) begin
				if( QH == 4'h9 )
					QH <= 4'h0;
				else
					QH <= QH + 4'h1;
			end
		end
	end
	
	assign CA = ( QL==4'd9 && QH==4'd9 && en==1 );

endmodule
