module snake_game_box(
		input CLK1_50,
		input [4:0] SW,
		input start,
		output [4:0] GPIO,
		output [12:0] PIN
);

	wire [3:0]score_h;
	wire [3:0]score_l;
	wire stop;
	reg wCLR = 0;
	reg sgCLR = 0;

	always @( posedge CLK1_50 ) begin
		if(start) begin
			sgCLR = 1;
			wCLR = 1;
		end
		else if (stop) begin
			sgCLR = 0;
		end
	end

	SNAKE_GAME sg( .CLK1_50(CLK1_50), .SW(SW), .GPIO(GPIO), .score_h(score_h), .score_l(score_l), .CLR(sgCLR), .RESET(start) );
	
	WATCH w( .CLK1_50(CLK1_50), .PIN(PIN), .inc_h(score_h), .inc_l(score_l), .CLR(wCLR), .stop(stop), .RESET(start) );

endmodule 