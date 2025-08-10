//----------------------------------------//
// Filename     : Button_Interface.v
// Description  : Button_IF_Create
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 6/7/68
// Author       : Adisorn  Sommart
// Remark       : New Creation
//----------------------------------------//
module BTN_IF (
    input       wire      Fg_CLK,
    input       wire      Ext_RESETn,
    input       wire      iExtBtn,
    output      wire[2:0] oIntBtn
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [24:0]          rCnt; // 25 bit
    reg [2:0]           rIntBtn;
//----------------------------------------//
// Output Declaration
//----------------------------------------//
    localparam Delay_Time = 25'd2400;
    assign oIntBtn = (rIntBtn[2] & ~rIntBtn[1] & (rCnt == 25'd0)) ? 1'd1 : 1'd0;
//----------------------------------------//
// Process Declaration
//----------------------------------------//
    always @(posedge Fg_CLK or negedge Ext_RESETn) begin    : u_rCNT
    if (~Ext_RESETn) begin
        rCnt <= 25'd0;
    end
    else begin   
        if(rCnt == 25'd0) begin
            rCnt <= (oIntBtn == 1'd1) ? 25'd1 : 25'd0; // when push button counter + 1
        end
        else begin 
            rCnt <= (rCnt != Delay_Time) ? rCnt+25'd1 : 25'd0;
        end
    end
    end

    always @(posedge Fg_CLK or negedge Ext_RESETn) begin  : u_rIntBtn
    if (~Ext_RESETn) begin
        rIntBtn <= 3'b111;
    end
    else    begin
        rIntBtn <=  {rIntBtn[1],rIntBtn[0],iExtBtn};
    end
    end
    
endmodule