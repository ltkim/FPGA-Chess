`include "constants.sv"
import CONSTANTS::*;

module CheckValidMovement (
  input logic castle_white_left_allowed, castle_black_left_allowed, castle_white_right_allowed, castle_black_right_allowed,
  input logic [2:0] startX, startY, endX, endY,
  input logic [7:0][7:0][3:0] board,
  output logic valid, castle_left, castle_right
  );

  logic done;
  logic [3:0] piece;
  assign piece = board[startX][startY];

  always_comb begin
    valid = 0;
    done = 0;
    castle_left = 0;
    castle_right = 0;
    case (piece)
      //White Pawn
      PAWN_WHITE: begin
        if (endX == startX && endY == startY - 3'b001 && board[endX][endY] == 4'b0000) begin
          valid = 1;
        end
        if (startY == 3'b110) begin
          if (endX == startX && (endY == startY - 3'b001 || endY == startY - 3'b010) && board[endX][endY] == 4'b0000) begin
            if (endY == startY - 3'b001) begin
              valid = 1;
            end else if (endY == startY - 3'b010 && board[endX][startY - 3'b001] == 4'b0000) begin
              valid = 1;
            end
          end
        end
        if ((endX == startX - 3'b001 || endX == startX + 3'b001) && endY == startY - 3'b001 && board[endX][endY][3]) begin
          if (endX > startX) begin
            if (endX - startX == 3'b001) begin
              valid = 1;
            end
          end else begin
            if (startX - endX == 3'b001) begin
              valid = 1;
            end
          end
        end
      end
      //Black Pawn
      PAWN_BLACK: begin
        if (endX == startX && endY == startY + 3'b001) begin
          valid = 1;
        end
        if (startY == 3'b001) begin
          if (endX == startX && (endY == startY + 3'b001 || endY == startY + 3'b010) && board[endX][endY] == 4'b0000) begin
            if (endY == startY + 3'b001) begin
              valid = 1;
            end else if (endY == startY + 3'b010 && board[endX][startY + 3'b001] == 4'b0000) begin
              valid = 1;
            end
          end
        end
      if ((endX == startX - 3'b001 || endX == startX + 3'b001) && endY == startY + 3'b001 && ~board[endX][endY][3] && board[endX][endY] != EMPTY) begin
          if (endX > startX) begin
            if (endX - startX == 3'b001) begin
              valid = 1;
            end
          end else begin
            if (startX - endX == 3'b001) begin
              valid = 1;
            end
          end
        end
      end
      //Knight
      KNIGHT_WHITE, KNIGHT_BLACK: begin
        if (((endX == startX - 3'b001 && (endY == startY - 3'b010 || endY == startY + 3'b010)) ||
            (endX == startX + 3'b001 && (endY == startY - 3'b010 || endY == startY + 3'b010)) ||
            (endY == startY - 3'b001 && (endX == startX - 3'b010 || endX == startX + 3'b010)) ||
            (endY == startY + 3'b001 && (endX == startX - 3'b010 || endX == startX + 3'b010))) &&
            (((board[endX][endY] ^ piece) & 4'b1000) || board[endX][endY] == 4'b0000))
            begin

            if (endX > startX) begin
              if (endY > startY) begin
                if (endY - startY <= 3'b010 && endX - startX <= 3'b010) begin
                  valid = 1;
                end
              end else begin
                if (startY - endY <= 3'b010 && endX - startX <= 3'b010) begin
                  valid = 1;
                end
              end
            end else begin
              if (endY > startY) begin
                if (endY - startY <= 3'b010 && startX - endX <= 3'b010) begin
                  valid = 1;
                end
              end else begin
                if (startY - endY <= 3'b010 && startX - endX <= 3'b010) begin
                  valid = 1;
                end
              end
            end
        end
      end
      //Bishop
      BISHOP_BLACK, BISHOP_WHITE: begin
      if (((endX - startX) == (endY - startY) || (endX - startX) == (~(endY - startY) + 1)) && (((board[endX][endY] ^ piece) & 4'b1000) || board[endX][endY] == 4'b0000)) begin
          valid = 1;
          //Down-Right
          if (endX > startX && endY > startY) begin
            done = 0;
            for (int i = 3'b000; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX && startY + 1 + i == endY) begin
                done = 1;
              end else if (board[startX + 1 + i][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Down-Left
          if (endX < startX && endY > startY) begin
            done = 0;
            for (int i = 3'b000; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX && startY + 1 + i == endY) begin
                done = 1;
              end else if (board[startX - 1 - i][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up-Right
          if (endX > startX && endY < startY) begin
            done = 0;
            for (int i = 3'b000; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX && startY - 1 - i == endY) begin
                done = 1;
              end else if (board[startX + 1 + i][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up-Left
          if (endX < startX && endY < startY) begin
            done = 0;
            for (int i = 3'b000; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX && startY - 1 - i == endY) begin
                done = 1;
              end else if (board[startX - 1 - i][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end
        end
      end
      //Rook
      ROOK_WHITE, ROOK_BLACK: begin
        if (((endX == startX) || (endY == startY)) && (((board[endX][endY] ^ piece) & 4'b1000) || board[endX][endY] == 4'b0000)) begin
          valid = 1;
          //Right
          if (endX > startX && endY == startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX) begin
                done = 1;
              end else if (board[startX + 1 + i][startY] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Left
          if (endX < startX && endY == startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX) begin
                done = 1;
              end else if (board[startX - 1 - i][startY] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up
          if (endX == startX && endY < startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startY - 1 - i == endY) begin
                done = 1;
              end else if (board[startX][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Down
          if (endX == startX && endY > startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startY + 1 + i == endY) begin
                done = 1;
              end else if (board[startX][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end
        end
      end
      //Queen
      QUEEN_BLACK, QUEEN_WHITE: begin
        if ((((endX == startX) || (endY == startY)) || (endX - startX) == (endY - startY) || (endX - startX) == (~(endY - startY) + 1)) && (((board[endX][endY] ^ piece) & 4'b1000) || board[endX][endY] == 4'b0000)) begin
          valid = 1;
          //Right
          if (endX > startX && endY == startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX) begin
                done = 1;
              end else
              if (board[startX + 1 + i][startY] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Left
          if (endX < startX && endY == startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX) begin
                done = 1;
              end else
              if (board[startX - 1 - i][startY] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up
          if (endX == startX && endY < startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startY - 1 - i == endY) begin
                done = 1;
              end else
              if (board[startX][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Down
          if (endX == startX && endY > startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startY + 1 + i == endY) begin
                done = 1;
              end else
              if (board[startX][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Down-Right
          if (endX > startX && endY > startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX && startY + 1 + i == endY) begin
                done = 1;
              end else
              if (board[startX + 1 + i][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Down-Left
          if (endX < startX && endY > startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX && startY + 1 + i == endY) begin
                done = 1;
              end else
              if (board[startX - 1 - i][startY + 1 + i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up-Right
          if (endX > startX && endY < startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX + 1 + i == endX && startY - 1 - i == endY) begin
                done = 1;
              end else
              if (board[startX + 1 + i][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end else
          //Up-Left
          if (endX < startX && endY < startY) begin
            done = 0;
            for (int i = 0; i < 3'b111 && ~done; i ++) begin
              if (startX - 1 - i == endX && startY - 1 - i == endY) begin
                done = 1;
              end else
              if (board[startX - 1 - i][startY - 1 - i] != 4'b0000) begin
                valid = 0;
              end
            end
          end
        end
      end
      //King
      KING_BLACK, KING_WHITE: begin
        if ((endX - startX == 3'b001 || endX - startX == 3'b000 || endX - startX == 3'b111) &&
            (endY - startY == 3'b001 || endY - startY == 3'b000 || endY - startY == 3'b111) &&
            (((board[endX][endY] ^ piece) & 4'b1000) || board[endX][endY] == 4'b0000)) begin
              if (endX > startX) begin
                if (endY > startY) begin
                  if (endY - startY <= 3'b001 && endX - startX <= 3'b001) begin
                    valid = 1;
                  end
                end else begin
                  if (startY - endY <= 3'b001 && endX - startX <= 3'b001) begin
                    valid = 1;
                  end
                end
              end else begin
                if (endY > startY) begin
                  if (endY - startY <= 3'b001 && startX - endX <= 3'b001) begin
                    valid = 1;
                  end
                end else begin
                  if (startY - endY <= 3'b001 && startX - endX <= 3'b001) begin
                    valid = 1;
                  end
                end
              end
        end

        if (piece == KING_WHITE && castle_white_left_allowed) begin
          if (endX == 3'b001 && endY == 3'b111 && board[3'b001][3'b111] == 4'b000 && board[3'b010][3'b111] == 4'b000 && board[3'b011][3'b111] == 4'b000) begin
            valid = 1;
            castle_left = 1;
          end
        end else if (piece == KING_BLACK && castle_black_left_allowed) begin
          if (endX == 3'b001 && endY == 3'b000 && board[3'b001][3'b000] == 4'b000 && board[3'b010][3'b000] == 4'b000 && board[3'b011][3'b000] == 4'b000) begin
            valid = 1;
            castle_left = 1;
          end
        end else if (piece == KING_WHITE && castle_white_right_allowed) begin
          if (endX == 3'b110 && endY == 3'b111 && board[3'b101][3'b111] == 4'b000 && board[3'b110][3'b111] == 4'b000) begin
            valid = 1;
            castle_right = 1;
          end
        end else if (piece == KING_BLACK && castle_black_right_allowed) begin
          if (endX == 3'b110 && endY == 3'b000 && board[3'b101][3'b000] == 4'b000 && board[3'b110][3'b000] == 4'b000) begin
            valid = 1;
            castle_right = 1;
          end
        end

      end
      default: valid = 0;
    endcase
  end

endmodule // CheckValidMovement
