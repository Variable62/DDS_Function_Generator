`timescale 1ns/1ps

module RCC (
    output wire     CLK,
    output wire     RESETn
);
    reg         rCLK;
    reg         rRESETn;

    assign      CLK     = rCLK;
    assign      RESETn  = rRESETn;

    initial begin : u_rCLK
        rCLK <= 1'd0;
        forever begin
            #18.515 // 27MHz ------>  37.037 ns 
        rCLK <= ~rCLK;
        end 
    end
    initial begin : u_rRESETn
        rRESETn <= 1'd0;
        repeat (10) begin
            @(posedge rCLK);
        end
        rRESETn <= 1'd1;
    end
endmodule