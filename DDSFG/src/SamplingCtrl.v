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
    input   wire    [2:0]oIntBtn,
    input   wire    Fg_RESETn,

    output  wire    DDSEnable,  
    output  wire    DDSReady,
    output  wire    [2:0]DDSMode
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [2:0] rDDSMode;
    reg [13:0]rValue;

    reg [13:0] rCnt;
    reg rDDSEnable;

    reg begin_ready;
    reg rDDSReady;
    reg [6:0] rCnt_Ready;

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
    
    always @(posedge Fg_CLK or negedge  Fg_RESETn) begin : u_rDDSMode
    if(~Fg_RESETn) begin
        rDDSMode <= 3'd0;
    end
    else begin
    if((oIntBtn && rDDSMode == 0) || (rDDSEnable && rPulse_In)) begin
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
                rPulse_In = rPulse_In;
    end
    end

    // initial ready
    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rbegin_ready
    if (!Fg_RESETn) begin
        begin_ready <= 1'd1;
    end else begin
        begin_ready <= (rCnt_Ready < 80 &&  begin_ready == 1) ? 1'd1 : 0;
    end
    end

    // ready counter
    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rCnt_Ready
    if (~Fg_RESETn) begin
        rCnt_Ready <= 7'd0;
    end
    else begin
        if (begin_ready == 1'd1) begin
            rCnt_Ready <= (rCnt_Ready < 80) ? rCnt_Ready + 7'd1 :  7'd0;
        end
    end
    end

    //ready signal
    always @(posedge Fg_CLK or negedge Fg_RESETn) begin : u_rDDSReady
    if (~Fg_RESETn) begin
        rDDSReady <= 1'd0;
    end
    else begin 
        if(rCnt_Ready < 80) begin
            rDDSReady <= 1'd0;
        end 
        else    begin
            rDDSReady <= 1'd1;

        end
    end

    end
endmodule