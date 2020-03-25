//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------
`include "constants.sv"
import CONSTANTS::*;

module  cursor_tracker ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input logic [7:0] mouse_y, mouse_x, mouse_click,
               output logic [9:0] cursor_location_x, cursor_location_y
              );

    logic [9:0] cursor_location_x_curr,
                cursor_location_y_curr,
                cursor_location_x_in,
                cursor_location_y_in;

    logic [7:0] x_complement, y_complement;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset) begin
          cursor_location_x_curr <= SCREEN_CENTER_X;
          cursor_location_y_curr <= SCREEN_CENTER_Y;
        end
        else begin
          cursor_location_x_curr <= cursor_location_x_in;
          cursor_location_y_curr <= cursor_location_y_in;
        end
    end

    always_comb
    begin
      x_complement = ~mouse_x + 1'b1;
      y_complement = ~mouse_y + 1'b1;

      cursor_location_x_in = cursor_location_x_curr;
      cursor_location_y_in = cursor_location_y_curr;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
          //x and y movements are interpreted as 2s complement
          //with a negative value meaning left and up respectively

          //update cursor location and check boundaries
          unique case (mouse_x[7])
            1'b1:
              if (cursor_location_x_curr - x_complement <= SCREEN_MIN_X + SQUARE_DIM)
                cursor_location_x_in = SCREEN_MIN_X + SQUARE_DIM;
              else if (x_complement > 8'h02)
                cursor_location_x_in = cursor_location_x_curr - (x_complement >> 1);
              else
                cursor_location_x_in = cursor_location_x_curr;
            1'b0:
              if (cursor_location_x_curr + mouse_x >= SCREEN_MAX_X)
                cursor_location_x_in = SCREEN_MAX_X;
              else if (mouse_x > 8'h02)
                cursor_location_x_in = cursor_location_x_curr + (mouse_x >> 1);
              else
                cursor_location_x_in = cursor_location_x_curr;
          endcase

          unique case (mouse_y[7])
            1'b1:
              if (cursor_location_y_curr - y_complement <= SCREEN_MIN_Y + SQUARE_DIM)
                cursor_location_y_in = SCREEN_MIN_Y + SQUARE_DIM;
              else if (y_complement > 8'h02)
                cursor_location_y_in = cursor_location_y_curr - (y_complement >> 1);
              else
                cursor_location_y_in = cursor_location_y_curr;
            1'b0:
              if (cursor_location_y_curr + mouse_y >= SCREEN_MAX_Y)
                cursor_location_y_in = SCREEN_MAX_Y;
              else if (mouse_y > 8'h02)
                cursor_location_y_in = cursor_location_y_curr + (mouse_y >> 1);
              else
                cursor_location_y_in = cursor_location_y_curr;
          endcase
        end
    end

  assign cursor_location_x = cursor_location_x_curr;
  assign cursor_location_y = cursor_location_y_curr;

endmodule
