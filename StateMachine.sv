module StateMachine (
  input logic Clk,
  input logic Reset,
  input logic START,
  input logic [2:0] startX, startY, endX, endY,
  input logic [7:0][7:0][3:0] board,
  //output logic valid_out
  output logic [7:0][7:0][3:0] board_out,
  output logic turn
  );

  logic valid, check, done_check_valid;
  logic turn_in, LD_turn;
  logic castle_left, castle_right;
  logic [2:0] kingX, kingY;
  logic [7:0][7:0][3:0] board_temp;
  logic LD_castling_1, LD_castling_2, LD_castling_3, LD_castling_4;
  logic castle_white_left_allowed_in, castle_black_left_allowed_in, castle_white_right_allowed_in, castle_black_right_allowed_in;
  logic castle_white_left_allowed, castle_black_left_allowed, castle_white_right_allowed, castle_black_right_allowed;

  flip_flop turn_ff (.*, .Load(LD_turn), .D(turn_in), .Q(turn));

  inv_flip_flop white_qs_ff (.*, .Load(LD_castling_1), .D(castle_white_left_allowed_in), .Q(castle_white_left_allowed));
  inv_flip_flop black_qs_ff (.*, .Load(LD_castling_2), .D(castle_black_left_allowed_in), .Q(castle_black_left_allowed));
  inv_flip_flop white_ks_ff (.*, .Load(LD_castling_3), .D(castle_white_right_allowed_in), .Q(castle_white_right_allowed));
  inv_flip_flop black_ks_ff (.*, .Load(LD_castling_4), .D(castle_black_right_allowed_in), .Q(castle_black_right_allowed));

  always_comb begin
  board_temp = 0;
  kingX = 0;
  kingY = 0;

  for (int y = 0; y <= 3'b111; y++) begin
    for (int x = 0; x <= 3'b111; x++) begin
      if (x == startX && y == startY) begin
        board_temp[x][y] = 4'b0000;
      end else if (x == endX && y == endY) begin
        board_temp[x][y] = board[startX][startY];
        if (board_temp[x][y] == {board[startX][startY][3], 3'b110}) begin
          kingX = x;
          kingY = y;
        end
      end else begin
        board_temp[x][y] = board[x][y];
        if (board_temp[x][y] == {board[startX][startY][3], 3'b110}) begin
          kingX = x;
          kingY = y;
        end
      end
    end
  end
  end

  CheckValidMovement checkValidMovement (.*);
  CheckCheck2 checkCheck (.*, .board(board_temp));

  enum logic [1:0] {
    Halted,
    CheckValid,
    MovePiece
  } State, Next_state;

  always_ff @ (posedge Clk) begin
    if (Reset) begin
      State <= Halted;
    end else begin
      State <= Next_state;
    end
  end

  always_comb begin
    unique case (State)
      Halted: begin
        if (START) begin
          Next_state = CheckValid;
        end else begin
          Next_state = Halted;
        end
      end
      CheckValid: begin
        if (valid && ~check && board[startX][startY][3] == turn) begin
          Next_state = MovePiece;
        end else begin
          Next_state = Halted;
        end
      end
      MovePiece: begin
        Next_state = Halted;
      end
    endcase
  end

  always_comb begin
    board_out = board;
    //valid_out = 0;
    LD_turn = 0;
    turn_in = 0;
    LD_castling_1 = 0;
    LD_castling_2 = 0;
    LD_castling_3 = 0;
    LD_castling_4 = 0;
    castle_black_left_allowed_in = 1;
    castle_white_left_allowed_in = 1;
    castle_black_right_allowed_in = 1;
    castle_white_right_allowed_in = 1;
    case (State)
      Halted: begin

      end
      CheckValid: begin

      end
      MovePiece: begin
        board_out = board_temp;
        if (castle_left) begin
          if (~turn) begin //White left
            board_out[3'b011][3'b111] = ROOK_WHITE;
          end else begin //Black left
            board_out[3'b011][3'b000] = ROOK_BLACK;
          end
        end else if (castle_right) begin
          if (~turn) begin //White left
            board_out[3'b110][3'b111] = ROOK_WHITE;
          end else begin //Black left
            board_out[3'b110][3'b000] = ROOK_BLACK;
          end
        end
        if (board[startX][startY] == KING_WHITE) begin
          LD_castling_1 = 1;
          LD_castling_3 = 1;
          castle_white_left_allowed_in = 0;
          castle_white_right_allowed_in = 0;
        end
        if (board[startX][startY] == ROOK_WHITE && startX == 3'b000) begin
          LD_castling_1 = 1;
          castle_white_left_allowed_in = 0;
        end
        if (board[startX][startY] == ROOK_WHITE && startX == 3'b111) begin
          LD_castling_3 = 1;
          castle_white_right_allowed_in = 0;
        end
        if (board[startX][startY] == KING_BLACK) begin
          LD_castling_2 = 1;
          LD_castling_4 = 1;
          castle_black_left_allowed_in = 0;
          castle_black_right_allowed_in = 0;
        end
        if (board[startX][startY] == KING_WHITE && startX == 3'b000) begin
          LD_castling_2 = 1;
          castle_black_left_allowed_in = 0;
        end
        if (board[startX][startY] == KING_WHITE && startX == 3'b111) begin
          LD_castling_4 = 1;
          castle_black_right_allowed_in = 0;
        end
        if (board_out[endX][endY][2:0] == 3'b001) begin
          unique case (board_out[endX][endY][3])
            1'b1: begin
              if (endY == 3'b111)
                board_out[endX][endY] = QUEEN_BLACK;
            end

            1'b0: begin
              if (endY == 3'b000)
                board_out[endX][endY] = QUEEN_WHITE;
            end
          endcase
        end
        //valid_out = 1'b1;
        turn_in = ~turn;
        LD_turn = 1'b1;
      end
    endcase
  end

endmodule // stateMachine
