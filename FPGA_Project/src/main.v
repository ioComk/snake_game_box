// main program
module snake_game_box (
    input CLK1_50,
	input [1:0] SW,
	inout [1:0] KEY,
	output [15:0] ARDUINO_IO,
	output [9:0] LEDR
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
	reg [6:0] outIdx = 0;
	reg [6:0] rowIdx = 0;
	reg [6:0] snakePos;

	// 1の部分が表示される
	// 17bit目は画面外に出たとき用
	reg [17-1:0] data[0:16-1];
	reg [17-1:0] ser;
	reg [17-1:0] ser_col = 17'b00000000000000001;
	
	initial begin
		data[0][16:0]  = 17'b00000000000000000;
		data[1][16:0]  = 17'b00100000000000000;
		data[2][16:0]  = 17'b00000000000000000;
		data[3][16:0]  = 17'b00000000000000000;
		data[4][16:0]  = 17'b00000000000000000;
		data[5][16:0]  = 17'b00000000000000000;
		data[6][16:0]  = 17'b00000001110000000;
		data[7][16:0]  = 17'b00000000000000000;
		data[8][16:0]  = 17'b00000000000000000;
		data[9][16:0]  = 17'b00000000000000000;
		data[10][16:0] = 17'b00000000000000000;
		data[11][16:0] = 17'b00000000000000000;
		data[12][16:0] = 17'b00000000000000000;
		data[13][16:0] = 17'b00000000000000000;
		data[14][16:0] = 17'b00000000000000000;
		data[15][16:0] = 17'b00000000000000000;

		snakePos = 6;
	end

	//////////////////////////////////////////////////

 	// シフトレジスタに入力するクロックの周期を決める
	// 50Mhz -> 1ms
    wire [25:0] maxSr = 26'd499;
    wire enSr;
    ENCOUNT en1000( .max(maxSr), .clk(CLK1_50), .clr(!CLR), .en(enSr) );

	// スネークが移動する速さを決めるクロックを作る
	// 50Mhz -> 0.1s
	wire [24-1:0] maxSg = 24'd5000000;
	wire enSg;
	ENCOUNT en10( .max(maxSg), .clk(CLK1_50), .clr(!CLR), .en(enSg) );

	always @( posedge CLK1_50 ) begin
		if( enSr ) begin
  			clk = !clk;				  
			
			if ( cnt <= 1 ) begin
			    RCLK = 1;
				SRCLK = 0;
		  	end
	        else begin
				RCLK = 0;
				SRCLK = clk;
			end
		   	if ( cnt % 2 == 1 ) 
		    	outIdx = outIdx + 1;

			if( cnt > 31 ) begin
				cnt = 0;
				outIdx = 0;
				rowIdx <= rowIdx + 1;
				ser_col = ser_col << 1;
				if (ser_col[16] == 1)
					ser_col[0] <= 1;
	    	end
			if (rowIdx > 15)
				rowIdx <= 0;
				
			cnt = cnt + 1;
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
		if(enSg && isUp && !isDown ) begin
			data[snakePos] = data[snakePos] >> 1;
			data[snakePos][16] = data[snakePos][0];
		end
		// 上方向に進む
		if(enSg && isDown && !isUp ) begin
			data[snakePos] = data[snakePos] << 1;
			data[snakePos][0] = data[snakePos][16];
		end

		ser = data[rowIdx];
	end

	assign ARDUINO_IO[13] = CLR;
	assign ARDUINO_IO[12] = RCLK;
	assign ARDUINO_IO[11] = SRCLK;

	assign ARDUINO_IO[9] = ser[(outIdx-1) % 16];
	assign ARDUINO_IO[10]  = ser_col[(outIdx-1) % 16];

	// 確認用
	assign LEDR[0] = isUp;
	assign LEDR[1] = isDown;

endmodule 