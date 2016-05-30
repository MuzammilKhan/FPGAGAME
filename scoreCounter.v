`timescale 1ns / 1ps

module scoreCounter(
		input clock,
		input rst,
		input [3:0] amt,
		output reg [7:0] count
    );

always @ (posedge clock or posedge rst)
begin
	if(~rst)
	begin
		count <= count + amt;
	end
	else
	begin
		count <= 8'b00000000;
	end

end
endmodule
