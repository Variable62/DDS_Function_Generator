//----------------------------------------//
// Filename     : DDS_TOP.v
// Description  : DDS_TOP
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 8/7/68
// Author       : Adisorn Sommart
// Remark       : New Creation
//----------------------------------------//
module DDS_Top (
        input       wire    Ext_CLK,
        input       wire    Ext_RESETn,
        input       wire    iExtBtn,

        output      wire    Fg_CLK,
        output      wire    Dac_CLK
);
    wire    wPll_CLK;
    wire    wLock;
    wire    wFg_RESETn;
    wire    wPll_RESETn;
    wire    [2:0]oIntBtn;
    wire    wDDSEnable;
    wire    [2:0]wDDSMode;
    wire    wDDSReady;
    wire    [31:0]wout_1;
    wire    [31:0]wout_2;
    wire    [11:0]wOUT;
    Reset_Gen m_ResetGen (
        .Ext_RESETn(Ext_RESETn),
        .Ext_CLK(Ext_CLK),
        .PllLocked(wLock),
        .PllRESETn(wPll_RESETn),
        .Fg_RESETn(wFg_RESETn)
    );

    pll_module m_pll(
        .clkin(Ext_CLK),
        .clkout(wPll_CLK),
        .lock(wLock),
        .reset(~wPll_RESETn)
    );

    clk_div m_clk_div (
        .Pll_CLK(wPll_CLK),
        .RESETn(wFg_RESETn),
        .Fg_CLK(Fg_CLK),
        .Dac_CLK(Dac_CLK)
    );
    
    BTN_IF m_BtnIf (
        .iExtBtn(iExtBtn),
        .Fg_CLK(Fg_CLK),
        .oIntBtn(oIntBtn),
        .Ext_RESETn(wFg_RESETn)
    );

    SamplingCtrl m_samp(
        .Fg_CLK(Fg_CLK),
        .oIntBtn(oIntBtn),
        .Fg_RESETn(wFg_RESETn),
        .DDSEnable(wDDSEnable),
        .DDSReady(wDDSReady),
        .DDSMode(wDDSMode)
    );

    Oscillator m_osc(
        .Fg_CLK(Fg_CLK),
        .Fg_RESETn(wFg_RESETn),
        .DDSEnable(wDDSEnable),
        .DDSReady(wDDSReady),
        .init_1(32'd96878045),// sin(B)
        .init_2(32'd1054193702),//2cos(B)

        .out_1(wout_1),
        .out_2(wout_2)
    );

    Interpolator m_interp(
        .Fg_CLK(Fg_CLK),
        .Fg_RESETn(wFg_RESETn),
        .out_1(wout_1),
        .out_2(wout_2),
        .DDSMode(wDDSMode),
        .DDSEnable(wDDSEnable),
        .InterpOut(wOUT)  
    );

endmodule