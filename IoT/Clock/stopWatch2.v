//include ssflag_change_stopWatch module
module stopWatch2(
	input CLOCK_50,
	input[1:0] KEY,
	output LED,
	output [1:0] ssLED,
	output reg[3:0] dig1_cntr,
   output reg[3:0] dig2_cntr, 
   output reg[3:0] dig3_cntr,
   output reg[3:0] dig4_cntr
);
	reg[25:0] clock_cntr;
	reg[25:0] div_cntr;
	reg[1:0] ssflag = 2'b00;
	
	always@(posedge CLOCK_50) begin
		//count clock cycle
		if(ssflag == 2) begin
			div_cntr <= div_cntr + 1;
		end
		clock_cntr <= #1 clock_cntr + 1;
		
		//ssflag check
		case(clock_cntr[11:10])
			0:
			begin
				if(~KEY[0]) begin
					if(ssflag == 0) begin
						ssflag <= 2;
					end
					if(ssflag == 1) begin
						ssflag <= 2;
					end
					if(ssflag == 2) begin
						ssflag <= 1;
					end
				end		
				if(~KEY[1]) begin
					if(ssflag == 1) begin
						ssflag <= 0;
					end 
					if(ssflag == 2) begin
						ssflag <= 3; //modeChange
					end 
				end
			end
		endcase
		
		//count per second
		if(div_cntr == 50000000) begin //per 1 sec
			dig1_cntr <= #1 dig1_cntr + 1;
			div_cntr <= 0; //initialize
			//dig1
         if(dig1_cntr == 9) begin
				dig1_cntr <= 0;
				dig2_cntr <= dig2_cntr + 1;
			end
			//dig2
			if(dig2_cntr == 5 && dig1_cntr == 9) begin
            dig2_cntr <= 0;
            dig3_cntr <= dig3_cntr + 1;
         end
			//dig3
			if(dig3_cntr == 9) begin
				dig3_cntr <= 0;
            dig4_cntr <= dig4_cntr + 1;
			end
		end
		/*
		if(ssflag == 3) begin //module change
			LED <= 0;
		end
		*/
	end
	
	//ssflag checker
	assign ssLED = ssflag;

endmodule
