`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:57:06 05/30/2016 
// Design Name: 
// Module Name:    clk_gen 
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
module clk_gen(
    input clk,
    input [27:0] counter,
    output reg clk_out
    );

reg [27:0] count_to;

initial
begin
	clk_out <= 0;
	count_to <= 0;
end

always @ (posedge clk)
begin
	if (count_to == counter)
	begin
		clk_out <= ~clk_out;
	end
	else
	begin
		count_to <= count_to + 1'b1;
	end
end

endmodule
