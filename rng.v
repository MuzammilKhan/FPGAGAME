module lfsr    (

enable          ,  // Enable  for counter
clk             ,  // clock input
reset,              // reset input
out               // Output of the counter
);

//----------Output Ports--------------
output [7:0] out;
//------------Input Ports--------------

input enable, clk, reset;
//------------Internal Variables--------
reg [7:0] out;
wire        linear_feedback;

//-------------Code Starts Here-------
assign linear_feedback = !(out[7] ^ out[3]);

always @(posedge clk)
if (reset) begin // active high reset
  out <= 8'b0 ;
end else if (enable) begin
  out <= {out[6],out[5],
          out[4],out[3],
          out[2],out[1],
          out[0], linear_feedback};
end 

endmodule