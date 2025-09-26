`timescale 1ns / 1ps
module Testbrench (
    input   wire    Ext_CLK,
    output  wire    Fg_CLK,
    output  wire    Dac_CLK
    );

    wire iExtBtn;
    wire Ext_RESETn;
    wire wExt_Btn_Rot_C;
    wire Ext_Rot_A;
    wire Ext_Rot_B;
    
    RCC m_RCC (
        .CLK(Ext_CLK)
    );

    DDS_Top m_DDS_Top(
        .Ext_CLK(Ext_CLK),
        .Ext_RESETn(Ext_RESETn),
        .Ext_Rot_A(Ext_Rot_A),
        .Ext_Rot_B(Ext_Rot_B),
        .Ext_Btn_Rot_C(wExt_Btn_Rot_C),
        .Fg_CLK(Fg_CLK),
        .Dac_CLK(Dac_CLK),
        .iExtBtn(iExtBtn)
    );

    signalGen m_signalGen (
        .Ext_RESETn(Ext_RESETn),
        .ExtBtn(iExtBtn),
        .Ext_Btn_Rot_C(wExt_Btn_Rot_C),
        .Ext_Rot_A(Ext_Rot_A), 
        .Ext_Rot_B(Ext_Rot_B)
    );


endmodule