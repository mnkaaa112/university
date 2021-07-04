module timer(
    //Clock(50MHz)
    input Clock,
	  //start,stop
	  input[1:0] KEY, //KEY[0]=start,stop KEY[1]=add time
	  //set time
 	  input[3:0] Switch,
    //Arduino I/Os
    inout Arduino_IO6, //Digit4
    inout Arduino_IO8, //Digit3
    inout Arduino_IO9, //Digit2
    inout Arduino_IO12, //Digit1
    
    inout Arduino_IO3, //DP
    inout Arduino_IO5, //G
    inout Arduino_IO10, //F
    inout Arduino_IO1, //E
    inout Arduino_IO2, //D
    inout Arduino_IO4, //C
    inout Arduino_IO7, //B
    inout Arduino_IO11 //A
	
	 //output[1:0] LED
);

	  reg[25:0] div_cntr; //Clock counter
	  reg[25:0] clock_cntr; //Clock counter
    reg [3:0] dig1_cntr; //count up dig1~4
    reg [3:0] dig2_cntr;
    reg [3:0] dig3_cntr;
    reg [3:0] dig4_cntr;
    reg[6:0] seg_cntr; //segment counter
    reg[3:0] select_dig; //select dig1~4
    reg dp_cntr; //dp
	 
	 //reg[3:0] ssflag;
	
	 //timeCount(KEY[1], Switch, dig1_cntr, dig2_cntr, dig3_cntr, dig4_cntr);
	 //countDown(Clock, KEY, ssflag, dig1_cntr, dig2_cntr, dig3_cntr, dig4_cntr);
	 
    initial begin
		  div_cntr = 0;
		  dig1_cntr <= 4'b0010; //count up dig1~4
		  dig2_cntr <= 4'b0101;
		  dig3_cntr <= 4'b0000;
		  dig4_cntr <= 4'b0000;
		  clock_cntr = 0;
        seg_cntr = 0;
		  dp_cntr = 0;
    end    

	 /*
    always@(posedge Clock) begin
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
	 end
	 */
	 
    always@(posedge Clock) begin
		  //count clock cycle
		 // if(ssflag==2) begin
				div_cntr <= div_cntr + 1;
		  //end
		  
		  //mode change
		  /*
		  if(~KEY[1]) begin
				ssflag <= 3;
		  end
		  */
		  
		 //count
        if (div_cntr == 50000000) begin //per 1 sec
            dig1_cntr <= dig1_cntr - 1;
				div_cntr <= 0;
	    
				//dig2
				if (dig2_cntr == 0 && dig1_cntr == 0) begin
                dig2_cntr <= 5;
                //dig3_cntr <= dig3_cntr - 1;
            end
				//dig1
            if (dig1_cntr == 0) begin
                dig1_cntr <= 9;
                dig2_cntr <= dig2_cntr - 1;
            end
				/*
				//dig3
				if (dig3_cntr == 0) begin
					 dig3_cntr <= 0;
                dig4_cntr <= dig4_cntr - 1;
				end
				*/
				
        end
		  
		  case(clock_cntr[11:10])
				0:
		  //dig1
				begin
			  select_dig = 4'b1110;
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
		  //select_dig = 4'b1111;
		  
				1:
        //dig2
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
			  
			  2:
			   //dig3
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
			  
			  3:
			   //dig4
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
    
    assign Arduino_IO12 = select_dig[3]; //digit4
    assign Arduino_IO9 = select_dig[2]; //digit3
    assign Arduino_IO8 = select_dig[1]; //digit2
    assign Arduino_IO6 = select_dig[0]; //digit1
	 
	  assign Arduino_IO3 = dp_cntr; //DP
    assign Arduino_IO5 = seg_cntr[0] ; //G
    assign Arduino_IO10 = seg_cntr[1] ; //F
    assign Arduino_IO1 = seg_cntr[2] ; //E
    assign Arduino_IO2 = seg_cntr[3] ; //D
    assign Arduino_IO4 = seg_cntr[4] ; //C
    assign Arduino_IO7 = seg_cntr[5] ; //B
    assign Arduino_IO11 = seg_cntr[6] ; //A
	 
	 //assign LED = ssflag;
endmodule
