`timescale 1ns / 1ps

module clk_gen(
    input clk,
    input [27:0] counter,
    output reg clk_out
    );

reg [27:0] count_to;


always @ (posedge clk)
begin
	if (count_to == counter)
	begin
		clk_out <= ~clk_out;
		count_to <= 28'b0;
	end
	else
	begin
		count_to <= count_to + 1'b1;
	end
end

endmodule
