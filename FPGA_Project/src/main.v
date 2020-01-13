// main program
module snake_game_box (
    input CLK1_50,
	input [1:0] SW,
	inout [1:0] KEY,
	output [15:0] ARDUINO_IO,
	output [5:0] LEDR
);	

	/////////////////  Variable  /////////////////////

	wire CLR = SW[0];

	reg clk = 0;
	reg SRCLK = 0;
	reg RCLK = 0;
	reg [6:0] cnt = 0;
	
	// 進行方向 (今は上下のみ)
	reg isUp = 0, isDown = 1;

	// シフトレジスタに入力するデータのインデクス
	reg [6:0] outIndex = 0;

	// 1の部分が表示される
	// 17bit目は画面外に出たとき用
	reg [17-1:0] ser = 17'b000001110000000;

	//////////////////////////////////////////////////

 	// シフトレジスタに入力するクロックの周期を決める
	// 50Mhz -> 1ms
    wire [16-1:0] maxSr = 16'd50000;
    wire enSr;
    ENCOUNT en1000( .max(maxSr), .clk(CLK1_50), .clr(!CLR), .en(enSr) );

	// スネークが移動する速さを決めるクロックを作る
	// 50Mhz -> 0.1s
	wire [24-1:0] maxSg = 24'd5000000;
	wire enSg;
	ENCOUNT en10( .max(maxSg), .clk(CLK1_50), .clr(!CLR), .en(enSg) );

	always @( posedge CLK1_50 ) begin
		if( enSr ) begin
     		cnt = cnt + 1;
  			clk = !clk;				  
			
			if ( cnt % 36 <= 2 ) begin
			    RCLK = clk;
				SRCLK <= 0;
		  	end
			else if ( cnt % 36 >= 2 ) begin
			   	SRCLK = clk;
				RCLK <= 0;
		   	end
		   	if ( cnt % 2 == 0 ) 
		    	outIndex <= outIndex + 1;

			if( cnt >= 38 ) begin
				cnt <= 0;
				outIndex <= 0;
		   end
		end

		// 進行方向の変更
		if( !KEY[0] && KEY[1] ) begin
			isUp <= 1;
			isDown <= 0;
		end
		else if( KEY[0] && !KEY[1]) begin
			isUp <= 0;
			isDown <= 1;
		end
		else begin
			isUp <= isUp;
			isDown <= isDown;
		end

		// 下方向に進む
		if( enSg && isUp && !isDown ) begin
				ser = ser << 1;
				ser[0] = ser[16];
		end
		// 上方向に進む
		if( enSg && isDown && !isUp ) begin
				ser = ser >> 1;
				ser[16] = ser[0];
		end
    end	 

	assign ARDUINO_IO[13] = ser[outIndex % 16];

 	assign ARDUINO_IO[12] = SRCLK;
 	assign ARDUINO_IO[11] = RCLK;
 
 	assign ARDUINO_IO[10] = CLR;

	// 確認用
	assign LEDR[0] = isUp;
	assign LEDR[1] = isDown;

endmodule 