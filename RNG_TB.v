`timescale 1ns / 1ps

module RNG_TB;
 // Inputs
 reg clk;
 reg rst;
 
 // Outputs
 wire [7:0] rnd;
 
 // Instantiate the Unit Under Test (UUT)
 RNG uut (
  .clk(clk),
  .rst(rst),
  .rnd(rnd)
 );
  
 initial begin
  clk = 0;
  forever
   #50 clk = ~clk;
  end
   
 initial begin
  // Initialize Inputs
   
  rst = 0;
 
  // Wait 100 ns for global reset to finish
  #100;
      rst = 1;
  #200;
  rst = 0;
  // Add stimulus here
 
 end
  
 initial begin
 $display("clk rnd");
 $monitor("%b,%b", clk, rnd);
 end     
endmodule
