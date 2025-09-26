//----------------------------------------//
// Filename     : Rotary_Encoder.v
// Description  : Rotary Encoder Module for DDSFG
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 15.07.2025
// Author       : Adisorn Sommart
// Remark       : 
//----------------------------------------//
module Rotary_Encoder (
    input  wire        Fg_CLK,
    input  wire        Ext_RESETn,
    input  wire        Rot_A,
    input  wire        Rot_B,
    input  wire        Rot_C,
    input  wire [ 2:0] Mode,
    output wire [10:0] Address,
    output wire        FreqChange

);

  //----------------------------------------//
  // Parameter Declaration
  //----------------------------------------//

  //`define SIM // Uncomment if Simulate
`ifdef SIM
  localparam Onehundred_ms = 22'd240 - 1;
  localparam Debounce_A_B = 14'd12 - 1;
  localparam Debounce_State = 14'd24 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;  // 100 ms
  localparam Debounce_A_B = 14'd12000 - 1;  // 0.5 ms
  localparam Debounce_State = 14'd2400 - 1;  // 0.1ms 
`endif

  localparam State_Idle = 3'd0;
  localparam State_CW = 3'd1;
  localparam State_CCW = 3'd2;
  localparam State_Debounce = 3'd3;
  localparam State_Waitsteady = 3'd4;

  localparam Step_Min = 11'd0;
  localparam Step_Min_Mode4 = 11'd800;
  localparam Step_Max = 11'd1800;

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg [ 2:0] rFlop_Rot_A;
  reg [ 2:0] rFlop_Rot_B;
  reg        A_Fall;
  reg        B_Fall;
  reg        Steady_A;
  reg        Steady_B;
  reg [21:0] rCnt_Delay;
  reg        rDelay;
  reg [10:0] rCnt_Rot;
  reg [ 1:0] rMode_step;
  reg [10:0] rStep;
  reg [ 3:0] State;
  reg [10:0] rAddress;
  reg        rFreqChange;
  reg [13:0] rCnt_Debounce_A;
  reg [13:0] rCnt_Debounce_B;
  reg [13:0] rCnt_Debounce_State;

  assign Address   = rAddress; 
  assign FreqChange  = rFreqChange;

  // Sync Rot_A with 2-flop
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rFlop_Rot_A
    if (!Ext_RESETn) begin
      rFlop_Rot_A <= 3'b111;
    end else begin
      rFlop_Rot_A <= {rFlop_Rot_A[1], rFlop_Rot_A[0], Rot_A};
    end
  end

  // Sync Rot_B with 2-flop
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rFlop_Rot_B
    if (!Ext_RESETn) begin
      rFlop_Rot_B <= 3'b111;
    end else begin
      rFlop_Rot_B <= {rFlop_Rot_B[1], rFlop_Rot_B[0], Rot_B};
    end
  end

  //debounce button A
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rCnt_Debounce_A
    if (!Ext_RESETn) begin
      rCnt_Debounce_A <= 14'd0;
    end else begin
      if (rCnt_Debounce_A == Debounce_A_B && A_Fall) begin
        rCnt_Debounce_A <= 14'd0;
      end else begin
        rCnt_Debounce_A <= (rCnt_Debounce_A < Debounce_A_B) ? rCnt_Debounce_A + 14'd1 : rCnt_Debounce_A;
      end
    end
  end

  //debounce button B
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rCnt_Debounce_B
    if (!Ext_RESETn) begin
      rCnt_Debounce_B <= 14'd0;
    end else begin
      if (rCnt_Debounce_B == Debounce_A_B && B_Fall) begin
        rCnt_Debounce_B <= 14'd0;
      end else begin
        rCnt_Debounce_B <= (rCnt_Debounce_B < Debounce_A_B) ? rCnt_Debounce_B + 14'd1 : rCnt_Debounce_B;
      end
    end
  end

  // Combination 
  always @(*) begin
    // Check negedge of Button
    A_Fall   <= (rFlop_Rot_A[2] == 1'b1 && rFlop_Rot_A[1] == 1'b0 && rCnt_Debounce_A == Debounce_A_B) ? 1'b1 : 1'b0;
    B_Fall   <= (rFlop_Rot_B[2] == 1'b1 && rFlop_Rot_B[1] == 1'b0 && rCnt_Debounce_B == Debounce_A_B) ? 1'b1 : 1'b0;

    Steady_A <= (rFlop_Rot_A[2] && rFlop_Rot_A[1]) ? 1'b1 : 1'b0;
    Steady_B <= (rFlop_Rot_B[2] && rFlop_Rot_B[1]) ? 1'b1 : 1'b0;
  end

  // Delay Counter (100 ms)
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rCnt_Delay
    if (!Ext_RESETn) begin
      rCnt_Delay <= 22'd0;
    end else begin
      rCnt_Delay <= (rCnt_Delay < Onehundred_ms) ? rCnt_Delay + 22'd1 : 22'd0;
    end
  end

  // Toggle delay pulse every 100 ms
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rDelay
    if (!Ext_RESETn) begin
      rDelay <= 1'b0;
    end else begin
      rDelay <= (rCnt_Delay == Onehundred_ms) ? 1'b1 : 1'b0;
    end
  end

  // Mode selector by button press (C)
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rMode_Step_and_rStep
    if (!Ext_RESETn) begin
      rMode_step <= 2'd0;
    end else begin
      if (Rot_C) begin
        rMode_step <= (rMode_step < 2'd2) ? rMode_step + 2'd1 : 2'd0;
      end
    end
  end

  // Step of Counting
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rStep
    if (!Ext_RESETn) begin
      rStep <= 11'd1;
    end else begin
      case (rMode_step)
        2'd0:    rStep <= 11'd1;
        2'd1:    rStep <= 11'd10;
        2'd2:    rStep <= 11'd100;
        default: rStep <= 11'd1;
      endcase
    end
  end

  // State machine for up/down
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_State_and_rCnt_Rot
    if (!Ext_RESETn) begin
      State <= State_Idle;
      rCnt_Rot <= 11'd0;
      rCnt_Debounce_State <= 14'd0;
    end else begin
      case (State)
        State_Idle: begin
          //State <= (B_Fall) ? State_CW : (A_Fall) ? State_CCW : State_Idle;
          if (B_Fall) begin
            State <= State_CW;
          end else if (A_Fall) begin
            State <= State_CCW;
          end
        end

        State_CW: begin  // Up Count
          if (A_Fall) begin
            rCnt_Rot <= (rCnt_Rot + rStep >= Step_Max) ? Step_Max : rCnt_Rot + rStep;
            State <= State_Debounce;
            rCnt_Debounce_State <= 14'd0;
          end else begin
            State <= State_CW;
          end
        end

        State_CCW: begin  // Down Count
          if (B_Fall) begin
            rCnt_Rot <= (Mode != 3'd4 && rCnt_Rot < rStep) ?  Step_Min : 
                      (Mode == 3'd4 && rCnt_Rot <= Step_Min_Mode4) ?  Step_Min_Mode4 : 
                      rCnt_Rot - rStep;
            State <= State_Debounce;
            rCnt_Debounce_State <= 14'd0;
          end else begin
            State <= State_CCW;
          end
        end

        State_Debounce: begin
          if (rCnt_Debounce_State == Debounce_State) begin
            State <= State_Waitsteady;
            rCnt_Debounce_State <= 14'd0;
          end else begin
            rCnt_Debounce_State <= (rCnt_Debounce_State < Debounce_State) ? rCnt_Debounce_State + 14'd1 : rCnt_Debounce_State;
          end
        end

        State_Waitsteady: begin  // Wait for signal from Filter Metastable Phase to Steady logic high (no take action to Rotary)
          State <= (Steady_A && Steady_B) ? State_Idle : State_Waitsteady;
        end
        default: State <= State_Idle;
      endcase
    end
  end

  // add rCnt_Rot to rAddress
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rAddress
    if (!Ext_RESETn) begin
      rAddress <= 11'd0;
    end else begin
      if (rDelay) begin
        //rAddress <= rCnt_Rot;
        rAddress <= (Mode == 3'd4 && rCnt_Rot < Step_Min_Mode4) ? Step_Min_Mode4 : rCnt_Rot;
      end
    end
  end

  // Compare to toggle rFreqChng
  always @(posedge Fg_CLK or negedge Ext_RESETn) begin : u_rFreqChange
    if (!Ext_RESETn) begin
      rFreqChange <= 1'b0;
    end else begin
      rFreqChange <= ((rAddress != rCnt_Rot) && (rDelay)) ? 1'b1 : 1'b0;
    end
  end

  //----------------------------------------//
endmodule