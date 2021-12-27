// fetch.v

module fetch #(parameter ENTRYPOINT = 32'h140) (
    input wire         clk,
    input wire  [31:0] pc_ex_off,
    input wire  [31:0] pc_ex_base,
    input wire         pc_ex_valid,
    input wire  [31:0] mem_data,
    input wire         ex_stall,
    output wire [29:0] mem_addr,
    output reg  [31:0] insn,
    output reg  [31:0] pc_de
);

reg [31:0] pc;
reg [31:0] pc_prev;
reg [31:0] prev_insn;



assign mem_addr = pc[31:2];

initial begin
    pc <= ENTRYPOINT;
end

always @(posedge clk) begin
    /*
    $display("stall %b", ex_stall);
    $display("insn %h", insn);
    $display("mem_data %h", mem_data);
    $display("pc_prev %h", pc_prev);
    $display("pc_de %h", pc_de);
    $display("\n");
    */
    if (~ex_stall) begin
        // $display("fetch insn: %h", mem_data);
        prev_insn <= insn;
        insn <= mem_data;
        pc_prev <= pc;
        pc_de <= pc_prev;

        if (pc_ex_valid) begin
            $display("from exec: %h %h", pc_ex_base, pc_ex_off);
            pc <= pc_ex_base + pc_ex_off;
        end
        else begin
            // $display("next");
            pc <= pc + 4;
        end
    end
    else begin
        pc <= pc_prev;
    end
end

endmodule
