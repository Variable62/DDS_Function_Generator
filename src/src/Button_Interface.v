//----------------------------------------//
// Filename     : Button_Interface.v
// Description  : 
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 0.0
// Date         : 
// Author       : Adisorn  Sommart
// Remark       : New Creation
//----------------------------------------//
module BTN_IF (
    input       wire    Fg_CLK,
    input       wire    RESETn,
    input       wire    ExtBtn
    output      wire    oIntBtn,
    output      wire    oCnt
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [24:0]          rCnt; // 25 bit
    reg [2:0]           rIntBtn;
//----------------------------------------//
// Output Declaration
//----------------------------------------//
    assign  oCnt    =   rCnt;
    assign  oIntBtn  =   rIntBtn[1];
//----------------------------------------//
// Process Declaration
//----------------------------------------//
    always @(posedge Fg_CLK or negedge RESETn) begin    : u_rCNT
    if (RESETn == 1'd0) begin
        rCnt <= 25'd0;
    end
    else begin

    end
    end

    always @() begin
        
    end
endmodule