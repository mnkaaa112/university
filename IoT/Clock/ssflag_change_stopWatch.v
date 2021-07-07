module ssflag_change_stopWatch(
	input CLOCK_50,
	input[1:0] KEY,
	output reg[1:0] ssflag
);
	reg[25:0] clock_cntr;

	always@(posedge CLOCK_50) begin //start_stop
		clock_cntr <= #1 clock_cntr + 1;
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
   end

endmodule
