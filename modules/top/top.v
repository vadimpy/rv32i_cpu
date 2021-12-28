module top(
    input wire clk
);

wire [29:0] ram_r1_addr;
wire [31:0] ram_r1_val;
wire [29:0] ram_r2_addr;
wire [31:0] ram_r2_val;
wire        ram_w_enable;
wire [29:0] ram_w_addr;
wire [31:0] ram_w_val;
wire [3:0]  ram_w_byte_en;

ram ram(
    clk,
    ram_r1_addr,
    ram_r1_val,
    ram_r2_addr,
    ram_r2_val,
    ram_w_enable,
    ram_w_addr,
    ram_w_val,
    ram_w_byte_en
);

wire [4:0]  regfile_r1_reg;
wire [31:0] regfile_r1_val;
wire [4:0]  regfile_r2_reg;
wire [31:0] regfile_r2_val;
wire        regfile_w_enable;
wire [4:0]  regfile_w_reg;
wire [31:0] regfile_w_val;

regfile regfile(
    clk,
    regfile_r1_reg,
    regfile_r1_val,
    regfile_r2_reg,
    regfile_r2_val,
    regfile_w_enable,
    regfile_w_reg,
    regfile_w_val
);

wire [31:0] ex_pc_offset;
wire [31:0] ex_pc_base;
wire        ex_pc_valid;
wire        from_decode_to_fetch_stall;
wire [31:0] insn;
wire [31:0] pc_de;


fetch #(32'h34) fetch (
    clk,
    ex_pc_offset,
    ex_pc_base,
    ex_pc_valid,
    ram_r2_val,
    from_decode_to_fetch_stall,
    ram_r2_addr,
    insn,
    pc_de
);

wire        from_ex_to_decode_stall;
wire [4:0]  rd;
wire [3:0]  alu_code;
wire [31:0] imm;
wire        ex_use_imm;
wire [4:0]  rs1_reg;
wire [4:0]  rs2_reg;
wire [3:0]  insn_type_decode2exec;
wire [3:0]  insn_sub_type_decode2exec;
wire [31:0] pc_ex;

decoder decoder(
    clk,
    insn,
    pc_de,
    from_ex_to_decode_stall,
    regfile_r1_reg,
    regfile_r2_reg,
    rd,
    alu_code,
    pc_ex,
    imm,
    ex_use_imm,
    rs1_reg,
    rs2_reg,
    insn_type_decode2exec,
    insn_sub_type_decode2exec,
    from_decode_to_fetch_stall
);

wire [4:0]  wb_ex_bypass_reg;
wire [31:0] wb_ex_bypass_val;
wire [4:0]  mem_ex_bypass_reg;
wire [31:0] mem_ex_bypass_val;
wire [31:0] ex2mem_val;
wire [4:0]  rd_ex;
wire [31:0] ex_store_val;
wire [3:0]  ex2mem_insn_type;
wire [3:0]  ex2mem_insn_sub_type;

exec exec(
    clk,
    insn_type_decode2exec,
    insn_sub_type_decode2exec,
    alu_code,
    rs1_reg,
    regfile_r1_val,
    rs2_reg,
    regfile_r2_val,
    pc_ex,
    imm,
    ex_use_imm,
    wb_ex_bypass_reg,
    wb_ex_bypass_val,
    mem_ex_bypass_reg,
    mem_ex_bypass_val,
    rd,
    ex2mem_val,
    rd_ex,
    ex_pc_offset,
    ex_pc_base,
    ex_pc_valid,
    ex_store_val,
    ex2mem_insn_type,
    ex2mem_insn_sub_type,
    from_ex_to_decode_stall
);

wire [4:0]  wb_reg;
wire [31:0] wb_val;
wire        use_mem_output;
wire [3:0]  mem2wb_insn_type;

mem mem(
    clk,
    ex2mem_insn_type,
    ex2mem_insn_sub_type,
    ex2mem_val,
    ex_store_val,
    rd_ex,
    wb_reg,
    wb_val,
    mem_ex_bypass_reg,
    mem_ex_bypass_val,
    ram_r1_addr,
    ram_w_addr,
    ram_w_val,
    ram_w_byte_en,
    ram_w_enable,
    use_mem_output,
    mem2wb_insn_type
);

writeback writeback(
    clk,
    mem2wb_insn_type,
    wb_reg,
    wb_val,
    ram_r1_val,
    regfile_w_reg,
    regfile_w_enable,
    regfile_w_val,
    wb_ex_bypass_reg,
    wb_ex_bypass_val
);


endmodule
