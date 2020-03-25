module flip_flop (
  input logic Clk, Load, Reset,
  input logic D,
  output logic Q
  );

    always_ff @ (posedge Clk) begin
        if (Load)
          Q <= D;
        else if (Reset)
          Q <= 0;
        else
          Q <= Q;
    end

endmodule

module inv_flip_flop (
  input logic Clk, Load, Reset,
  input logic D,
  output logic Q
  );

    always_ff @ (posedge Clk) begin
        if (Load)
          Q <= D;
        else if (Reset)
          Q <= 1;
        else
          Q <= Q;
    end

endmodule
