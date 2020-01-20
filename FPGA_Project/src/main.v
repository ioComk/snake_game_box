// main program
module snake_game_box (
    input CLK1_50,
	input [10-1:0] SW,
	inout [1:0] KEY,
	output [15:0] ARDUINO_IO,
	output [10-1:0] LEDR
);	

	/////////////////  Variable  /////////////////////

	wire CLR = SW[9];

	reg clk = 0;
	reg SRCLK = 0;
	reg RCLK = 0;
	reg [6:0] cnt = 0;
	
	// 進行方向
	reg isUp = 1, isDown = 0;
	reg isRight = 0, isLeft = 0;

	// 前の状態を保存
	reg isUp_=0, isDown_=0, isRight_=0, isLeft_=0;

	// シフトレジスタに入力するデータのインデクス
	reg [6:0] outIdx = 0;
	reg [6:0] rowIdx = 0;

	// snake param
	reg signed [6:0] head_r;
	reg signed [6:0] head_c;
	reg signed [6:0] body;
	reg signed [6:0] tail_r;
	reg signed [6:0] tail_c;

	reg [6:0] tmp;

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
		data[6][16:0]  = 17'b00000000000000000;
		data[7][16:0]  = 17'b00000000000000000;
		data[8][16:0]  = 17'b00000000000000000;
		data[9][16:0]  = 17'b00000000000000000;
		data[10][16:0] = 17'b00000000000000000;
		data[11][16:0] = 17'b00000000000000000;
		data[12][16:0] = 17'b00000000000000000;
		data[13][16:0] = 17'b00000000000000000;
		data[14][16:0] = 17'b00000000000000000;
		data[15][16:0] = 17'b00000000000000000;

		head_r = 6;
		head_c = 6;
		body = 4;
		tail_c = 6;
		tail_r = head_r + (body-1);
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

	wire up, down, right, left;
	CHREMOVE u( .IN(KEY[0]), .CLK(CLK1_50), .OUT(up));
	CHREMOVE d( .IN(KEY[1]), .CLK(CLK1_50), .OUT(down));
	CHREMOVE r( .IN(SW[2]), .CLK(CLK1_50), .OUT(right));
	CHREMOVE l( .IN(SW[3]), .CLK(CLK1_50), .OUT(left));

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
		if( SW[0] && !SW[1] && !SW[2] && !SW[3] ) begin
			isUp = 1;
			isDown = 0;
			isRight = 0;
			isLeft = 0;

		end
		else if( !SW[0] && SW[1] && !SW[2] && !SW[3]) begin
			isUp = 0;
			isDown = 1;
			isRight = 0;
			isLeft = 0;
		end
		else if( !SW[0] && !SW[1] && SW[2] && !SW[3] ) begin
			isUp = 0;
			isDown = 0;
			isRight = 1;
			isLeft = 0;
		end
		else if( !SW[0] && !SW[1] && !SW[2] && SW[3]) begin
			isUp = 0;
			isDown = 0;
			isRight = 0;
			isLeft = 1;
		end
		else begin
			isUp = isUp;
			isDown = isDown;
			isRight = isRight;
			isLeft = isLeft;
		end

		if(up) begin
			tmp = head_c;
			head_c = tail_c;
			tail_c = tmp;
		end
		if(down) begin
			tmp = head_c;
			head_c = tail_c;
			tail_c = tmp;
		end
		// isUp
		if(enSg && isUp) begin
			if(head_c < 0) begin
				head_c = 15;
				data[head_r][0] = 0;
				data[head_r+1][0] = 0;
			end
			if(tail_c < 0) begin
				tail_c = 15;
				data[tail_r][0] = 0;
			end

			// if(tail_c == head_c-body+1 || (tail_c-head_c) == 13) begin
			// 	tmp = head_c;
			// 	tail_c = head_c;
			// 	head_c = tmp;
			// end
			// if(head_c > tail_c && head_c <= 12) begin
				// tmp = head_c;
				// tail_c = head_c;
				// head_c = tmp;
			// if((tail_c-head_c) == 13)
			// end

			data[head_r][head_c+1] = 0;
			data[tail_r][tail_c+1] = 0;
			data[head_r+1][head_c+1] = 0;

			data[head_r+1][head_c] = 1;
			data[head_r][head_c] = 1;
			data[tail_r][tail_c] = 1;

			head_c = head_c - 1;
			tail_c = tail_c - 1;
		end

		// isDown
		if(enSg && isDown) begin
			if(head_c > 15) begin
				head_c = 0;
				data[head_r][15] = 0;
				data[head_r+1][15] = 0;
			end
			if(tail_c > 15) begin
				tail_c = 0;
				data[tail_r][15] = 0;
			end
			// if(head_c < tail_c && tail_c >= 3) begin
			// 	tmp = head_c;
			// 	tail_c = head_c;
			// 	head_c = tmp;
			// end
			// if(tail_c == head_c+body-1 || (head_c-tail_c) == 13) begin
			// 	tmp = head_c;
			// 	tail_c = head_c;
			// 	head_c = tmp;
			// end

			data[head_r][head_c-1] = 0;
			data[tail_r][tail_c-1] = 0;
			data[tail_r+1][tail_c-1] = 0;

			data[head_r+1][head_c] = 1;
			data[head_r][head_c] = 1;
			data[tail_r][tail_c] = 1;

			head_c = head_c + 1;
			tail_c = tail_c + 1;
		end

		// right
		if(enSg && isRight) begin
			if(head_r > 15) begin
				head_r = 0;
				data[15][head_c] = 0;
				data[15][head_c+1] = 0;
			end
			if(tail_r > 15) begin
				tail_r = 0;
				data[15][tail_c] = 0;
			end
			// if(head_c < tail_c && tail_c >= 3) begin
			// 	tmp = head_c;
			// 	tail_c = head_c;
			// 	head_c = tmp;
			// end
			// if(tail_c == head_c+body-1 || (head_c-tail_c) == 13) begin
			// 	tmp = head_c;
			// 	tail_c = head_c;
			// 	head_c = tmp;
			// end

			data[head_r-1][head_c] = 0;
			data[tail_r-1][tail_c] = 0;
			// data[tail_r+1][tail_c] = 0;

			// data[head_r+1][head_c] = 1;

			data[head_r][head_c] = 1;
			data[tail_r][tail_c] = 1;

			head_r = head_r + 1;
			tail_r = tail_r + 1;
		end

		//  isRight
//		if(enSg && isRight) begin
//			if(tail <= head_c) begin
//				// data[head_r][tail] = 0;
//				if((head_c-tail) == (body-1)) begin
//					tail = tail+1;
//					if(tail>15) tail=0;
//				end
//				else if((head_c-tail) == -(body-1)) begin
//					tail = tail-1;
//					if(tail<0) tail=15;
//				end
//			end
//			else
//				tail = tail;
			// head_r = head_r + 1;
			// if(head_r >15) head_r = 0;
			// data[head_r] = data[head_r] << 1;
			// data[head_r][0] = data[head_r][16];
			// head_c = head_c + 1;
			// if(head_c>15) head_c = 0;
		// end

		// if(enSg && isRight && !isLeft) begin
			
		// end

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
	assign LEDR[2] = isRight;
	assign LEDR[3] = isLeft;

endmodule 