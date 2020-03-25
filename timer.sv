module timer (
    input logic Clk, Reset,
    input logic turn,
    output logic [3:0][4:0] timer_status_black,
    output logic [3:0][4:0] timer_status_white,
    output logic [25:0] counter_out
  );
  //keep track of clock cycles which have passed
  logic [25:0] counter;
  logic counter_depleted;
  logic [3:0][4:0][1:0] timer_status;

always_ff @ (posedge Clk) begin
    if (Reset) begin
      counter <= 0;
      timer_status_black <= {4'b0010, 4'b0000, 4'b0000, 4'b0000};
      timer_status_white <= {4'b0010, 4'b0000, 4'b0000, 4'b0000};
    end
    else begin
      counter_depleted <= (counter == 50000000);
      if (counter >= 50000000)
        counter <= 0;
      else begin
        counter <= counter + 1;
        timer_status_black <= timer_status[1];
        timer_status_white <= timer_status[0];
      end
    end
  end

  always_comb begin
    timer_status[1] = timer_status_black;
    timer_status[0] = timer_status_white;
    //detect counter reset
    if (counter >= 50000000 && counter_depleted) begin
      if (timer_status[turn][0]) begin
        timer_status[turn][0]--;
      end
      else if (timer_status[turn][1]) begin
        timer_status[turn][1]--;
        timer_status[turn][0] = 4'b1001;
      end
      else if (timer_status[turn][2]) begin
        timer_status[turn][2]--;
        timer_status[turn][1] = 4'b0101;
        timer_status[turn][0] = 4'b1001;
      end
      else if (timer_status[turn][3]) begin
        timer_status[turn][3]--;
        timer_status[turn][2] = 4'b1001;
        timer_status[turn][1] = 4'b0101;
        timer_status[turn][0] = 4'b1001;
    end
  end
end

assign counter_out = counter;

endmodule
