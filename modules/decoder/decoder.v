// decoder.v

`include "decode_defs.v"
`include "../exec/alu_codes.v"
`include "../exec/exec_insn_types.v"

module decoder(
    input wire         clk,
    input wire  [31:0] insn,
    input wire  [31:0] pc,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output reg  [4:0]  rd,
    output reg  [3:0]  alu_code, // ensure width
    output reg  [31:0] pc_de,
    output reg  [31:0] imm,
    output reg         ex_use_imm,
    output reg  [4:0]  rs1_reg,
    output reg  [4:0]  rs2_reg,
    output reg  [3:0]  insn_type,
    output reg  [3:0]  insn_sub_type
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] u_imm;
wire [31:0] i_imm;
wire [31:0] j_imm;
wire [31:0] b_imm;
wire [31:0] s_imm;
wire [31:0] shamt;

assign opcode = insn[6:0];
assign funct3 = insn[14:12];
assign funct7 = insn[31:25];
assign rs1 = insn[19:15];
assign rs2 = insn[24:20];
assign ecall_ebreak_field = insn[31:7];

assign u_imm = { insn[31:12], 12'b0 };
assign i_imm = { {21{insn[31]}}, insn[30:20] };
assign s_imm = { {21{insn[31]}}, insn[30:25], insn[11:8], insn[7]};
assign b_imm = { {20{insn[31]}}, insn[7], insn[30:25], insn[11:8], 1'b0 };
assign j_imm = { {12{insn[31]}}, insn[19:12], insn[20], insn[30:25], insn[24:21], 1'b0 };
assign shamt = { 27'b0, insn[24:20] };

always @(posedge clk) begin
    pc_de <= pc;
    rd <= insn[11:7];
    rs1_reg <= rs1;
    rs2_reg <= rs2;
end

always @(posedge clk) begin
    $display("%h:", pc);
    case (opcode)

        `LUI_OPCODE: begin
            $display("lui");
            imm <= u_imm;
            ex_use_imm <= 1;
            insn_type <= `AR_TYPE;
            insn_sub_type <= `AR_LUI;
        end

        // -------------------- //

        `AUIPC_OPCODE: begin
            $display("auipc");
            imm <= u_imm;
            ex_use_imm <= 1;
            insn_type <= `DB_TYPE;
            insn_sub_type <= `DB_AUIPC;
        end

        // -------------------- //

        `JAL_OPCODE: begin
            $display("jal");
            insn_type <= `DB_TYPE;
            insn_sub_type <= `DB_JAL;
        end

        // -------------------- //

        `JALR_OPCODE: begin
            insn_type <= `IB_TYPE;
            insn_sub_type <= `IB_JALR;
            alu_code <= `ADD;
            $display("jalr");
        end

        // -------------------- //

        `DIR_BRANCH_OPCODE: begin
            insn_type <= `DB_TYPE;
            case (funct3)
                `BEQ_FUNCT3: begin
                    insn_sub_type <= `DB_BEQ;
                    alu_code <= `CMP;
                    $display("beq");
                end
                `BNE_FUNCT3: begin
                    insn_sub_type <= `DB_BEQ;
                    alu_code = `CMP;
                    $display("bne");
                end
                `BLT_FUNCT3: begin
                    insn_sub_type <= `DB_BLT;
                    alu_code <= `CMP;
                    $display("blt");
                end
                `BGE_FUNCT3: begin
                    alu_code <= `CMP;
                    insn_sub_type <= `DB_BGE;
                    $display("bge");
                end
                `BLTU_FUNCT3: begin
                    alu_code <= `CMPU;
                    insn_sub_type <= `DB_BLT;
                    $display("bltu");
                end
                `BGEU_FUNCT3: begin
                    alu_code <= `CMPU;
                    insn_sub_type <= `DB_BGE;
                    $display("bgeu");
                end
            endcase
        end

        // -------------------- //

        `LOAD_OPCODE: begin
            insn_type = `L_TYPE;
            case (funct3)
                `LB_FUNCT3: begin
                    $display("lb");
                    insn_sub_type <= `L_B;
                end
                `LH_FUNCT3: begin
                    $display("lh");
                    insn_sub_type <= `L_H;
                end
                `LW_FUNCT3: begin
                    $display("lw");
                    insn_sub_type <= `L_W;
                end
                `LBU_FUNCT3: begin
                    $display("lbu");
                    insn_sub_type <= `L_BU;
                end
                `LHU_FUNCT3: begin
                    $display("lhu");
                    insn_sub_type <= `L_HU;
                end
            endcase
        end

        // -------------------- //

        `STORE_OPCODE: begin
            insn_type <= `S_TYPE;
            case (funct3)
                `SB_FUNCT3: begin
                    $display("sb");
                    insn_sub_type <= `S_B;
                end
                `SH_FUNCT3: begin
                    $display("sh");
                    insn_sub_type <= `S_H;
                end
                `SW_FUNCT3: begin
                    $display("sw");
                    insn_sub_type <= `S_W;
                end
            endcase
        end

        // -------------------- //

        `IMM_ARITHM: begin
            ex_use_imm <= 1;
            insn_type <= `AR_TYPE;
            case (funct3)
                `ADDI_FUNCT3: begin
                    $display("addi");
                    alu_code <= `ADD;
                    imm <= i_imm;
                    insn_sub_type <= `AR_GENERAL;
                end
                `SLTI_FUNCT3: begin
                    $display("slti");
                    alu_code <= `CMP;
                    imm <= i_imm;
                    insn_sub_type <= `AR_SLT;
                end
                `SLTIU_FUNCT3: begin
                    $display("sltiu");
                    alu_code <= `CMPU;
                    imm <= i_imm;
                    insn_sub_type <= `AR_SLT;
                end
                `XORI_FUNCT3: begin
                    $display("xori");
                    alu_code <= `XOR;
                    imm <= i_imm;
                    insn_sub_type <= `AR_GENERAL;
                end
                `ORI_FUNCT3: begin
                    $display("ori");
                    alu_code <= `OR;
                    imm <= i_imm;
                    insn_sub_type <= `AR_GENERAL;
                end
                `ANDI_FUNCT3: begin
                    $display("andi");
                    alu_code <= `AND;
                    insn_sub_type <= `AR_GENERAL;
                    imm <= i_imm;
                end
                `SLLI_FUNCT3: begin
                    if (funct7 == `SLLI_FUNCT7) begin
                        $display("slli");
                        alu_code <= `LS;
                        insn_sub_type <= `AR_GENERAL;
                        imm <= shamt;
                    end
                end
                `SRI_FUNCT3: begin
                    imm <= shamt;
                    case (funct7)
                        `SRLI_FUNCT7: begin
                            $display("srli");
                            alu_code <= `RSL;
                            insn_sub_type <= `AR_GENERAL;
                        end
                        `SRAI_FUNCT7: begin
                            $display("srai");
                            alu_code <= `RSA;
                            insn_sub_type <= `AR_GENERAL;
                        end
                    endcase
                end
            endcase
        end

        // -------------------- //

        `REG_ARITHM_OPCODE: begin
            ex_use_imm <= 0;
            insn_type <= `AR_TYPE;
            case (funct3)
                `ADD_SUB_FUNCT3: begin
                    insn_sub_type <= `AR_GENERAL;
                    case (funct7)
                        `ADD_FUNCT7: begin
                            $display("add");
                            alu_code <= `ADD;
                        end
                        `SUB_FUNCT7: begin
                            $display("sub");
                            alu_code <= `SUB;
                        end
                    endcase
                end
                `SLL_FUNCT3: begin
                    if (funct7 == `SLL_FUNCT7) begin
                        $display("sll");
                        alu_code <= `LS;
                        insn_sub_type <= `AR_GENERAL;
                    end
                end
                `SLT_FUNCT3: begin
                    if (funct7 == `SLT_FUNCT7) begin
                        $display("slt");
                        alu_code <= `CMP;
                        insn_sub_type <= `AR_SLT;
                    end
                end
                `SLTU_FUNCT3: begin
                    if (funct7 == `SLTU_FUNCT7) begin
                        $display("sltu");
                        alu_code <= `CMPU;
                        insn_sub_type <= `AR_SLT;
                    end
                end
                `XOR_FUNCT3: begin
                    if (funct7 == `XOR_FUNCT7) begin
                        $display("xor");
                        alu_code <= `XOR;
                        insn_sub_type <= `AR_GENERAL;
                    end
                end
                `SRR_FUNCT3: begin
                    case (funct7)
                        `SRL_FUNCT7: begin
                            $display("srl");
                            alu_code <= `RSL;
                            insn_sub_type <= `AR_GENERAL;
                        end
                        `SRA_FUNCT7: begin
                            $display("sra");
                            alu_code <= `RSA;
                            insn_sub_type <= `AR_GENERAL;
                        end
                    endcase
                end
                `OR_FUNCT3: begin
                    if (funct7 == `OR_FUNCT7) begin
                        $display("or");
                        alu_code <= `OR;
                        insn_sub_type <= `AR_GENERAL;
                    end
                end
                `AND_FUNCT3: begin
                    if (funct7 == `AND_FUNCT7) begin
                        $display("and");
                        alu_code <= `AND;
                        insn_sub_type <= `AR_GENERAL;
                    end
                end
            endcase
        end

        // -------------------- //

        `FENCE_OPCODE: begin
            case (funct3)
                `FENCE_FUNCT3: begin
                    $display("fence");
                end
                `FENCE_I_FUNCT3: begin
                    $display("fence.i");
                end
            endcase
        end

        // -------------------- //

        `SYSTEM_OPCODE: begin
            case (ecall_ebreak_field)
                `ECALL: begin
                    $display("ecall");
                end
                `EBREAK: begin
                    $display("ebreak");
                end
                default: begin
                    case (funct3)
                        `CSRRW_FUNCT3: begin
                            $display("csrrw");
                        end
                        `CSRRS_FUNCT3: begin
                            $display("csrrs");
                        end
                        `CSRRC_FUNCT3: begin
                            $display("csrrc");
                        end
                        `CSRRWI_FUNCT3: begin
                            $display("csrrwi");
                        end
                        `CSRRSI_FUNCT3: begin
                            $display("csrrsi");
                        end
                        `CSRRCI_FUNCT3: begin
                            $display("csrrci");
                        end
                    endcase
                end
            endcase
        end

    endcase
end

endmodule
