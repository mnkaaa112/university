module stopWatch(
	input CLOCK_50,
	input[1:0] KEY,
	output LED,
	output [3:0] ssLED,
	output reg[3:0] dig1_cntr,
   output reg[3:0] dig2_cntr, 
   output reg[3:0] dig3_cntr,
   output reg[3:0] dig4_cntr
);
	//initial ssflag == 0???
	reg[25:0] div_cntr;
	wire[1:0] ssflag;
	
	ssflag_change_stopWatch ssflag_change_stopWatch(CLOCK_50, KEY, ssflag);
	always@(posedge CLOCK_50) begin
		//count clock cycle
		if(ssflag == 2) begin
			div_cntr <= div_cntr + 1;
		end
		
		//Count
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
		if(ssflag == 3) begin
			LED <= 0;
		end
		*/
	end
	
	//ssflag checker
	assign LED = ssflag;

endmodule
