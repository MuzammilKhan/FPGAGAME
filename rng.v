`timescale 1ns / 1ps

module RNG(
    input clk,
    input rst,
    output [7:0] rnd
    );
 
wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3];
 
reg [7:0] random, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts
 
always @ (posedge clk or posedge rst)
begin
 if (rst)
 begin
  random <= 8'hFF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end
 
always @ (*)
begin
 random_next = random; //default state stays the same
 count_next = count;
   
  random_next = {random[6:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;
 
 if (count == 8)
 begin
  //count = 4'b0;
  random_done = random; //assign the random number to output after 8 shifts
 end
  
end
 
 
assign rnd = random_done;
 
endmodule
