//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

//Adapted and modified extensively by Louis Kim and Raj Lulla for ECE 385 Final Project


`include "constants.sv"
import CONSTANTS::*;

module chess_toplevel ( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
             // VGA Interface
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );

    logic Reset_h, Clk;
    logic [7:0] mouse_y;
    logic [7:0] mouse_click;
    logic [7:0] mouse_x;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low

        if (Reset_h) begin
          board <= { {ROOK_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, ROOK_BLACK},
                           {KNIGHT_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, KNIGHT_BLACK},
                           {BISHOP_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, BISHOP_BLACK},
                           {KING_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, KING_BLACK},
                           {QUEEN_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, QUEEN_BLACK},
                           {BISHOP_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, BISHOP_BLACK},
                           {KNIGHT_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, KNIGHT_BLACK},
                           {ROOK_WHITE, PAWN_WHITE, EMPTY, EMPTY, EMPTY, EMPTY, PAWN_BLACK, ROOK_BLACK}
          };
        end
        else
          board <= board_out;
    end

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),
                            .OTG_ADDR(OTG_ADDR),
                            .OTG_RD_N(OTG_RD_N),
                            .OTG_WR_N(OTG_WR_N),
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );

     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     chess nios2 (
                             .clk_clk(Clk),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR),
                             .sdram_wire_ba(DRAM_BA),
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),
                             .sdram_wire_cs_n(DRAM_CS_N),
                             .sdram_wire_dq(DRAM_DQ),
                             .sdram_wire_dqm(DRAM_DQM),
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N),
                             .sdram_clk_clk(DRAM_CLK),
                             .mouse0_export(mouse_y),
                             .mouse1_export(mouse_click),
                             .mouse2_export(mouse_x),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );

    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    logic valid_out;

    logic LD_START, LD_END, LD_HIGHLIGHT, start_set, end_set, highlight_flag, highlight_data;
    logic [9:0] DrawX, DrawY, cursor_location_x, cursor_location_y;
    logic START, turn;
    //x-y location of mouse cursor
    logic [2:0] cursor_squareX, cursor_squareY;

    logic [25:0] counter_out;

    logic [3:0][4:0] timer_status_black, timer_status_white;

    logic [7:0][7:0][3:0] board, board_out;

  logic [2:0] startX, startY, endX, endY, startX_in, startY_in, endX_in, endY_in;

    flip_flop highlight (.*, .Load(LD_HIGHLIGHT), .Q(highlight_flag), .D(highlight_data), .Reset(Reset_h));

    reg3 start_x (.*, .Load(LD_START), .Q(startX), .D(startX_in));
    reg3 start_y (.*, .Load(LD_START), .Q(startY), .D(startY_in));
    reg3 end_x (.*, .Load(LD_END), .Q(endX), .D(endX_in));
    reg3 end_y (.*, .Load(LD_END), .Q(endY), .D(endY_in));

    always_comb begin
      LD_START = 0;
      LD_END = 0;
      START = 0;
      LD_HIGHLIGHT = 0;
      highlight_data = 1'b0;
      startX_in = startX;
      startY_in = startY;
      endX_in = endX;
      endY_in = endY;

      if (turn && (counter_out[9:0] == 10'b0000000000) && mouse_click == MIDDLE_CLICK) begin
        startX_in = counter_out[12:10];
        startY_in = counter_out[15:13];
        endX_in = counter_out[18:16];
        endY_in = counter_out[21:19];
        LD_START = 1'b1;
        LD_END = 1'b1;
        START = 1'b1;
      end

      else if (mouse_click == LEFT_CLICK) begin
          startX_in = cursor_squareX;
          startY_in = cursor_squareY;
          LD_START = 1'b1;
          highlight_data = 1'b1;
          LD_HIGHLIGHT = 1'b1;
      end
      else if (mouse_click == RIGHT_CLICK) begin
          endX_in = cursor_squareX;
          endY_in = cursor_squareY;
          highlight_data = 1'b0;
          LD_HIGHLIGHT = 1'b1;
          LD_END = 1'b1;
          START = 1'b1;
      end
    end

    StateMachine StateMachine (.*, .Reset(Reset_h));

    // TODO: Fill in the connections for the rest of the modules
    VGA_controller vga_controller_instance(.*, .Reset(Reset_h));

    //update cursor location
    cursor_tracker cursor_tracker(.*, .frame_clk(~VGA_VS), .Reset(Reset_h));

    //perform all drawing on VGA
    color_mapper color_instance(.*);

    timer timer(.*, .Reset(Reset_h));

    // Display mouse info on hex display (for debugging)
    HexDriver hex_inst_0 (counter_out[25:22], HEX0);
    HexDriver hex_inst_1 (counter_out[21:18], HEX1);
    HexDriver hex_inst_2 (counter_out[17:14], HEX2);
    HexDriver hex_inst_3 (mouse_click[7:4], HEX3);
    HexDriver hex_inst_4 (cursor_location_y[5:2], HEX4);
    HexDriver hex_inst_5 (cursor_location_y[9:6], HEX5);

endmodule
