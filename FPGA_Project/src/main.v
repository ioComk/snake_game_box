// main program
module snake_game_box (
    input CLK1_50,
	input [9:0] SW,
    output [9:0] LEDR,
	output [9:0] GPIO
);
    wire [25:0] max1 = 26'd6999999;
    wire en1hz;

    wire CLR1 = SW[0];
	 
	 reg clk = 0;
	 reg cnt = 0;

	 reg [8:0] shift = 9'b000000001;
	
    ENCOUNT en1( .max(max1), .clk(CLK1_50), .CLR(CLR1), .en(en1hz) );

	always @(posedge CLK1_50) begin
        if(en1hz==1) begin
				clk <= !clk;
				cnt <= cnt + 1;
				if (cnt % 2 == 0)
					shift <= shift << 1;
		  end

		  if(shift == 9'b000000000)
			   shift <= 9'b000000001;
    end
	 
	assign GPIO[0] = shift[0];

	assign GPIO[4] = !clk;
	assign GPIO[2] = clk;
     
endmodule