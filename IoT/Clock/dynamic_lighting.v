module dynamic_lighting(
	//Clock
	input CLOCK_50,
	input[3:0] dig1_cntr,
	input[3:0] dig2_cntr,
	input[3:0] dig3_cntr,
	input[3:0] dig4_cntr,
	output reg[3:0] select_dig,
	output reg dp_cntr,
	output reg[6:0] seg_cntr
);
	reg[25:0] clock_cntr;
	
	always@(posedge CLOCK_50) begin
		clock_cntr <= #1 clock_cntr + 1;
		case(clock_cntr[11:10])
			0://dig1
			begin
				select_dig <= 4'b1110;
				dp_cntr = 0;
				case (dig1_cntr)
					0 : seg_cntr <= 7'b1111110;
					1 : seg_cntr <= 7'b0110000;
					2 : seg_cntr <= 7'b1101101;
					3 : seg_cntr <= 7'b1111001;
					4 : seg_cntr <= 7'b0110011;
					5 : seg_cntr <= 7'b1011011;
					6 : seg_cntr <= 7'b1011111;
					7 : seg_cntr <= 7'b1110000;
					8 : seg_cntr <= 7'b1111111;
					9 : seg_cntr <= 7'b1111011;
					default : seg_cntr <= 7'b1111111;
				endcase
			end
			1://dig2
			begin
				select_dig = 4'b1101;
				dp_cntr = 0;
				case (dig2_cntr)
					0 : seg_cntr <= 7'b1111110;
					1 : seg_cntr <= 7'b0110000;
					2 : seg_cntr <= 7'b1101101;
					3 : seg_cntr <= 7'b1111001;
					4 : seg_cntr <= 7'b0110011;
					5 : seg_cntr <= 7'b1011011;
					default : seg_cntr <= 7'b1111111;
				 endcase
			end
			2://dig3
			begin
				select_dig = 4'b1011;
				dp_cntr = 1;
				case (dig3_cntr)
					0 : seg_cntr <= 7'b1111110;
					1 : seg_cntr <= 7'b0110000;
					2 : seg_cntr <= 7'b1101101;
					3 : seg_cntr <= 7'b1111001;
					4 : seg_cntr <= 7'b0110011;
					5 : seg_cntr <= 7'b1011011;
					6 : seg_cntr <= 7'b1011111;
					7 : seg_cntr <= 7'b1110000;
					8 : seg_cntr <= 7'b1111111;
					9 : seg_cntr <= 7'b1111011;
					default : seg_cntr <= 7'b1111111;
				endcase
			end
			3://dig4
			begin
				select_dig = 4'b0111;
				dp_cntr = 0;
				case (dig4_cntr)
					0 : seg_cntr <= 7'b1111110;
					1 : seg_cntr <= 7'b0110000;
					2 : seg_cntr <= 7'b1101101;
					3 : seg_cntr <= 7'b1111001;
					4 : seg_cntr <= 7'b0110011;
					5 : seg_cntr <= 7'b1011011;
					6 : seg_cntr <= 7'b1011111;
					7 : seg_cntr <= 7'b1110000;
					8 : seg_cntr <= 7'b1111111;
					9 : seg_cntr <= 7'b1111011;
					default : seg_cntr <= 7'b1111111;
				endcase
			end
		endcase
	end
	
endmodule
