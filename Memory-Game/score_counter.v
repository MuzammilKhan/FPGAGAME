`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:19:02 06/02/2016 
// Design Name: 
// Module Name:    score_counter 
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
module scoreCounter(
		input clock,
		input reset,
		//input amt,
		output reg [7:0] count
    );

always @ (posedge clock or posedge reset)
begin
		// Reset the counter
		if (reset)
		begin
			count <= 8'b0;
		end
		// Count up by amt
		else
		begin
			count <= (count + 1'b1);
		end
end
endmodule
