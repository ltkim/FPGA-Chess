/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
 `include "constants.sv"
 import CONSTANTS::*;

module  rom_mouse
(
		input [15:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// memory block for 12 chess pieces, each 60x60 pixels with 24-bit color
logic [23:0] mem [0:3599];

initial
begin
   $readmemh("mouse_cursor.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
