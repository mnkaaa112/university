module clock(
	//Clock
	input CLOCK_50,
	//start,stop
	input[1:0] KEY,
	/*
	//set time
 	input[3:0] Switch,
	*/
	
   //Arduino I/Os(for 4digit 7segment LED output)
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
	inout Arduino_IO11, //A	
	
	output LED, //for mode change
	output[1:0] ssLED //ssflag cheker
);
	//for count up dig1~4
	wire[3:0] dig1_cntr;
   wire[3:0] dig2_cntr; 
   wire[3:0] dig3_cntr;
   wire[3:0] dig4_cntr;
	//for Dynamic lighting
	wire[3:0] select_dig;
	wire dp_cntr;
	wire[6:0] seg_cntr;

	//timer(LED = 0)
	//stop watch(LED = 1)
	stopWatch2 stopWatch2(CLOCK_50, KEY, LED, ssLED, dig1_cntr, dig2_cntr, dig3_cntr, dig4_cntr);
	//Dynamic lighting
	dynamic_lighting dynamic_lighting(CLOCK_50, dig1_cntr, dig2_cntr, dig3_cntr, dig4_cntr, seg_cntr, dp_cntr, select_dig);
	
	//assign Arduino_PIN(for Dynamic lighting)
	assign Arduino_IO12 = select_dig[3]; //digit4
   assign Arduino_IO9 = select_dig[2]; //digit3
   assign Arduino_IO8 = select_dig[1]; //digit2
   assign Arduino_IO6 = select_dig[0]; //digit1
	assign Arduino_IO3 = dp_cntr; //DP
   assign Arduino_IO5 = seg_cntr[0]; //G
   assign Arduino_IO10 = seg_cntr[1]; //F
   assign Arduino_IO1 = seg_cntr[2]; //E
   assign Arduino_IO2 = seg_cntr[3]; //D
   assign Arduino_IO4 = seg_cntr[4]; //C
   assign Arduino_IO7 = seg_cntr[5]; //B
   assign Arduino_IO11 = seg_cntr[6]; //A

endmodule
