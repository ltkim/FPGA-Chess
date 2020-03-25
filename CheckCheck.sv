module CheckCheck (
  input logic [2:0] kingX, kingY,
  input logic [7:0][7:0][3:0] board,
  output logic check
  );

  logic done = 0;
  logic kingColor;
  assign kingColor = board[kingX][kingY][3];
  logic pawn, knight, diagonal, straights;

  always_comb begin
    check = 0;
    done = 0;
    pawn = 0;
    knight = 0;
    diagonal = 0;
    straights = 0;
    //Pawns
    if (!kingColor) begin //White
      if (board[kingX - 3'b001][kingY - 3'b001] == 4'b1001 || board[kingX + 3'b001][kingY - 3'b001] == 4'b1001) begin
        check = 1;
        pawn = 1;
      end
    end else begin //Black
      if (board[kingX - 3'b001][kingY + 3'b001] == 4'b0001 || board[kingX + 3'b001][kingY + 3'b001] == 4'b0001) begin
        check = 1;
        pawn = 1;
      end
    end
    //Knights
    if (board[kingX + 3'b001][kingY + 3'b010] == {~kingColor, 3'b010} || board[kingX + 3'b001][kingY - 3'b010] == {~kingColor, 3'b010} ||
        board[kingX - 3'b001][kingY + 3'b010] == {~kingColor, 3'b010} || board[kingX - 3'b001][kingY - 3'b010] == {~kingColor, 3'b010} ||
        board[kingX + 3'b010][kingY + 3'b001] == {~kingColor, 3'b010} || board[kingX + 3'b010][kingY - 3'b001] == {~kingColor, 3'b010} ||
        board[kingX - 3'b010][kingY + 3'b001] == {~kingColor, 3'b010} || board[kingX - 3'b010][kingY - 3'b001] == {~kingColor, 3'b010}) begin
        check = 1;
        knight = 1;
    end
    //Bishop/Queen
    //Down-Right
    if (kingX > kingY) begin
      done = 0;
      for (int i = 1; i <= 3'b111 - kingX && ~done; i ++) begin
        if (board[kingX + i][kingY + i] != 4'b0000) begin
          if (board[kingX + i][kingY + i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX + i][kingY + i] == {~kingColor, 3'b011} || board[kingX + i][kingY + i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end else begin
      done = 0;
      for (int i = 1; i <= 3'b111 - kingY && ~done; i ++) begin
        if (board[kingX + i][kingY + i] != 4'b0000) begin
          if (board[kingX + i][kingY + i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX + i][kingY + i] == {~kingColor, 3'b011} || board[kingX + i][kingY + i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end
    //Down-Left
    if (kingX < kingY) begin
      done = 0;
      for (int i = 1; i <= kingX && ~done; i ++) begin
        if (board[kingX - i][kingY + i] != 4'b0000) begin
          if (board[kingX - i][kingY + i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX - i][kingY + i] == {~kingColor, 3'b011} || board[kingX - i][kingY + i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end else begin
      done = 0;
      for (int i = 1; i <= kingY && ~done; i ++) begin
        if (board[kingX - i][kingY + i] != 4'b0000) begin
          if (board[kingX - i][kingY + i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX - i][kingY + i] == {~kingColor, 3'b011} || board[kingX - i][kingY + i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end
    //Up-Right
    if (kingX < kingY) begin
      done = 0;
      for (int i = 1; i <= 3'b111 - kingX && ~done; i ++) begin
        if (board[kingX + i][kingY - i] != 4'b0000) begin
          if (board[kingX + i][kingY - i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX + i][kingY - i] == {~kingColor, 3'b011} || board[kingX + i][kingY - i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end else begin
      done = 0;
      for (int i = 1; i <= 3'b111 - kingY && ~done; i ++) begin
        if (board[kingX + i][kingY - i] != 4'b0000) begin
          if (board[kingX + i][kingY - i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX + i][kingY - i] == {~kingColor, 3'b011} || board[kingX + i][kingY - i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end
    //Up-Left
    if (kingX > kingY) begin
      done = 0;
      for (int i = 1; i <= kingX && ~done; i ++) begin
        if (board[kingX - i][kingY - i] != 4'b0000) begin
          if (board[kingX - i][kingY - i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX - i][kingY - i] == {~kingColor, 3'b011} || board[kingX - i][kingY - i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end else begin
      done = 0;
      for (int i = 1; i <= kingY && ~done; i ++) begin
        if (board[kingX - i][kingY - i] != 4'b0000) begin
          if (board[kingX - i][kingY - i][3] == kingColor) begin
            done = 1;
          end else if (board[kingX - i][kingY - i] == {~kingColor, 3'b011} || board[kingX - i][kingY - i] == {~kingColor, 3'b101}) begin
            check = 1;
            diagonal = 1;
          end
        end
      end
    end
    //Rooks
    //Up
    done = 0;
    for (int i = 1; i <= kingY && ~done; i ++) begin
      if (board[kingX][kingY - i] != 4'b0000) begin
        if (board[kingX][kingY - i][3] == kingColor) begin
          done = 1;
        end else if (board[kingX][kingY - i] == {~kingColor, 3'b100} || board[kingX][kingY - i] == {~kingColor, 3'b101}) begin
          check = 1;
          straights = 1;
        end
      end
    end
    //Down
    done = 0;
    for (int i = 1; i <= 3'b111 - kingY && ~done; i ++) begin
      if (board[kingX][kingY + i] != 4'b0000) begin
        if (board[kingX][kingY + i][3] == kingColor) begin
          done = 1;
        end else if (board[kingX][kingY + i] == {~kingColor, 3'b100} || board[kingX][kingY + 1] == {~kingColor, 3'b101}) begin
          check = 1;
          straights = 1;
        end
      end
    end
    //Left
    done = 0;
    for (int i = 1; i <= kingX && ~done; i ++) begin
      if (board[kingX - i][kingY] != 4'b0000) begin
        if (board[kingX - i][kingY][3] == kingColor) begin
          done = 1;
        end else if (board[kingX - i][kingY] == {~kingColor, 3'b100} || board[kingX - i][kingY] == {~kingColor, 3'b101}) begin
          check = 1;
          straights = 1;
        end
      end
    end
    //Right
    done = 0;
    for (int i = 1; i <= 3'b111 - kingX && ~done; i ++) begin
      if (board[kingX + i][kingY] != 4'b0000) begin
        if (board[kingX + i][kingY][3] == kingColor) begin
          done = 1;
        end else if (board[kingX + i][kingY] == {~kingColor, 3'b100} || board[kingX + i][kingY] == {~kingColor, 3'b101}) begin
          check = 1;
          straights = 1;
        end
      end
    end
  end

endmodule // CheckCheck
