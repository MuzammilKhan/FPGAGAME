`timescale 1ns / 1ps

module Whackamole(
	input clk,
	input rst_button,
//	input inc_button,
	input  [7:0] sw,
   output [7:0] LED,
	output reg [2:0] an,
	output reg [7:0] seg
    );

//////////////////////////////////////////////////////////////////////////////////
//                               Clocks  			                                //
//////////////////////////////////////////////////////////////////////////////////



wire twohundredHz; 
clk_gen twohundredHzgen(.clk(clk), .counter(28'd250000), .clk_out(twohundredHz));

wire tenMHz;
clk_gen tenMhzgen(.clk(clk), .counter(28'd5), .clk_out(tenMhz));

wire oneHz;
clk_gen oneHzgen(.clk(clk), .counter(28'd50000000), .clk_out(oneHz));

wire twoHz;
clk_gen twoHzgen(.clk(clk), .counter(28'd25000000), .clk_out(twoHz));

wire threeHz;
clk_gen threeHzgen(.clk(clk), .counter(28'd16666666), .clk_out(threeHz));

wire fourHz;
clk_gen fourHzgen(.clk(clk), .counter(28'd12500000), .clk_out(fourHz));

wire fiveHz;
clk_gen fiveHzgen(.clk(clk), .counter(28'd10000000), .clk_out(fiveHz));

wire sixHz;
clk_gen sixHzgen(.clk(clk), .counter(28'd8333333), .clk_out(sixHz));

wire sevenHz;
clk_gen sevenHzgen(.clk(clk), .counter(28'd7142857), .clk_out(sevenHz));

reg level_one;
reg level_two;
reg level_three;
reg level_four;
reg level_five;
reg level_six;
reg level_seven;
wire game_clk = (level_one & oneHz) | (level_two & twoHz) | (level_three & threeHz) | 
					 (level_four & fourHz) | (level_five & fiveHz)	| (level_six & sixHz) | (level_seven & sevenHz); //Modify
//////////////////////////////////////////////////////////////////////////////////
//                               Debounce RST                                   //
//////////////////////////////////////////////////////////////////////////////////
wire rst;
PushButton_Debouncer rstDebounce(.clk(tenMhz), .PB(rst_button), .PB_state(rst) /*,.PB_down(), .PB_up()*/);

/*wire inc;
PushButton_Debouncer incDebounce(.clk(tenMhz), .PB(inc_button), .PB_state(inc));
*/


//////////////////////////////////////////////////////////////////////////////////
//                               Switches			                                //
//////////////////////////////////////////////////////////////////////////////////
reg [7:0] toggle;
reg [7:0] prevSwitch;

always @ (posedge game_clk)
begin
prevSwitch [7:0] <= sw [7:0];
end

always @ (*)
begin
toggle[7] <= (prevSwitch[7] == ~sw[7]) ? 1'b1 : 1'b0;
toggle[6] <= (prevSwitch[6] == ~sw[6]) ? 1'b1 : 1'b0;
toggle[5] <= (prevSwitch[5] == ~sw[5]) ? 1'b1 : 1'b0;
toggle[4] <= (prevSwitch[4] == ~sw[4]) ? 1'b1 : 1'b0;
toggle[3] <= (prevSwitch[3] == ~sw[3]) ? 1'b1 : 1'b0;
toggle[2] <= (prevSwitch[2] == ~sw[2]) ? 1'b1 : 1'b0;
toggle[1] <= (prevSwitch[1] == ~sw[1]) ? 1'b1 : 1'b0;
toggle[0] <= (prevSwitch[0] == ~sw[0]) ? 1'b1 : 1'b0;
end


//////////////////////////////////////////////////////////////////////////////////
//                               RNG    			                                //
//////////////////////////////////////////////////////////////////////////////////
lfsr rngLED(.enable(1'b1), .clock(game_clk), .reset(rst), .out(LED[7:0]));

//assign LED[7:0] = 8'b10101010;


//////////////////////////////////////////////////////////////////////////////////
//                               Score				                                //
//////////////////////////////////////////////////////////////////////////////////


/*wire [3:0] score_increment =  toggle[7] & LED[7] + //if switch and toggled and LED is on 1 pt for each such case
										toggle[6] & LED[6] +
										toggle[5] & LED[5] +
										toggle[4] & LED[4] +
										toggle[3] & LED[3] +
										toggle[2] & LED[2] +
										toggle[1] & LED[1] +
										toggle[0] & LED[0] +
										inc;
*/

reg [3:0] score_increment;  
always @ (posedge twohundredHz)
begin
		/*	score_increment <=	(sw[7] & LED[7]) + //if switch and toggled and LED is on 1 pt for each such case
										(sw[6] & LED[6]) +
										(sw[5] & LED[5]) +
										(sw[4] & LED[4]) +
										(sw[3] & LED[3]) +
										(sw[2] & LED[2]) +
										(sw[1] & LED[1]) +
										(sw[0] & LED[0]);
										
										*/
			  score_increment =  (toggle[7] & LED[7]) + //if switch and toggled and LED is on 1 pt for each such case
										(toggle[6] & LED[6]) +
										(toggle[5] & LED[5]) +
										(toggle[4] & LED[4]) +
										(toggle[3] & LED[3]) +
										(toggle[2] & LED[2]) +
										(toggle[1] & LED[1]) +
										(toggle[0] & LED[0]);
										
end

//reg [7:0] prevScore;
wire [7:0] score;
scoreCounter scoreCount(.clock(game_clk), .rst(rst), /*.prevCount(prevScore),*/ .amt(score_increment), .count(score));
//always @ (posedge game_clk)
//begin
//prevScore <= score;
//end

always @ (posedge clk)
begin
if(score >= 70)
begin
level_one <= 1'b0;
level_two <= 1'b0;
level_three <= 1'b0;
level_four <= 1'b0;
level_five <= 1'b0;
level_six <= 1'b0;
level_seven <= 1'b1;
end
else if(score >= 60)
begin
level_one <= 1'b0;
level_two <= 1'b0;
level_three <= 1'b0;
level_four <= 1'b0;
level_five <= 1'b0;
level_six <= 1'b1;
level_seven <= 1'b0;
end
else if(score >= 50)
begin
level_one <= 1'b0;
level_two <= 1'b0;
level_three <= 1'b0;
level_four <= 1'b0;
level_five <= 1'b1;
level_six <= 1'b0;
level_seven <= 1'b0;
end
else if(score >= 40)
begin
level_one <= 1'b0;
level_two <= 1'b0;
level_three <= 1'b0;
level_four <= 1'b1;
level_five <= 1'b0;
level_six <= 1'b0;
level_seven <= 1'b0;
end
else if(score >= 30)
begin
level_one <= 1'b0;
level_two <= 1'b0;
level_three <= 1'b1;
level_four <= 1'b0;
level_five <= 1'b0;
level_six <= 1'b0;
level_seven <= 1'b0;
end
else if(score >= 20)
begin
level_one <= 1'b0;
level_two <= 1'b1;
level_three <= 1'b0;
level_four <= 1'b0;
level_five <= 1'b0;
level_six <= 1'b0;
level_seven <= 1'b0;
end
else
begin
level_one <= 1'b1;
level_two <= 1'b0;
level_three <= 1'b0;
level_four <= 1'b0;
level_five <= 1'b0;
level_six <= 1'b0;
level_seven <= 1'b0;
end
end
//assign score = 8'd5;

wire [3:0] Hundreds;
wire [3:0] Tens;
wire [3:0] Ones;
BCDconverter BCD( .binary(score), . Hundreds(Hundreds), .Tens(Tens), .Ones(Ones));

/*wire [2:0]an_val;
wire [7:0]seg_val;
wire [1:0] digPos = 2'b1;
display_digit dispDig(.select(digPos), .digit_val(score[3:0]), .src_clk(twohundredHz), .anode(an_val), .segment(seg_val));
always @ (posedge twohundredHz)
begin
an [2:0] <= an_val;
seg [7:0]<= seg_val;
end
*/

//////////////////////////////////////////////////////////////////////////////////
//                               Display 7-Segment                              //
//////////////////////////////////////////////////////////////////////////////////

// Assign the digit_value register with the correct data

reg [3:0] digit_value [0:2];

always @ (posedge clk)
begin
	if(rst)
	begin 
		digit_value[0] <= 4'd0;
		digit_value[1] <= 4'd0;
		digit_value[2] <= 4'd0;
		//digit_value[3] <= 4'd0;
	end
	else
	begin
		digit_value[0] <= Ones;
		digit_value[1] <= Tens;
		digit_value[2] <= Hundreds;
		//digit_value[3] <= 4'd0;
 
	end
end

// Set the digit to display
reg [1:0] digPos;	
always @ (posedge twohundredHz)
begin
		digPos <= digPos + 2'b01;
end

// Set the seven segment display
wire [2:0]an_val;
wire [7:0]seg_val;

display_digit dispDig(.select(digPos), .digit_val(digit_value[digPos])/*, .dp(1'b0)*/, .src_clk(twohundredHz), .anode(an_val), .segment(seg_val));
always @ (posedge twohundredHz)
begin
an [2:0] <= an_val;
seg [7:0]<= seg_val;
end


endmodule
