`timescale 1ns / 1ps

module scoreCounter(
		input clock,
		input rst,
//		input [7:0] prevCount,
		input [3:0] amt,
		output reg [7:0] count
    );


always @ (posedge clock)
begin
//count <= ~rst ? (prevCount + amt) : count <= 8'b00000000;
	//if(rst)
	//begin
		//count <= 8'b0;
	//end
	//else
	//begin
		//count <= (count + amt);
		count <= (count + amt);
	//end

end
endmodule
