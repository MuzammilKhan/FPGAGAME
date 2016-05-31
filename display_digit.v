`timescale 1ns / 1ps

module display_digit(input [1:0] select,
    input [3:0] digit_val,
    //input dp,
	 input src_clk,
	 //input src_rst,
	 output reg [2:0]anode,
	 output reg [7:0]segment
    );
	
	always @ (posedge src_clk)
	begin
		// anode
		case(select)
			0:	anode <= 3'b110;
			1: anode <= 3'b101;
			default: anode <= 3'b011;
//			2: anode <= 4'b1011;
//			default: anode <= 4'b0111;
		endcase
				
		//cathodes
		case(digit_val)
			0:	segment[6:0] <= 7'b1000000; // DP CG CF CE CD CC CB CA 
			1:	segment <= 7'b1111001;
			2:	segment <= 7'b0100100; 
			3:	segment <= 7'b0110000;
			4:	segment <= 7'b0011001;
			5:	segment <= 7'b0010010; 
			6:	segment <= 7'b0000010; 
			7:	segment <= 7'b1111000; 
			8:	segment <= 7'b0000000;
			default: segment <= 7'b0011000;
		endcase	
		
		// Set decimal point
		//segment[7] <= ~dp;
		segment[7] <= 1'b1;
		
		
	end
endmodule
