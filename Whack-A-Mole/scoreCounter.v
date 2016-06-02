`timescale 1ns / 1ps

module scoreCounter(
		input clock,
		input rst,
//		input [7:0] prevCount,
		input [3:0] amt,
		output reg [7:0] count
    );

always @ (posedge clock or posedge rst)
begin
	if(rst)
	begin
		count <= 8'b0;
	end
	else
	begin
		count <= (count + amt);
	end

end
endmodule
