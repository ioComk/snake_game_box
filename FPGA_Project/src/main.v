// main program
module snake_game_box (
    input CLK1_50,
	input [9:0] SW,
    output [9:0] LEDR
);
    wire [25:0] max1 = 26'd49999999;
    wire en1hz;

    wire CLR1 = SW[0];

	reg [9:0] shift = 10'b0000000001;
	
    ENCOUNT en1( .max(max1), .clk(CLK1_50), .CLR(CLR1), .en(en1hz) );

	always @(posedge CLK1_50) begin
        if(en1hz==1)
            shift <= shift << 1;
		  if(shift == 10'b0000000000)
			   shift <= 10'b0000000001;
    end
	 
	assign LEDR[0] = shift[0];
	assign LEDR[1] = shift[1];
	assign LEDR[2] = shift[2];
	assign LEDR[3] = shift[3];
	assign LEDR[4] = shift[4];
	assign LEDR[5] = shift[5];
	assign LEDR[6] = shift[6];
	assign LEDR[7] = shift[7];
	assign LEDR[8] = shift[8];
	assign LEDR[9] = shift[9];
     
endmodule