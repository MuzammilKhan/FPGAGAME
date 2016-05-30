`timescale 1ns / 1ps

module Whackamole(
	input clk,
	input rst,
	input  [7:0] DPSwitch,
   output [7:0] LED
    );

reg game_clk;
always @ (*)  //Change this to the actual game clock later
begin game_clk <= clk; end 

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

lfsr rngLED(.enable(1'b1), .clk(game_clk), .reset(rst), .out(LED[7:0]));



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


endmodule
