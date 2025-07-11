module button_interface (
    input   wire    CLK;
    input   wire    RESETn;
    input   wire    iExtBtn;
    output  wire    oIntBtn
);
    reg [1:0]   rIntBtn;
    assign oIntBtn = rIntBtn[1];
    
    always @(posedge CLK or negedge RESETn) begin : u_rIntBtn
    if (RESETn == 1'd0) begin
        rIntBtn <= 2'b11;
    end
    else begin
        rIntBtn <= {rIntBtn[0],iExtBtn};
    end
endmodule   