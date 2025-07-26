module Oscillator(
    input   wire        Fg_CLK,
    input   wire        Fg_RESETn,
    input   wire        DDSEnable,
    input   wire        DDSReady,
    input   wire[31:0]  init_1,
    input   wire[31:0]  init_2,
    
    output  wire[31:0]  out_1,
    output  wire[31:0]  out_2
); 

reg [31:0] r_out_1;
reg [31:0] r_out_2;
reg [31:0] r_out1_a;
reg [31:0] r_out;
reg [31:0] a;
reg [63:0] c;

assign  out_1 = r_out_1;
assign  out_2 = r_out_2;

always @(posedge Fg_CLK or negedge Fg_RESETn) begin :u_r_out_1
    if (~Fg_RESETn) begin
        r_out_1 <= 0;
    end
    else if(DDSReady) begin
        r_out_1 <= init_1; //sin(B)
    end
    else if(DDSEnable) begin
        r_out_1 <= r_out;
    end
    // else begin  
    //     r_out_1 <= r_out_1;
    // end 
end

always @(posedge Fg_CLK or negedge  Fg_RESETn) begin : u_r_out_2
    if (~Fg_RESETn) begin
        r_out_2 <= 0;
    end
    else if(DDSReady) begin
        r_out_2 <= 0;
    end
    else if(DDSEnable) begin
        r_out_2 <= r_out_1;
    end
    // else begin
    //     r_out_2 <= r_out_2;
    // end
end

always @(posedge Fg_CLK or negedge  Fg_RESETn) begin    
    if (~Fg_RESETn) begin
        a <= 0;
    end
    else if(DDSReady) begin
        a <= init_2; //
    end
end

always @(*) begin 
   c <= $signed(a)*$signed(r_out_1);
    r_out1_a <= c[60:29];
end

always @(*) begin 
    r_out <= r_out1_a - r_out_2;
end
endmodule