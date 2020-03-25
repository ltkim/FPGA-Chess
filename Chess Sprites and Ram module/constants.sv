`ifndef _CONSTANTS_SV
`define _CONSTANTS_SV

//constants for use by rom file
//constants for use by various modules

package CONSTANTS;

parameter PAWN_BLACK_ROM = 0;
parameter PAWN_WHITE_ROM = 3600;
parameter KNIGHT_BLACK_ROM = 7200;
parameter KNIGHT_WHITE_ROM = 10800;
parameter BISHOP_BLACK_ROM = 14400;
parameter BISHOP_WHITE_ROM = 18000;
parameter ROOK_BLACK_ROM = 21600;
parameter ROOK_WHITE_ROM = 25200;
parameter QUEEN_BLACK_ROM = 28800;
parameter QUEEN_WHITE_ROM = 32400;
parameter KING_BLACK_ROM = 36000;
parameter KING_WHITE_ROM = 39600;
parameter ZERO_ROM = 43200;
parameter ONE_ROM = 46800;
parameter TWO_ROM = 50400;
parameter THREE_ROM = 54000;
parameter FOUR_ROM = 57600;
parameter FIVE_ROM = 61200;
parameter SIX_ROM = 64800;
parameter SEVEN_ROM = 68400;
parameter EIGHT_ROM = 72000;
parameter NINE_ROM = 75600;

parameter EMPTY = 4'b0000;
parameter PAWN_BLACK = 4'b1001;
parameter PAWN_WHITE = 4'b0001;
parameter KNIGHT_BLACK = 4'b1010;
parameter KNIGHT_WHITE = 4'b0010;
parameter BISHOP_BLACK = 4'b1011;
parameter BISHOP_WHITE = 4'b0011;
parameter ROOK_BLACK = 4'b1100;
parameter ROOK_WHITE = 4'b0100;
parameter QUEEN_BLACK = 4'b1101;
parameter QUEEN_WHITE = 4'b0101;
parameter KING_BLACK = 4'b1110;
parameter KING_WHITE = 4'b0110;

parameter SQUARE_DIM = 60;

parameter SCREEN_CENTER_X = 320;
parameter SCREEN_CENTER_Y = 240;
parameter SCREEN_MAX_X = 560;
parameter SCREEN_MIN_X = 80;
parameter SCREEN_MAX_Y = 480;
parameter SCREEN_MIN_Y = 0;
parameter LEFT_CLICK = 8'h01;
parameter RIGHT_CLICK = 8'h02;

parameter FIFTY_MILLION = 50000000;



endpackage
`endif
