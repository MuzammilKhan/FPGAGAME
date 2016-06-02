`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:41:57 05/30/2016 
// Design Name: 
// Module Name:    momory_game 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory_game(
    input clk,
    input rst,
	 input btnTM,
    input [7:0] sw,
	 output debug,
    output reg [7:0] LED,
    output reg [7:0] seg,
    output reg [2:0] an
    );


// Game variables
wire  [27:0] game_speed;  // Time taken to display the lights
reg  [3:0] game_level;   // Level that the user is at
reg  [7:0] gen_level;    // The level that the user will play
reg  inc_score;			 // Increase score if the user is right
reg  [1:0] digPos;		 // Set the digit to display
reg  enter;					 // Set on reset or next level
wire [7:0] score;			 // Set the score
wire [3:0] units;			 // Units digit for the score
wire [3:0] tens;			 // Tens digit for the score
wire [3:0] hnds;			 // Hundreds digit for the score
wire [7:0] rng_val;		 // Hold's the current RNG generated value
wire pulse;					 // Only trigger LEDs once
wire rng_pulse;			 // Only trigger one RNG value
wire clk_speed;          // Clock output
wire deb_clock;			 // Clock for debouncer
wire mux_clock;		 	 // Clock to multiplex

// Debounced buttons
wire rst_db;
wire btnTM_db;


initial 
begin
	game_level <= 4'b0;
	inc_score <= 1'b0;
	digPos <= 2'b0;
	enter <= 1'b1;
	game_level <= 5'b0;
	gen_level <= 8'b0;
end

// Generate game speed
game_speed game_clock_setter(
    .clock(clk),
    .p_score(score),
    .count_value(game_speed)
);


// Generate the random number 
lfsr level_generation( 
.clock(clk),     
.reset(1'b0),   
.out(rng_val)
);

// Generate the level clock
clk_gen generate_clock(
	.clock(clk),
	.reset(enter),
	.counter(game_speed),
   .clk_out(clk_speed)
);

// Generate 200Hz
clk_gen generate_clock_mux(
	.clock(clk),
	.reset(1'b0),
	.counter(28'b0000000000111101000010010000),
   .clk_out(mux_clock)
);

// Generate the pulse value for the game
pulse genLEDs(
    .reset(enter),
    .clock(clk_speed),
    .out(pulse)
    );

// Generate the pulse value for RNG
pulse rngPulse(
	.reset(enter),
	.clock(clk),
	.out(rng_pulse)
	);

// Generate the level clock
clk_gen generate_debck(
	.clock(clk),
	.reset(1'b0),
	.counter(28'b0000000000000000000000001010),
   .clk_out(deb_clock)
);


// Debounced rst
PushButton_Debouncer debRst(
    .clock(deb_clock),
    .PB(rst),
    .PB_state(rst_db)
);

// Debounced btnTM
PushButton_Debouncer debBtnTM(
	.clock(deb_clock),
	.PB(btnTM),
	.PB_state(btnTM_db)
);

// Count the score
scoreCounter sct(
		.clock(inc_score),
		.reset(rst_db),
		.count(score)
);

always @ (posedge clk)
begin
	gen_level <= (rng_pulse) ? rng_val : gen_level;
end

always @ ( posedge clk )//or posedge enter )
begin
	if (pulse)
	begin
		// Set LED values
		LED[0] <= (~rng_pulse) & (gen_level[0]);
		LED[1] <= (~rng_pulse) & (gen_level[1]);
		LED[2] <= (~rng_pulse) & (gen_level[2]);
		LED[3] <= (~rng_pulse) & (gen_level[3]);
		LED[4] <= (~rng_pulse) & (gen_level[4]);
		LED[5] <= (~rng_pulse) & (gen_level[5]);
		LED[6] <= (~rng_pulse) & (gen_level[6]);
		LED[7] <= (~rng_pulse) & (gen_level[7]);
	end
	else
	begin
		LED <= 8'b00000000;
	end
end

always @ (posedge clk)
begin
	if (rst_db)
	begin
		enter <= 1'b1;
		inc_score <= 1'b0;
	end
	else if(btnTM_db)
	begin
		// Move on to next value
		inc_score <= ((gen_level == sw) & (~pulse)) ? 1'b1:1'b0;
		enter <= 1'b1;
	end
	else
	begin
		inc_score <= 1'b0;
		enter <= 1'b0;
		//inc_score <= 4'b0;
	end
end

// Only do the following if the user got the correct score
always @ (posedge inc_score)
begin
	game_level <= game_level + 1'b1;
end


BCDconverter bcd(
	.binary(score),
	.Hundreds(hnds),
	.Tens(tens),
	.Ones(units)
);

// Assign the digit_value register with the correct data
reg [3:0] digit_value [0:2];

always @ (posedge clk)
begin
	if(rst_db)
	begin 
		digit_value[0] <= 4'd0;
		digit_value[1] <= 4'd0;
		digit_value[2] <= 4'd0;
		//digit_value[3] <= 4'd0;
	end
	else
	begin
		digit_value[0] <= units;
		digit_value[1] <= tens;
		digit_value[2] <= hnds;
		//digit_value[3] <= 4'd0;
	end
end

// Set the seven segment display
wire [2:0]an_val;
wire [7:0]seg_val;

always @ (posedge mux_clock)
begin
		digPos <= digPos + 2'b01;
end

// Set segment value
seven_segment dispDig(
	.select(digPos), 
	.dp(1'b0),
	.digit_val(digit_value[digPos]), 
	.src_clk(mux_clock), 
	.anode(an_val), 
	.segment(seg_val)
);

always @ (posedge mux_clock)
begin
	an[2:0] <= an_val;
	seg[7:0] <= seg_val;
end

endmodule
