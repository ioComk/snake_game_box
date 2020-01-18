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
	reg [6:0] outIndex = 0;
	reg [6:0] rowIndex;

	// 1の部分が表示される
	// 17bit目は画面外に出たとき用
	reg [17-1:0] ser = 17'b0101001101101001;
	reg [17-1:0] ser_col = 17'b00000000000000010;

//	always @* begin
//		ser[0][16:0]  = 17'b01000000000011000;
//		ser[1][16:0]  = 17'b00100000000000000;
//		ser[2][16:0]  = 17'b01000000000000000;
//		ser[3][16:0]  = 17'b00001000000000000;
//		ser[4][16:0]  = 17'b00000100000000000;
//		ser[5][16:0]  = 17'b00000010000000000;
//		ser[6][16:0]  = 17'b00000001000000000;
//		ser[7][16:0]  = 17'b00000000100000000;
//		ser[8][16:0]  = 17'b00000000010000000;
//		ser[9][16:0]  = 17'b00000000001000000;
//		ser[10][16:0] = 17'b00000000001000000;
//		ser[11][16:0] = 17'b00000000000100000;
//		ser[12][16:0] = 17'b00000000000010000;
//		ser[13][16:0] = 17'b00000000000001000;
//		ser[14][16:0] = 17'b00000000000000100;
//		ser[15][16:0] = 17'b00000000000000010;
//		ser[16][16:0] = 17'b00000000000000000;
//
//		rowIndex <= 0;
//	end

	//////////////////////////////////////////////////

 	// シフトレジスタに入力するクロックの周期を決める
	// 50Mhz -> 1ms
    wire [25:0] maxSr = 26'd499999;
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
		    	outIndex = outIndex + 1;

			if( cnt > 32 ) begin
				cnt = 0;
		   end
			if (RCLK == 1)
				outIndex <= 0;
				
			cnt = cnt + 1;
		end

		// 進行方向の変更
		if( !KEY[0] && KEY[1] ) begin
			isUp <= 1;
			isDown <= 0;
			rowIndex <= 2;
		end
		else if( KEY[0] && !KEY[1]) begin
			isUp <= 0;
			isDown <= 1;
			rowIndex <= 3;
		end
		else begin
			isUp <= isUp;
			isDown <= isDown;
			// rowIndex <= 0;
		end

//		// 下方向に進む
//		if( enSg && isUp && !isDown ) begin
//				ser_col = ser_col << 1;
//				ser_col[0] = ser_col[16];
//				rowIndex <= rowIndex + 1;
//				if(rowIndex >= 16)
//					rowIndex <= 0;
//		end
//		// 上方向に進む
//		if( enSg && isDown && !isUp ) begin
//				ser_col = ser_col >> 1;
//				ser_col[16] = ser_col[0];
//				rowIndex <= rowIndex + 1;
//				if(rowIndex >= 16)
//					rowIndex <= 0;
//		end
    end	 

	assign ARDUINO_IO[13] = CLR;
	assign ARDUINO_IO[12] = RCLK;
	assign ARDUINO_IO[11] = SRCLK;

	assign ARDUINO_IO[9] = ser[outIndex % 16];
	assign ARDUINO_IO[10]  = ser_col[outIndex % 16];

	// 確認用
	assign LEDR[0] = isUp;
	assign LEDR[1] = isDown;
	

	assign LEDR[9] = SRCLK;
	assign LEDR[8] = RCLK;
	assign LEDR[6] = ser[outIndex % 16];	
	// assign LEDR[5] = ser_col[outIndex % 16];

endmodule 