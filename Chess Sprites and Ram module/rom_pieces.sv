/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
 `include "constants.sv"
 import CONSTANTS::*;

module  rom_pieces
(
		input [16:0] read_address,
		input Clk,

		output logic [23:0] data_Out
);

// memory block for 12 chess pieces, each 60x60 pixels with 24-bit color
logic [23:0] mem [0:79199];

initial
begin
	 $readmemh("pawn_black.txt", mem, PAWN_BLACK_ROM);
	 $readmemh("pawn_white.txt", mem, PAWN_WHITE_ROM);
	 $readmemh("knight_black.txt", mem, KNIGHT_BLACK_ROM);
	 $readmemh("knight_white.txt", mem, KNIGHT_WHITE_ROM);
	 $readmemh("bishop_black.txt", mem, BISHOP_BLACK_ROM);
	 $readmemh("bishop_white.txt", mem, BISHOP_WHITE_ROM);
	 $readmemh("rook_black.txt", mem, ROOK_BLACK_ROM);
	 $readmemh("rook_white.txt", mem, ROOK_WHITE_ROM);
	 $readmemh("queen_black.txt", mem, QUEEN_BLACK_ROM);
	 $readmemh("queen_white.txt", mem, QUEEN_WHITE_ROM);
	 $readmemh("king_black.txt", mem, KING_BLACK_ROM);
	 $readmemh("king_white.txt", mem, KING_WHITE_ROM);

   $readmemh("zero.txt", mem, ZERO_ROM);
	 $readmemh("one.txt", mem, ONE_ROM);
	 $readmemh("two.txt", mem, TWO_ROM);
	 $readmemh("three.txt", mem, THREE_ROM);
	 $readmemh("four.txt", mem, FOUR_ROM);
	 $readmemh("five.txt", mem, FIVE_ROM);
	 $readmemh("six.txt", mem, SIX_ROM);
	 $readmemh("seven.txt", mem, SEVEN_ROM);
	 $readmemh("eight.txt", mem, EIGHT_ROM);
   $readmemh("nine.txt", mem, NINE_ROM);

end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
