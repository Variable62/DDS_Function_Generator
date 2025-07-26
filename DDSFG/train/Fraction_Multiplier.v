reg [31:0] a;
reg [31:0] b;
reg [63:0] c;
reg [31:0] out1_a;

always @(*) begin // combination
    c <= $signed(a)*$signed(b);

    out1_a <= c[60:29];
end