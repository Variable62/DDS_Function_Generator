//----------------------------------------//
// Filename     : SamplingCtrl.v
// Description  : 
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 14/7/68
// Author       : Adisorn Sommart
// Remark       : New Creation
//----------------------------------------//
module SamplingCtrl (
    input   wire    Fg_CLK,
    input   wire    oIntBtn,
    input   wire    Fg_RESETn,

    output  wire    DDSEnable,  
    output  wire    DDSReady,
    output  wire    DDSMode
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [2:0] rDDSMode;
    reg [13:0]rValue;
    reg [13:0] rCnt;
    reg rDDSEnable;
    reg rDDSReady;
    reg rPulse_In;
//----------------------------------------//
// Output Declaration
//-----------------------------------------//
    assign  DDSMode = rDDSMode;
    assign  DDSReady = rDDSReady;
    assign  DDSEnable = rDDSEnable;
//----------------------------------------//
// Process Declaration
//----------------------------------------//
    always @(posedge Fg_CLK or negedge  Fg_RESETn) begin  : u_rCnt
        if (~Fg_RESETn) begin
            rCnt <= 13'd0;
        end
        else    begin
        rCnt <= (rCnt < rValue) ? rCnt + 13'd1 : 13'd0;
    end
    end
    //Memmory and assign rValue
    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rValue
    if(~Fg_RESETn) begin
            rValue <= 13'd0;
    end
    else begin
            case (rDDSMode)
                0: rValue   <=  0;
                1: rValue   <=  9;
                2: rValue   <=  99;
                3: rValue   <=  999;
                4:rValue    <=  9999;
                default: rValue <= 0;
            endcase
    end
    end

    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rDDSEnable
    if (~Fg_RESETn) begin
        rDDSEnable <= 1'd0;
    end
    else begin
        rDDSEnable <= (rCnt == rValue) ? 1 : 0;
    end
    end
    
    always @(posedge Fg_CLK or negedge  Fg_RESETn) begin 
    if(~Fg_RESETn) begin
        rDDSMode <= 3'd0;
    end
    else begin
    if((oIntBtn && rCnt == rValue) || (rDDSEnable && rPulse_In)) begin
        rDDSMode <= (rDDSMode < 3'd4) ? rDDSMode + 3'd1 : 3'd0;
    end
    end 
    end

    always @(posedge Fg_CLK or negedge  Fg_RESETn) begin : u_rPulse_In
    if(~Fg_RESETn) begin
        rPulse_In <= 1'd0;
    end
    else begin
        if(oIntBtn) begin
            rPulse_In <= 1'd1;
        end
            else if (rDDSEnable == 1) begin
                rPulse_In <= 1'd0;
            end
            else
                rPulse_In = rPulse_In + 1;
    end
    end

    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rDDSReady
    if (~Fg_RESETn) begin
        rDDSReady <= 1'd0;
    end
    else begin 
        if(rDDSReady < 80) begin
            rDDSReady <= 1'd1;
        end 
        else    begin
            rDDSReady <= 1'd0;
        end
    end
    end
endmodule