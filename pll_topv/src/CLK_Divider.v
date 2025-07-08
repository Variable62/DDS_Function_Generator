//----------------------------------------//
// Filename     : CLK_div.v
// Description  : Clockdivide
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 0.0
// Date         : 
// Author       : Adisorn Sommart
// Remark       : New Creation
//----------------------------------------//
module CLK_Divider (
    input   wire    Pll_CLK,
    input   wire    RESETn,
    output  wire    Fg_CLK,
    output  wire    Dac_CLK
);
    always @(posedge Pll_CLK or negedge RESETn) begin
        if(~RESETn) begin
            Fg_CLK <= 0;
        end
        else begin
            Fg_CLK <= ~Fg_CLK;
        end
    end

    always @(negedge Pll_CLK or negedge RESETn) begin
        if (~RESETn) begin
            Dac_CLK <= 0;
        end
        else begin
            Dac_CLK <= ~Dac_CLK;
    end
    end

endmodule