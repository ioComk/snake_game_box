module SEG7DEC(
    input wire [3:0] DIN0, DIN1, DIN2, DIN3,
	input wire dot, Q, CLK, CLR,
	output reg [12:0] PIN
);

	wire [12:0] seg_order1, seg_order2, seg_order3, seg_order4;

	reg [4:0] ONOFF1 = 5'b11110;
	reg [4:0] ONOFF2 = 5'b11101;
	reg [4:0] ONOFF3 = 5'b11011;
	reg [4:0] ONOFF4 = 5'b10111;

	reg [7:0] seg1 = 8'b11111111;
	reg [7:0] seg2 = 8'b11111111;
	reg [7:0] seg3 = 8'b11111111;
	reg [7:0] seg4 = 8'b11111111;

	assign seg_order1 = { seg1,ONOFF1 };
	always @* begin
		case(DIN0)
			4'h0:        seg1=8'b00111111;
			4'h1:        seg1=8'b00000110;
			4'h2:        seg1=8'b01011011;
			4'h3:        seg1=8'b01001111;
			4'h4:        seg1=8'b01100110;
			4'h5:        seg1=8'b01101101;
			4'h6:        seg1=8'b01111101;
			4'h7:        seg1=8'b00100111;
			4'h8:        seg1=8'b01111111;
			4'h9:        seg1=8'b01101111;
			default:     seg1=8'b00000000;
	    endcase
	end
	 
	assign seg_order2 = { seg2,ONOFF2 };
	always @* begin
		case(DIN1)
			4'h0:        seg2=8'b00111111;
			4'h1:        seg2=8'b00000110;
			4'h2:        seg2=8'b01011011;
			4'h3:        seg2=8'b01001111;
			4'h4:        seg2=8'b01100110;
			4'h5:        seg2=8'b01101101;
			4'h6:        seg2=8'b01111101;
			4'h7:        seg2=8'b00100111;
			4'h8:        seg2=8'b01111111;
			4'h9:        seg2=8'b01101111;
			default:     seg2=8'b00000000;
	    endcase

	end
	 
	assign seg_order3 = { seg3,ONOFF3 };
	always @* begin
		case(DIN2)
			4'h0:        seg3=8'b10111111;
			4'h1:        seg3=8'b10000110;
			4'h2:        seg3=8'b11011011;
			4'h3:        seg3=8'b11001111;
			4'h4:        seg3=8'b11100110;
			4'h5:        seg3=8'b11101101;
			4'h6:        seg3=8'b11111101;
			4'h7:        seg3=8'b10100111;
			4'h8:        seg3=8'b11111111;
			4'h9:        seg3=8'b11101111;
			default:     seg3=8'b10000000;
	    endcase
	end
	 
	assign seg_order4 = { seg4,ONOFF4 };
	always @* begin
		case(DIN3)
			4'h0:        seg4=8'b00111111;
			4'h1:        seg4=8'b00000110;
			4'h2:        seg4=8'b01011011;
			4'h3:        seg4=8'b01001111;
			4'h4:        seg4=8'b01100110;
			4'h5:        seg4=8'b01101101;
			4'h6:        seg4=8'b01111101;
			4'h7:        seg4=8'b00100111;
			4'h8:        seg4=8'b01111111;
			4'h9:        seg4=8'b01101111;
			default:     seg4=8'b00000000;
		    endcase
	end

	reg [3:0] count = 4'b0;

	always @( posedge CLK ) begin
		if ( count == 0 ) begin
			PIN <= seg_order1;
			count <= count + 1;
		end
		else if ( count == 1 ) begin
			PIN <= seg_order2;
			count <= count + 1;
		end
		else if ( count==2 ) begin
			PIN <= seg_order3;
			count <= count + 1;
		end
		else if (count ==3 ) begin
			PIN <= seg_order4;
			count <= 0;
		end
	end
endmodule
