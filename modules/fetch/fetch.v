// fetch.v

module fetch #(parameter ENTRYPOINT = 32'h54) (
    input wire clk,
    input wire [31:0] pc_ex_off,
    input wire pc_ex_valid,
    input wire [31:0] mem_data,
    output wire [29:0] mem_addr,
    output reg [31:0] insn,
    output reg [31:0] pc_de
);

reg [31:0] pc;
reg [31:0] pc_prev;

assign mem_addr = pc[31:2];

initial begin
    pc <= ENTRYPOINT;
end

always @(posedge clk) begin
    insn <= mem_data;
    pc_prev <= pc;
    pc_de <= pc_prev;

    if (pc_ex_valid)
        pc <= pc + pc_ex_off;
    else
        pc <= pc + 4;
end


endmodule