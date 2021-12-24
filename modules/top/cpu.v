module cpu(
    input wire clk,
    
    // mem_r1_port
    output wire [31:0] mem_r1_addr,
    input wire [31:0] mem_r1_data,

    // mem_r2_port
    output wire [31:0] mem_r2_addr,
    input wire [31:0] mem_r2_data,

    // mem_w_port
    output wire mem_w_enable,
    output wire [31:0] mem_w_addr,
    output wire [3:0] mem_byte_en,
    output wire [31:0] mem_w_data,
);

regfile regfile(
    clk,
    r1_reg_name,
    r1_reg_val,
    r2_reg_name,
    r2_reg_val,
    w_enable,
    w_reg_name,
    w_reg_val
);

fetch fetch(
    clk,
    pc_ex_off,
    pc_ex_valid,
    mem_data,
    mem_addr,
    insn,
);

decoder decoder(
    clk,
    insn
    rs1,
    rs2,
    rd,
    alu_code
);

endmodule
