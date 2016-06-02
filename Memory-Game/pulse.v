`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:07:35 05/30/2016 
// Design Name: 
// Module Name:    pulse 
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
module pulse(
    input clock,
    input reset,
    output reg out
    );

initial begin
	out <= 1'b0;
end


always @ (posedge clock or posedge reset)
begin
	// Reset the out
	if (reset)
	begin
		out <= 1'b1;
	end
	// Kill the signal?
	else
	begin
		out <= 1'b0;
	end
end
endmodule
