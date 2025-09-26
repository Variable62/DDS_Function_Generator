//----------------------------------------//
// Filename     : LookUpTable.v
// Description  : Create Table
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 25/7/68
// Author       : Adisorn Sommart
// Remark       : 
//----------------------------------------//
module LookUpTable (
    input       wire        Fg_CLK,
    input       wire        Ext_RESETn,
    input       wire[10:0]  Address,
    input       wire[31:0]  out_1,
    input       wire[31:0]  out_2,
    output      wire[31:0]  sin1x,
    output      wire[31:0]  cos2x
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [47:0] Coefficient;
    wire [47:0] wCoefficient;
//----------------------------------------//
// Output Declaration
//----------------------------------------//
    assign sin1x = {4'b0000,Coefficient[47:24], 4'b0000};
    assign cos2x = {6'b001111, Coefficient[23:0], 2'b00};

     romcoef_module romcoefmod(
        .dout(wCoefficient), //output [47:0] dout
        .clk(Fg_CLK), //input clk
        .oce(1'd1), //input oce
        .ce(1'd1), //input ce
        .reset(~Ext_RESETn), //input reset Active high
        .ad(Address) //input [10:0] ad
    );

    always @(posedge Fg_CLK or negedge Ext_RESETn) begin
        if (~Ext_RESETn) begin
            Coefficient <= 48'd0;
        end
        else begin
            Coefficient <=wCoefficient;  
        end
    end

    
endmodule