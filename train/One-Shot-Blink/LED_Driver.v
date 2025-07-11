module LED_Driver (
    input   wire    iIntBtn,
    input   wire    RESETn,
    input   wire    CLK,
    output  wire    oLED
);
    localparam  cOnPeriod = 4;
    reg [2:0]   rCnt;

    assign  oLED = (rCnt != 0) ? 1'd1 :1'd0;

    always @(posedge CLK or negedge RESETn) begin  : u_rCnt
    if (~RESETn) begin
        rCnt <=1'd0;
    end
    else begin
        //detect switch
        if (rCnt == 3'd0) begin
            rCnt <= (iIntBtn == 1'd1) ? 3'd1 : 3'd0; // when push button counter + 1
        end
        rCnt    <=  (rCnt == cOnPeriod) ? 3'd0 : rCnt + 3'd1;
        end
    end
endmodule