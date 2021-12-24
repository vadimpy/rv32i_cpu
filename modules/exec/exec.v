// exec.v

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
    output reg [31:0] pc_redirect,
    output reg        pc_redirect_valid,
    output reg        is_pc_redirect_offset
);

reg [4:0]  ex_bp_reg;
reg [31:0] ex_bp_val;

wire [31:0] w_alu_res;

assign alu_rs1 = insn_type == `DB_TYPE ? pc_de   :   
                 rs1_reg == ex_bp_reg  ? ex_bp_val  :
                 rs1_reg == bp_mem_reg ? bp_mem_val :
                 rs1_reg == bp_wb_reg  ? bp_wb_val  : rs1;

assign alu_rs2 = use_imm ? imm :
                 rs2_reg == ex_bp_reg  ? ex_bp_val  :
                 rs2_reg == bp_mem_reg ? bp_mem_val :
                 rs2_reg == bp_wb_reg  ? bp_wb_val  : rs2;

alu alu(
    alu_code,
    rs1,
    alu_rs2,
    w_alu_res
);

always @(posedge clk) begin
    case (insn_type)
        `AR_TYPE: begin
            case (insn_sub_type)
                `AR_GENERAL: begin
                    next_stage_val <= w_alu_res;
                    ex_bp_val <= w_alu_res;
                    ex_bp_reg <= de_rd;
                end
                `AR_LUI: begin
                    next_stage_val <= imm;
                    ex_bp_val <= w_alu_res;
                    ex_bp_reg <= de_rd;
                end
                `AR_SLT: begin
                    ex_bp_reg <= de_rd;
                    next_stage_val <= w_alu_res[1] ? alu_rs2 : 32'h0;
                end
            endcase
        end
        `L_TYPE: begin
            next_stage_val <= w_alu_res;
        end
        `S_TYPE: begin
            next_stage_val <= w_alu_res;
        end
        `DB_TYPE: begin
            
        end
        `IB_TYPE: begin
            
        end
    endcase

    ex_bp_reg <= rd_de;
    ex_bp_val <= alu_res; // or?

    pc_ex <= pc_de;
    rd_ex <= rd_de;
    next_stage_val <= w_alu_res;
end

endmodule
