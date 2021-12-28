// exec.v

`include "exec_insn_types.v"

module exec(
    input wire        clk,

    input wire [3:0]  insn_type,
    input wire [3:0]  insn_sub_type,

    input wire [3:0]  alu_code,

    input wire [4:0]  rs1_reg,
    input wire [31:0] rs1_regfile_val,
    input wire [4:0]  rs2_reg,
    input wire [31:0] rs2_regfile_val,

    input wire [31:0] pc_de,
    input wire [31:0] imm,
    input wire        use_imm,

    input wire [4:0]  bp_wb_reg,
    input wire [31:0] bp_wb_val,

    input wire [4:0]  bp_mem_reg,
    input wire [31:0] bp_mem_val,

    input wire [4:0]  de_rd,
    output reg [31:0] next_stage_val,

    output reg [4:0]  rd_ex,
    output reg [31:0] pc_offset,
    output reg [31:0] pc_base,
    output reg        pc_redirect_valid,

    output reg [31:0] store_val,
    output reg [3:0]  insn_type_r,
    output reg [3:0]  insn_sub_type_r,
    output wire ex_stall
);

reg [4:0]  ex_bp_reg;
reg [31:0] ex_bp_val;
reg [31:0] next_valid_pc;
reg wait_for_pc = 0;
reg [1:0] load_hazard = 0;
assign ex_stall = load_hazard[0] | load_hazard[1];

wire [31:0] w_alu_res;
wire [31:0] alu_rs1;
wire [31:0] alu_rs2;
wire [31:0] rs1_actual;
wire [31:0] rs2_actual;

assign rs1_actual = rs1_reg === ex_bp_reg  ? ex_bp_val  :
                    rs1_reg === bp_mem_reg ? bp_mem_val : rs1_regfile_val;

assign rs2_actual = rs2_reg === ex_bp_reg  ? ex_bp_val  :
                    rs2_reg === bp_mem_reg ? bp_mem_val : rs2_regfile_val;


assign cmp_eq   = w_alu_res[0];
assign cmp_less = w_alu_res[1];

assign alu_rs1 = insn_type === `DB_TYPE ? pc_de :
                 (insn_type === `AR_TYPE) & (insn_sub_type === `AR_AUIPC) ? pc_de : rs1_actual;

assign alu_rs2 = use_imm ? imm : rs2_actual;

alu alu(
    alu_code,
    alu_rs1,
    alu_rs2,
    w_alu_res
);

assign awaited_pc_valid = (pc_de === next_valid_pc);

always @(posedge clk) begin
    if (~ex_stall) begin
        insn_type_r <= insn_type;
        insn_sub_type_r <= insn_sub_type;
        if (pc_de === next_valid_pc) begin
            wait_for_pc <= 0;
            next_valid_pc <= 0;
        end
    end
    else
        load_hazard <= load_hazard - 1;
end

always @(posedge clk) begin
    if (wait_for_pc) begin
        pc_redirect_valid <= 0;
    end

    if ((~wait_for_pc | awaited_pc_valid) & ~ex_stall) begin
    case (insn_type)
        `AR_TYPE: begin
            load_hazard <= 0;
            pc_redirect_valid <= 0;
            case (insn_sub_type)
                `AR_GENERAL: begin
                    next_stage_val <= w_alu_res;
                    ex_bp_val <= de_rd === 5'b0 ? 0 : w_alu_res;
                    ex_bp_reg <= de_rd;
                end
                `AR_LUI: begin
                    next_stage_val <= imm;
                    ex_bp_val <= de_rd === 5'b0 ? 0 : imm;
                    ex_bp_reg <= de_rd;
                end
                `AR_SLT: begin
                    ex_bp_reg <= de_rd;
                    ex_bp_val <= cmp_less ? (de_rd === 5'b0 ? 0 : alu_rs2) : 32'h0;
                    next_stage_val <= cmp_less ? alu_rs2 : 32'h0;
                end
                `AR_AUIPC: begin
                    next_stage_val <= w_alu_res;
                    ex_bp_val <= de_rd === 5'b0 ? 0 : pc_de;
                    ex_bp_reg <= de_rd;
                end
            endcase
        end
        `L_TYPE: begin
            load_hazard <= 2;
            pc_redirect_valid <= 0;
            next_stage_val <= w_alu_res;
            ex_bp_reg <= 0;
            ex_bp_val <= 0;
        end
        `S_TYPE: begin
            load_hazard <= 0;
            pc_redirect_valid <= 0;
            next_stage_val <= w_alu_res;
            ex_bp_reg <= 0;
            ex_bp_val <= 0;
            store_val <= rs2_actual;
        end
        `DB_TYPE: begin
            load_hazard <= 0;
            case (insn_sub_type)
                `DB_BEQ: begin
                    ex_bp_reg <= 0;
                    ex_bp_val <= 0;
                    if (cmp_eq) begin
                        pc_offset <= imm;
                        pc_base <= pc_de;
                        pc_redirect_valid <= 1;
                        next_valid_pc <= pc_de + imm;
                        wait_for_pc <= 1;
                    end
                    else begin
                        pc_redirect_valid <= 0;
                        wait_for_pc <= 0;
                    end
                end
                `DB_BNE: begin
                    ex_bp_reg <= 0;
                    ex_bp_val <= 0;
                    if (~cmp_eq) begin
                        pc_offset <= imm;
                        pc_base <= pc_de;
                        pc_redirect_valid <= 1;
                        next_valid_pc <= pc_de + imm;
                        wait_for_pc <= 1;
                    end
                    else begin
                        pc_redirect_valid <= 0;
                        wait_for_pc <= 0;
                    end
                end
                `DB_BLT: begin
                    ex_bp_reg <= 0;
                    ex_bp_val <= 0;
                    if (cmp_less) begin
                        pc_offset <= imm;
                        pc_base <= pc_de;
                        pc_redirect_valid <= 1;
                        next_valid_pc <= pc_de + imm;
                        wait_for_pc <= 1;
                    end
                    else begin
                        pc_redirect_valid <= 0;
                        wait_for_pc <= 0;
                    end
                end
                `DB_BGE: begin
                    ex_bp_reg <= 0;
                    ex_bp_val <= 0;
                    if (~cmp_less) begin
                        pc_offset <= imm;
                        pc_base <= pc_de;
                        pc_redirect_valid <= 1;
                        next_valid_pc <= pc_de + imm;
                        wait_for_pc <= 1;
                    end
                    else begin
                        pc_redirect_valid <= 0;
                        wait_for_pc <= 0;
                    end
                end
                `DB_JAL: begin
                    pc_offset <= imm;
                    pc_base <= pc_de;
                    pc_redirect_valid <= 1;
                    next_stage_val <= pc_de + 4;
                    ex_bp_reg <= de_rd;
                    ex_bp_val <= de_rd === 5'b0 ? 0 : pc_de + 4;
                    next_valid_pc <= pc_de + imm;
                    wait_for_pc <= 1;
                end
            endcase
        end
        `IB_TYPE: begin
            load_hazard <= 0;
            pc_redirect_valid <= 1;
            pc_base <= alu_rs1;
            pc_offset <= imm;
            next_stage_val <= pc_de + 4;
            ex_bp_reg <= de_rd;
            ex_bp_val <= de_rd === 5'b0 ? 0 : pc_de + 4;
            next_valid_pc <= w_alu_res;
            wait_for_pc <= 1;
        end
    endcase

    rd_ex <= de_rd;
    end;
end

endmodule
