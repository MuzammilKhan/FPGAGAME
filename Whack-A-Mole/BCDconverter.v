`timescale 1ns / 1ps

module BCDconverter(
	input [7:0] binary,
	output reg [3:0] Hundreds,
	output reg [3:0] Tens,
	output reg [3:0] Ones
    );

reg [19:0] a;
integer i;
always @ (binary)
begin
a[19:8] = 0;
a[7:0] = binary;

for(i=0; i<8; i = i+1)
begin
if(a[19:16] >= 5)
	a[19:16] = a[19:16] + 3;
	
if(a[15:12] >= 5)
	a[15:12] = a[15:12] + 3;
	
if(a[11:8] >=5)
	a[11:8] = a[11:8] + 3;
	
a = a << 1;
end

Hundreds = a[19:16];
Tens = a[15:12];
Ones = a[11:8];
end
endmodule
