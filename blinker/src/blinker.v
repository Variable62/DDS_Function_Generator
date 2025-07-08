module Blinker(
    input       wire      CLK,
    input       wire      RESETn,
    output      wire      oLED
);
    reg [24:0]      rCNT; // 25bit
    reg             rLED;
    assign oLED = rLED;
    localparam  Delay_Time = 25'd26999999; // 1 s 27MHz trick

    always @(posedge CLK or negedge RESETn) begin : u_rCNT
        if (RESETn == 1'd0) begin
            rCNT <= 25'd0;
        end
        else begin
            rCNT <= (rCNT < Delay_Time) ? rCNT + 25'd1 : 25'd0;
        end
    end
    always @(posedge CLK or negedge RESETn) begin : u_rLED
        if (RESETn == 1'd0) begin
            rLED <= 1'd0;
        end
        else begin
            rLED <= (rCNT == Delay_Time) ? ~rLED : rLED;
        end
    end
endmodule