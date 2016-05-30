`timescale 1ns / 1ps

module Whackamole(
	input clk,
	input rst,
	input  [7:0] DPSwitch,
   output [7:0] LED,
	output reg [3:0] an,
	output reg [7:0] seg
    );

//////////////////////////////////////////////////////////////////////////////////
//                               Clocks  			                                //
//////////////////////////////////////////////////////////////////////////////////
reg game_clk; //Make one
wire twohundredHz; //Make one

clk_gen twohundredHzgen(.clk(clk), .counter(28'd250000), .clk_out(twohundredHz));
always @ (*)  //Change this to the actual game clock later
begin game_clk <= clk; end 


//////////////////////////////////////////////////////////////////////////////////
//                               Switches			                                //
//////////////////////////////////////////////////////////////////////////////////
reg [7:0] toggle;
reg [7:0] prevSwitch;

always @ (posedge game_clk)
begin
prevSwitch [7:0] <= DPSwitch [7:0];
end

always @ (*)
begin
toggle[7] <= (prevSwitch[7] == ~DPSwitch[7]) ? 1'b1 : 1'b0;
toggle[6] <= (prevSwitch[6] == ~DPSwitch[6]) ? 1'b1 : 1'b0;
toggle[5] <= (prevSwitch[5] == ~DPSwitch[5]) ? 1'b1 : 1'b0;
toggle[4] <= (prevSwitch[4] == ~DPSwitch[4]) ? 1'b1 : 1'b0;
toggle[3] <= (prevSwitch[3] == ~DPSwitch[3]) ? 1'b1 : 1'b0;
toggle[2] <= (prevSwitch[2] == ~DPSwitch[2]) ? 1'b1 : 1'b0;
toggle[1] <= (prevSwitch[1] == ~DPSwitch[1]) ? 1'b1 : 1'b0;
toggle[0] <= (prevSwitch[0] == ~DPSwitch[0]) ? 1'b1 : 1'b0;
end


//////////////////////////////////////////////////////////////////////////////////
//                               RNG    			                                //
//////////////////////////////////////////////////////////////////////////////////
lfsr rngLED(.enable(1'b1), .clk(game_clk), .reset(rst), .out(LED[7:0]));



//////////////////////////////////////////////////////////////////////////////////
//                               Score				                                //
//////////////////////////////////////////////////////////////////////////////////

wire [7:0] score;
wire [3:0] score_increment =  toggle[7] & LED[7] + //if switch and toggled and LED is on 1 pt for each such case
										toggle[6] & LED[6] +
										toggle[5] & LED[5] +
										toggle[4] & LED[4] +
										toggle[3] & LED[3] +
										toggle[2] & LED[2] +
										toggle[1] & LED[1] +
										toggle[0] & LED[0];

scoreCounter scoreCount(.clock(game_clk), .rst(rst), .amt(score_increment), .count(score));

wire [3:0] Hundreds;
wire [3:0] Tens;
wire [3:0] Ones;
BCDconverter BCD( .binary(score), . Hundreds(Hundreds), .Tens(Tens), .Ones(Ones));




//////////////////////////////////////////////////////////////////////////////////
//                               Display 7-Segment                              //
//////////////////////////////////////////////////////////////////////////////////

// Assign the digit_value register with the correct data
reg [3:0] digit_value [0:3];

always @ (posedge clk)
begin
	if(rst)
	begin 
		digit_value[0] <= 4'd0;
		digit_value[1] <= 4'd0;
		digit_value[2] <= 4'd0;
		digit_value[3] <= 4'd0;
	end
	else
	begin
		digit_value[0] <= Ones;
		digit_value[1] <= Tens;
		digit_value[2] <= Hundreds;
		digit_value[3] <= 4'd0;
 
	end
end

// Set the digit to display
reg [1:0] digPos;	
always @ (posedge twohundredHz)
begin
	if ( rst )
	begin
		digPos <= 0;
	end
	else
	begin
		digPos <= digPos + 2'b01;
	end
end

// Set the seven segment display
wire [3:0]an_val;
wire [7:0]seg_val;
display_digit dispDig(.select(digPos), .digit_val(digit_value[digPos]), .dp(1'b0), .src_clk(twohundredHz), .anode(an_val), .segment(seg_val));
always @ (posedge twohundredHz)
begin
an[3] <= 1'b0;
an [2:0] <= an_val;
seg [7:0]<= seg_val;
end

endmodule
