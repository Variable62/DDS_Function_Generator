module Tesbrench (
    wire    wCLK,
    wire    wRESETn,
    wire    wPllClk,
    wire    wLock,
    wire    wFg_CLk,
    wire    wDac_Clk
);
    RCC rcc_module(
        .CLK    (wCLK),
        .RESETn (wRESETn)
    );

    pll_module  pll_module(
        .clkin   (wCLK),
        .clkout  (wPllClk),
        .lock    (wLock),
        .reset   (1'b0)
    );
    CLK_Divide clk_module (
        .Pll_CLK        (wPllClk),
        .Fg_RESETn      (wRESETn),
        .Fg_CLK         (wFg_CLk),
        .Dac_CLK        (wDac_Clk)
    );
endmodule