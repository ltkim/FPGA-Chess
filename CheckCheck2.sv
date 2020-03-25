module CheckCheck2 (
  input logic [2:0] kingX, kingY,
  input logic Clk,
  input logic [7:0][7:0][3:0] board,
  output logic check
  );

  logic [3:0] startX, startY;
  logic [63:0] valid;


  genvar i;
  generate
      for (i = 0; i < 64 ; i++) begin : generate_block_identifier
      CheckValidMovement checkvalidmovement (.*, .startX(i[2:0]), .startY(i[5:3]), .endX(kingX), .endY(kingY), .valid(valid[i]),
      .castle_white_left_allowed(1'b0), .castle_black_left_allowed(1'b0), .castle_white_right_allowed(1'b0), .castle_black_right_allowed(1'b0), .castle_left(), .castle_right());
      end
  endgenerate

  always_comb begin
    check = 0;
    if (valid)
      check = 1;
  end

endmodule
