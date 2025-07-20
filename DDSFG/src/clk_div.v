//----------------------------------------//
// Filename     : CLK_div.v
// Description  : Clockdivide
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 6/7/68
// Author       : Adisorn Sommart
// Remark       : New Creation
//----------------------------------------//
module clk_div (
    input   wire   Pll_CLK,
    input   wire   RESETn,
    output  wire    Fg_CLK,
    output  wire    Dac_CLK
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg rFg_CLK;
    reg rDac_CLK;
//----------------------------------------//
// Output Declaration
//----------------------------------------//
    assign  Fg_CLK = rFg_CLK;
    assign  Dac_CLK = rDac_CLK;
//----------------------------------------//
// Process Declaration
//----------------------------------------//  
    always @(posedge Pll_CLK or negedge RESETn) begin
        if(~RESETn) begin
            rFg_CLK <= 0;
        end
        else begin
            rFg_CLK <= ~rFg_CLK;
        end
    end

    always @(negedge Pll_CLK or negedge RESETn) begin
        if (~RESETn) begin
            rDac_CLK <= 0;
        end
        else begin
            rDac_CLK <= ~rDac_CLK;
        end
    end

endmodule