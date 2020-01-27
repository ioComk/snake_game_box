module CHREMOVE(
			input wire IN, CLK,
			output reg OUT = 0
);

		wire [18:0] max100hz=19'd479999;
		wire en100hz;
		ENCOUNT en100( .max(max100hz), .clk(CLK1_50), .clr(!CLR), .en(en100hz) );
		
		reg ff1=1, ff2=1;
		always @( posedge CLK )begin
				if (en100hz==1)
					ff1<=IN;
					
				if (en100hz==1)
					ff2<=ff1;
		end 
		
		wire temp = ~ff1 & ff2 & en100hz;
		
		always @(posedge CLK)
				OUT<=temp;
				
endmodule

		
		