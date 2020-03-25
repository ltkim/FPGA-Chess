module check_ff (
  input logic Clk, Load,
  input logic D,
  output logic Q
  );

    always_ff @ (posedge Load) begin
        if (Load)
          Q <= D;
        else
          Q <= Q;
    end

endmodule
