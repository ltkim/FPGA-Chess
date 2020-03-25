module reg3 (
  input logic Clk, Load,
  input logic [2:0] D,
  output logic [2:0] Q
  );

    always_ff @ (posedge Clk) begin
        if (Load)
          Q <= D;
        else
          Q <= Q;
    end

endmodule
