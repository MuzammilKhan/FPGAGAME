`timescale 1ns / 1ps


module lfsr(
clock,   // clock input
reset,   // reset input
out      // Output of the counter
);

output [7:0] out;
input clock, reset;
reg [7:0] out;
wire linear_feedback;

initial
begin
	out <= 8'b0;
end

assign linear_feedback = ~(out[7] ^ out[3] ^ out[2]);

always @(posedge clock)
begin
	if (reset) 
	begin 
		out <= 8'b0 ;
	end 
	else
	begin
		out <= {out[6],out[5],
				out[4],out[3],
				out[2],out[1],
				out[0], linear_feedback};
	end
end 

endmodule