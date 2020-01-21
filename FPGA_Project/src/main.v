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
	reg [5:0] cnt = 0;
	
	// 進行方向
	reg isUp = 1, isDown = 0;
	reg isRight = 0, isLeft = 0;

	// シフトレジスタに入力するデータのインデクス
	reg [4:0] outIdx = 0;
	reg [4:0] rowIdx = 0;

	reg [9:0] rand1 = 10'b0;
	reg [9:0] rand2 = 10'b0001010001;

	reg isEat = 1;

	// snake param
	reg signed [5:0] head_r;
	reg signed [5:0] head_c;
	reg [4:0] body;
	reg signed [5:0] tail_r;
	reg signed [5:0] tail_c;

	reg signed [5:0] b1_r;
	reg signed [5:0] b1_c;
	reg signed [5:0] b2_r;
	reg signed [5:0] b2_c;
	reg signed [5:0] b3_r;
	reg signed [5:0] b3_c;
	reg signed [5:0] b4_r;
	reg signed [5:0] b4_c;
	reg signed [5:0] b5_r;
	reg signed [5:0] b5_c;
	reg signed [5:0] b6_r;
	reg signed [5:0] b6_c;
	reg signed [5:0] b7_r;
	reg signed [5:0] b7_c;

	reg [4-1:0] rand_r=2;
	reg [4-1:0] rand_c=10;

	// 1の部分が表示される
	// 17bit目は画面外に出たとき用
	reg [17-1:0] data[0:16-1];
	reg [17-1:0] ser;
	reg [17-1:0] ser_col = 17'b00000000000000001;
	
	initial begin
		data[0][16:0]  = 17'b00000000000000000;
		data[1][16:0]  = 17'b00000000000000000;
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

		b1_r= head_r;
		b1_c = head_c;
		b2_r= head_r;
		b2_c = head_c;
		b3_r= head_r;
		b3_c = head_c;
		b4_r= head_r;
		b4_c = head_c;
		b5_r= head_r;
		b5_c = head_c;
		b6_r= head_r;
		b6_r= head_r;
		b7_c = head_c;
		b7_c = head_c;

		body = 2;
		tail_r = 6;
		tail_c = head_r + (body-1);
	end

	//////////////////////////////////////////////////

 	// シフトレジスタに入力するクロックの周期を決める
	// 50Mhz -> 1ms
    wire [9-1:0] maxSr = 9'd499;
    wire enSr;
    ENCOUNT en1000( .max(maxSr), .clk(CLK1_50), .clr(!CLR), .en(enSr) );

	// スネークが移動する速さを決めるクロックを作る
	// 50Mhz -> 0.1s
	wire [24-1:0] maxSg = 24'd5000000;
	wire enSg;
	ENCOUNT en10( .max(maxSg), .clk(CLK1_50), .clr(!CLR), .en(enSg) );

	always @( posedge CLK1_50 ) begin
		if(!SW[9]) begin
			data[0][16:0]  = 17'b0;
			data[1][16:0]  = 17'b0;
			data[2][16:0]  = 17'b0;
			data[3][16:0]  = 17'b0;
			data[4][16:0]  = 17'b0;
			data[5][16:0]  = 17'b0;
			data[6][16:0]  = 17'b0;
			data[7][16:0]  = 17'b0;
			data[8][16:0]  = 17'b0;
			data[9][16:0]  = 17'b0;
			data[10][16:0] = 17'b0;
			data[11][16:0] = 17'b0;
			data[12][16:0] = 17'b0;
			data[13][16:0] = 17'b0;
			data[14][16:0] = 17'b0;
			data[15][16:0] = 17'b0;
			head_r = 6;
			head_c = 6;

			b1_r= head_r;
			b1_c = head_c;
			b2_r= head_r;
			b2_c = head_c;
			b3_r= head_r;
			b3_c = head_c;
			b4_r= head_r;
			b4_c = head_c;
			b5_r= head_r;
			b5_c = head_c;
			b6_r= head_r;
			b6_r= head_r;
			b7_c = head_c;
			b7_c = head_c;

			body = 2;
			tail_r = 6;
			tail_c = head_r + (body-1);

			isEat = 1;
		end
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
			rand1 = rand1 + 2;
			rand2 = rand2 + 1;
		end

		// 進行方向の変更
		if( SW[0] && !SW[1] && !SW[2] && !SW[3] ) begin
			if(!isDown) begin
				isUp = 1;
				isDown = 0;
			end
			isRight = 0;
			isLeft = 0;

		end
		else if( !SW[0] && SW[1] && !SW[2] && !SW[3]) begin
			if(!isUp) begin
				isUp = 0;
				isDown = 1;
			end
			isRight = 0;
			isLeft = 0;
		end
		else if( !SW[0] && !SW[1] && SW[2] && !SW[3] ) begin
			isUp = 0;
			isDown = 0;
			if(!isLeft) begin
				isRight = 1;
				isLeft = 0;
			end
		end
		else if( !SW[0] && !SW[1] && !SW[2] && SW[3]) begin
			isUp = 0;
			isDown = 0;
			if(!isRight) begin
				isRight = 0;
				isLeft = 1;
			end
		end
		else begin
			isUp = isUp;
			isDown = isDown;
			isRight = isRight;
			isLeft = isLeft;
		end

		if((head_r == rand_r) && (head_c == rand_c) && !isEat) begin
			if(body < 8) begin
				body = body + 1;
			end
			isEat = 1;
		end

		if(isEat) begin
			rand_c = head_r%6 + rowIdx%10;
			rand_r = cnt%4 + head_r%5 + rowIdx%8;
			if( rand_r != head_r && 
				rand_r != b1_r && 
				rand_r != b2_r &&
				rand_r != b3_r &&
				rand_r != b4_r &&
				rand_r != b5_r &&
				rand_r != b6_r &&
				rand_r != b7_r &&
				rand_r != tail_r &&
				rand_c != head_c &&
				rand_c != b1_c && 
				rand_c != b2_c &&
				rand_c != b3_c &&
				rand_c != b4_c &&
				rand_c != b5_c &&
				rand_c != b6_c &&
				rand_c != b7_c &&
				rand_c != tail_c
			) begin
				data[rand_r%15][rand_c%15] = 1;
				isEat = 0;
			end
			else 
				isEat = 1;
		end

		if(isEat == 0) begin
		// isUp
		if(enSg && isUp) begin
			if(head_c < 0) begin
				head_c = 15;
				data[head_r][0] = 0;
			end

		end
		// isDown
		if(enSg && isDown) begin
			if(head_c > 15) begin
				head_c = 0;
				data[head_r][15] = 0;
			end
		end
		// right
		if(enSg && isRight) begin
			if(head_r > 15) begin
				head_r = 0;
				data[15][head_c] = 0;
			end
		end
		if(enSg && isLeft) begin
			if(head_r < 0) begin
				head_r = 15;
				data[0][head_c] = 0;
			end
		end

		if(enSg && (isUp || isDown || isRight || isLeft)) begin

			data[head_r][head_c] = 1;
			data[tail_r][tail_c] = 0;

			case (body)
				2:begin
					data[b1_r][b1_c] = 1;
					tail_r = b1_r;
					tail_c = b1_c;
				end 
				3:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					tail_r = b2_r;
					tail_c = b2_c;
				end 
				4:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					data[b3_r][b3_c] = 1;
					tail_r = b3_r;
					tail_c = b3_c;
				end 
				5:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					data[b3_r][b3_c] = 1;
					data[b4_r][b4_c] = 1;
					tail_r = b4_r;
					tail_c = b4_c;
				end 
				6:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					data[b3_r][b3_c] = 1;
					data[b4_r][b4_c] = 1;
					data[b5_r][b5_c] = 1;
					tail_r = b5_r;
					tail_c = b5_c;
				end 
				7:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					data[b3_r][b3_c] = 1;
					data[b4_r][b4_c] = 1;
					data[b5_r][b5_c] = 1;
					data[b6_r][b6_c] = 1;
					tail_r = b6_r;
					tail_c = b6_c;
				end 
				8:begin
					data[b1_r][b1_c] = 1;
					data[b2_r][b2_c] = 1;
					data[b3_r][b3_c] = 1;
					data[b4_r][b4_c] = 1;
					data[b5_r][b5_c] = 1;
					data[b6_r][b6_c] = 1;
					data[b7_r][b7_c] = 1;
					tail_r = b7_r;
					tail_c = b7_c;
				end 
			endcase

			b7_r = b6_r;
			b7_c = b6_c;
			b6_r = b5_r;
			b6_c = b5_c;
			b5_r = b4_r;
			b5_c = b4_c;
			b4_r = b3_r;
			b4_c = b3_c;
			b3_r = b2_r;
			b3_c = b2_c;
			b2_r = b1_r;
			b2_c = b1_c;
			b1_r = head_r;
			b1_c = head_c;
		end

		if (enSg && isUp)
			head_c = head_c - 1;
		if (enSg && isDown)
			head_c = head_c + 1;
		if(enSg && isRight)
			head_r = head_r + 1;
		if(enSg && isLeft)
			head_r = head_r - 1;
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
	assign LEDR[2] = isRight;
	assign LEDR[3] = isLeft;

endmodule 