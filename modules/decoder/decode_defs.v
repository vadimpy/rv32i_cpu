// decode_defs.v

// RV-32i decode bindings

// LUI
`define LUI_OPCODE 7'b0110111



// ----------------------------- //


// AUIPC
`define AUIPC_OPCODE 7'b0010111


// ----------------------------- //


// JAL
`define JAL_OPCODE 7'b1101111


// ----------------------------- //


// JALR
`define JALR_OPCODE 7'b1100111
`define JALR_FUNCT3 3'b000


// ----------------------------- //




// GROUP 7'b1100011 - direct branches

`define DIR_BRANCH_OPCODE 7'b1100011

// BEQ
`define BEQ_OPCODE 7'b1100011
`define BEQ_FUNCT3 3'b000

// BNE
`define BNE_OPCODE 7'b1100011
`define BNE_FUNCT3 3'b001

// BLT
`define BLT_OPCODE 7'b1100011
`define BLT_FUNCT3 3'b100

// BGE
`define BGE_OPCODE 7'b1100011
`define BGE_FUNCT3 3'b101

// BLTU
`define BLTU_OPCODE 7'b1100011
`define BLTU_FUNCT3 3'b110

// BGEU
`define BGEU_OPCODE 7'b1100011
`define BGEU_FUNCT3 3'b111

// ----------------------------- //






// LOAD GROUP 7'b0000011

`define LOAD_OPCODE 7'b0000011

// LB
`define LB_OPCODE 7'b0000011
`define LB_FUNCT3 3'b000

// LH
`define LH_OPCODE 7'b0000011
`define LH_FUNCT3 3'b001

// LW
`define LW_OPCODE 7'b0000011
`define LW_FUNCT3 3'b010

// LBU
`define LBU_OPCODE 7'b0000011
`define LBU_FUNCT3 3'b100

// LHU
`define LHU_OPCODE 7'b0000011
`define LHU_FUNCT3 3'b101

// ----------------------------- //






// STORE GROUP

`define STORE_OPCODE 7'b0100011

// SB
`define SB_OPCODE 7'b0100011
`define SB_FUNCT3 3'b000

// SH
`define SH_OPCODE 7'b0100011
`define SH_FUNCT3 3'b001

// SW
`define SW_OPCODE 7'b0100011
`define SW_FUNCT3 3'b010

// ----------------------------- //






// IMM ARITHMETIC

`define IMM_ARITHM 7'b0010011

// ADDI
`define ADDI_OPCODE 7'b0010011
`define ADDI_FUNCT3 3'b000

// SLTI
`define SLTI_OPCODE 7'b0010011
`define SLTI_FUNCT3 3'b010

// SLTIU
`define SLTIU_OPCODE 7'b0010011
`define SLTIU_FUNCT3 3'b011

// XORI
`define XORI_OPCODE 7'b0010011
`define XORI_FUNCT3 3'b100

// ORI
`define ORI_OPCODE 7'b0010011
`define ORI_FUNCT3 3'b110

// ANDI
`define ANDI_OPCODE 7'b0010011
`define ANDI_FUNCT3 3'b111

// SLLI
`define SLLI_OPCODE 7'b0010011
`define SLLI_FUNCT3 3'b001
`define SLLI_FUNCT7 7'b0000000



`define SRI_FUNCT3 3'b101

// SRLI
`define SRLI_OPCODE 7'b0010011
`define SRLI_FUNCT3 3'b101
`define SRLI_FUNCT7 7'b0000000

// SRAI
`define SRAI_OPCODE 7'b0010011
`define SRAI_FUNCT3 3'b101
`define SRAI_FUNCT7 7'b0100000



// ----------------------------- //







// REG ARITHM GROUP

`define REG_ARITHM_OPCODE 7'b0110011

`define ADD_SUB_FUNCT3 3'b000

// ADD
`define ADD_OPCODE 7'b0110011
`define ADD_FUNCT3 3'b000
`define ADD_FUNCT7 7'b0000000

// SUB
`define SUB_OPCODE 7'b0110011
`define SUB_FUNCT3 3'b000
`define SUB_FUNCT7 7'b0100000

// SLL
`define SLL_OPCODE 7'b0110011
`define SLL_FUNCT3 3'b001
`define SLL_FUNCT7 7'b0000000

// SLT
`define SLT_OPCODE 7'b0110011
`define SLT_FUNCT3 3'b010
`define SLT_FUNCT7 7'b0000000

// SLTU
`define SLTU_OPCODE 7'b0110011
`define SLTU_FUNCT3 3'b011
`define SLTU_FUNCT7 7'b0000000

// XOR
`define XOR_OPCODE 7'b0110011
`define XOR_FUNCT3 3'b100
`define XOR_FUNCT7 7'b0000000


`define SRR_FUNCT3 3'b101

// SRL
`define SRL_OPCODE 7'b0110011
`define SRL_FUNCT3 3'b101
`define SRL_FUNCT7 7'b0000000

// SRA
`define SRA_OPCODE 7'b0110011
`define SRA_FUNCT3 3'b101
`define SRA_FUNCT7 7'b0100000

// OR
`define OR_OPCODE 7'b0110011
`define OR_FUNCT3 3'b110
`define OR_FUNCT7 7'b0000000

// AND
`define AND_OPCODE 7'b0110011
`define AND_FUNCT3 3'b111
`define AND_FUNCT7 7'b0000000

// ----------------------------- //







// FENCE

// FENCE
`define FENCE_OPCODE 7'b0001111
`define FENCE_FUNCT3 3'b000

// FENCE.I
`define FENCE_I_OPCODE 7'b0001111
`define FENCE_I_FUNCT3 3'b001

// ----------------------------- //






// System group

`define SYSTEM_OPCODE 7'b1110011

// ECALL
`define ECALL_OPCODE 7'b1110011
`define ECALL 32'b0000000000000000000000000

// EBREAK
`define EBREAK_OPCODE 7'b1110011
`define EBREAK 32'b0000000000010000000000000

// CSRRW
`define CSRRW_OPCODE 7'b1110011
`define CSRRW_FUNCT3 3'b001

// CSRRS
`define CSRRS_OPCODE 7'b1110011
`define CSRRS_FUNCT3 3'b010

// CSRRC
`define CSRRC_OPCODE 7'b1110011
`define CSRRC_FUNCT3 3'b011

// CSRRWI
`define CSRRWI_OPCODE 7'b1110011
`define CSRRWI_FUNCT3 3'b101

// CSRRSI
`define CSRRSI_OPCODE 7'b1110011
`define CSRRSI_FUNCT3 3'b110

// CSRRCI
`define CSRRCI_OPCODE 7'b1110011
`define CSRRCI_FUNCT3 3'b111
