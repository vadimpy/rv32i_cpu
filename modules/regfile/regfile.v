// regfile.v

module regfile(
    // clock
    input wire clk,

    // read port 1
    input wire [4:0] r1_reg_name,
    output reg [31:0] r1_reg_val,

    // read port 2
    input wire [4:0] r2_reg_name,
    output reg [31:0] r2_reg_val,

    // write port
    input wire w_enable,
    input wire [4:0] w_reg_name,
    input wire [31:0] w_reg_val
);

reg [31:0] regs[1:31];

initial begin
    regs[2] <= 32'h7cc;
end

// read
always @(*) begin
    if (r1_reg_name == 5'b0)
        r1_reg_val <= 32'b0;
    else
        r1_reg_val <= regs[r1_reg_name];

    if (r2_reg_name == 5'b0)
        r2_reg_val <= 32'b0;
    else
        r2_reg_val <= regs[r2_reg_name];
end

// write
always @(negedge clk) begin
    if (w_enable)
        if (w_reg_name != 5'b0) begin
            regs[w_reg_name] <= w_reg_val;
        end
end

endmodule
