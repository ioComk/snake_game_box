module WATCH(
	input CLK1_50,
	input [3:0]inc_h, 
	input [3:0]inc_l,
	input CLR,
	input RESET,
	output wire [12:0] PIN,
	output wire stop
);

	wire minup, secup;
	wire [3:0] msecL, msecH, secL;
	wire [2:0] secH;
	wire [3:0] msecL2, msecH2, secL2;
	wire [2:0] secH2;
	wire en1sec, en1min;
	
	wire [18:0] max100hz=19'd479999;
	wire en100hz;
	ENCOUNT en1( .max(max100hz), .clk(CLK1_50), .clr(!CLR), .en(en100hz) );
	
	wire [18:0] max10000hz=19'd4799;
	wire en10000hz;
	ENCOUNT en2( .max(max10000hz), .clk(CLK1_50), .clr(!CLR), .en(en10000hz) );

	COUNT100 c100( .en(en100hz), .CLK(CLK1_50), .CLR(!CLR), .QL(msecL), .QH(msecH), .CA(en1sec), .Q(stop), .RESET(RESET) );
	COUNT30   c30( .en(en1sec),  .CLK(CLK1_50), .CLR(!CLR), .QL(secL),  .QH(secH),  .CA(en1min), .Q(stop), .RESET(RESET) );

	counter c2( .DIN0(msecL2), .DIN1(msecH2), .en(en100hz), .point_h(inc_h), .point_l(inc_l), .RESET(RESET) );
	SEG7DEC d0( .DIN0(msecL2), .DIN1(msecH2), .DIN2(secL),  .DIN3(secH),  .CLR(!CLR), .dot(0),  .PIN(PIN), .CLK(en10000hz));

	assign stop = !RESET & en1min;

endmodule 
