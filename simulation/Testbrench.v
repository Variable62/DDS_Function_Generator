`timescale 1ns/1ps

module Testbrench (
    input   wire    Ext_CLK,
    
    output  wire    Fg_CLK,
    output  wire    Dac_CLK
    );
    reg Ext_RESETn;
    reg iExtBtn;
    RCC m_RCC (
        .CLK(Ext_CLK)
    );

    DDS_Top m_DDS_Top(
        .Ext_CLK(Ext_CLK),
        .Ext_RESETn(Ext_RESETn),
        .iExtBtn(iExtBtn),
        .Fg_CLK(Fg_CLK),
        .Dac_CLK(Dac_CLK)
    );

  initial begin 
    Ext_RESETn = 1;
    iExtBtn     = 1;
 
    #10000;
    Ext_RESETn = 0;
    #5;
    Ext_RESETn = 1;
    #1000;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400000;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #1500000;
 
    Ext_RESETn = 0;
    #5;
    Ext_RESETn = 1;
    #10000;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400000;
 
    iExtBtn = 1;
    #120;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400000;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400000;
 
    iExtBtn = 1;
    #2400000;
    iExtBtn = 0;
    #500;
    iExtBtn = 1;
    #2400000;
 
  $finish;
  end
  
endmodule