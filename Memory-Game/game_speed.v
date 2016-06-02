`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:52 06/02/2016 
// Design Name: 
// Module Name:    game_speed 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module game_speed(
    input clock,
    input [7:0] p_score,
    output reg [27:0] count_value
    );

always @ (posedge clock)
begin
	count_value <= (
		(p_score < 1 ) ? 28'b1111111111111111111111111111 : // 2.7 Seconds
		(p_score < 2 ) ? 28'b1110110010000010111000000000 : // 2.5 Seconds
		(p_score < 3 ) ? 28'b1101000111001110111100000000 : // 2.2 Seconds
		(p_score < 4 ) ? 28'b1011111010111100001000000000 : // 2.0 Seconds
		(p_score < 5 ) ? 28'b1010001000011111111010000000 : // 1.7 Seconds
		(p_score < 6 ) ? 28'b1000111100001101000110000000 : // 1.5 Seconds
		(p_score < 7 ) ? 28'b0111001001110000111000000000 : // 1.2 Seconds
		(p_score < 8 ) ? 28'b0101111101011110000100000000 : // 1.0 Seconds
		(p_score < 9 ) ? 28'b0100011110000110100011000000 : // 0.75 Seconds
		(p_score < 10) ? 28'b0010111110101111000010000000 : // 0.50 Seconds
							  28'b0001011111010111100001000000); // 0.25 Seconds; Expert mode, boys!
																		
end

endmodule
