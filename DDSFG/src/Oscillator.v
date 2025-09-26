module Oscillator (
    input  wire        Fg_CLK,
    input  wire        Fg_RESETn,
    input  wire        DDSEnable,
    input  wire        DDSReady,
    input  wire [31:0] init_1,     // sin(b)
    input  wire [31:0] init_2,     // 2cos(b)
    input  wire        FreqChng,
    input  wire [ 2:0] DDSMode,
    output wire [31:0] out_1,
    output wire [31:0] out_2
);
  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg [31:0] a;
  reg [63:0] c;
  reg [31:0] out_1_a;
  reg [31:0] Out;
  reg [31:0] rout_1;
  reg [31:0] rout_2;
  reg        Zero_Cross;
  reg        Update_Wait;
  reg        Do_Update;
  reg        Dir;  // 1 = up , 0 = down
  reg [31:0] Sine;

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//

  assign out_1 = rout_1;
  assign out_2 = rout_2;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  // c = a * out_1
  always @(*) begin : for_combination_from_Formula
    c = $signed(a) * $signed(out_1);
  end

  always @(*) begin : u_out_1_a
    out_1_a = c[60:29];
  end

  // Out = out_1_a - out_2 = out_1_a + c*out_2
  always @(*) begin : u_Out
    Out = out_1_a - out_2;
  end

  // a = 2cos(B)
  always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_a
    if (!Fg_RESETn) begin
      a <= 31'd0;
    end else if (DDSReady ) begin
      a <= init_2;
    end
  end

  // for out_1
  always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rout_1
    if (!Fg_RESETn) begin
      rout_1 <= 32'd0;
    end else if (DDSReady ) begin
      rout_1 <= init_1;  // init_1 SINE
    end else if (DDSEnable) begin
      rout_1 <= Out;
    end
  end

  // for out_2
  always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rout_2
    if (!Fg_RESETn) begin
      rout_2 <= 32'd0;
    end else if (DDSReady) begin
      rout_2 <= 32'd0;
    end else if (DDSEnable) begin
      rout_2 <= out_1;
    end
  end

  always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_Update_Wait
    if (!Fg_RESETn) begin
      Update_Wait <= 1'b0;
    end else begin
      Update_Wait <= (FreqChng) ? 1'b1 : (Zero_Cross) ? 1'b0 : Update_Wait;
    end
  end

  // toggle Zero for check origin point of sine wave
  always @(*) begin : u_Zero
    if (DDSMode != 3'd4) begin  // for DDSMode 0-3 : check 10 bits 
      Zero_Cross = (rout_1[31:22] == 10'b0000000000 || rout_1[31:22] == 10'b1111111111) ? 1'b1 : 1'b0;
    end else begin  // for DDSMode 4 : check 9 bits
      Zero_Cross = (rout_1[31:23] == 9'b000000000 || rout_1[31:23] == 9'b111111111) ? 1'b1 : 1'b0;
    end
  end

  //Direction of sine wave 
  always @(*) begin : u_Dir
    Dir  = rout_2[31];  // 1 = up , 0 = down
    Sine = (Dir) ? init_1 : ~init_1 + 1;
  end

  // toggle Do_Update for change Freq.
  always @(*) begin : u_Do_Update
    Do_Update = (Zero_Cross && Update_Wait) ? 1'b1 : 1'b0;
  end
endmodule
/*
         [ fs = 24 MHz] from Clk_Div(24 Mhz Phase 0 degree) 
         [ Ts = 1/fs]
         [ f = Freq. Need!!!! Ex(10kHz , 100kHz )]
         [ B = 2*pi*f*Ts]  
*/