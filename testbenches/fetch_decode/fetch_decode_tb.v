// fetch_decode.v

`timescale 1 ns/10 ps

module fetch_decode_tb;

reg clk = 0;
always #5 clk = ~clk;

wire [29:0] fetch_addr;
wire [31:0] fetch_data;

reg [29:0] r2_addr;
wire [31:0] r2_val;

reg w_enable = 0;
reg [29:0] w_addr;
reg [31:0] w_val;
reg [3:0] byte_en;

mem mem(
    clk,
    fetch_addr,
    fetch_data,
    r2_addr,
    r2_val,
    w_enable,
    w_addr,
    w_val,
    byte_en
);

wire [31:0] pc_ex_off;
assign pc_ex_off = 0;
assign pc_ex_valid = 0;
wire [31:0] insn;
wire [31:0] pc;

fetch #(32'h54) fetch(
    clk,
    pc_ex_off,
    pc_ex_valid,
    fetch_data,
    fetch_addr,
    insn,
    pc
);

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [3:0] alu_code;
wire [31:0] pc_de;

decoder decoder(
    clk,
    insn,
    pc,
    rs1,
    rs2,
    rd,
    alu_code,
    pc_de
);

reg [15:0] cnt = 100;

always @(posedge clk) begin
    if (cnt == 0)
        $finish;
    cnt <= cnt - 1;
end

endmodule