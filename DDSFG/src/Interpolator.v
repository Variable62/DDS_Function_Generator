//----------------------------------------//
// Filename     : interpolator.v
// Description  : interpolator
// Company      : KMITL
// Project      : Digital Direct Synthesis Function Generator
//----------------------------------------//
// Version      : 00.01
// Date         : 
// Author       : Adisorn Sommart
// Remark       : fix delta 
//----------------------------------------//
module Interpolator (
    input   wire        Fg_CLK,
    input   wire        Fg_RESETn,
    input   wire [31:0] out_1,  // Y[n-1]
    input   wire [31:0] out_2, // Y[n-2]
    input   wire [2:0]  DDSMode,
    input   wire        DDSEnable,
    output  wire [11:0] InterpOut
);
//----------------------------------------//
// Signal Declaration
//----------------------------------------//
    reg [31:0] N;
    reg [63:0] delta;
    reg [32:0] Out;
    reg [11:0] rInterpOut;
    reg Enable_delay;
//----------------------------------------//
// Output Declaration
//----------------------------------------//
    assign  InterpOut = rInterpOut;
//----------------------------------------//
// Process Declaration
//----------------------------------------//
    always @(posedge Fg_CLK or negedge Fg_RESETn) begin 
    if (~Fg_RESETn) begin
        N <= 0;
    end
        else    begin
            case (DDSMode)
                0: N <= 32'd1; 
                1: N <= 32'd53687091;    
                2: N <= 32'd5368709;
                3: N <= 32'd536870;
                4: N <= 32'd53687;
                default: N <= 32'd1;
            endcase
        end
    end

    always @(*) begin
         delta <= $signed(out_1-out_2) * $signed(N);
    end

    always @(posedge Fg_CLK or negedge Fg_RESETn) begin 
    if (~Fg_RESETn) begin
        Enable_delay <= 0;
    end
        Enable_delay <= DDSEnable;
    end

    always @(posedge Fg_CLK or negedge Fg_RESETn) begin
    if(~Fg_RESETn) begin
        Out <= 0;
    end
    else begin 
        if (Enable_delay) begin    
            Out <= out_2;
        end
         else begin
            Out <= $signed(Out) + delta[60:29];
        end
    end
    end

    always @(posedge Fg_CLK or negedge Fg_RESETn) begin
    if (~Fg_RESETn) begin
        rInterpOut <= 0;
    end
    else    
        rInterpOut <= Out[29:18]; 
    end

endmodule