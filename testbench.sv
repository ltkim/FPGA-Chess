/*`include "constants.sv"
import CONSTANTS::*;*/

module testbench();

timeunit 1ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic Clk, Reset, turn;
logic [3:0][4:0] timer_status_black;
logic [3:0][4:0] timer_status_white;
logic [24:0] counter;

timer test (.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
//#2 Continue = ~Continue;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
turn = 0;
Reset = 1;
#2 Reset = 0;

end
endmodule
