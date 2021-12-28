// writeback.v

`include "exec_insn_types.v"

module writeback(
    input wire        clk,
    input wire [3:0]  insn_type,
    input wire [4:0]  rd,
    input wire [31:0] ex_val,
    input wire [31:0] mem_r_data,
    output reg [4:0]  regfile_w_reg,
    output wire       regfile_w_en,
    output reg [31:0] regfile_w_data,
    output reg [4:0]  wb_bp_reg,
    output reg [31:0] wb_bp_val
);

assign regfile_w_en = 1;

always @(*) begin
    wb_bp_reg <= rd;
    regfile_w_reg <= rd;
    // $display("wb rd %d", rd);
    case (insn_type)
        `L_TYPE: begin
            regfile_w_data <= mem_r_data;
            wb_bp_val <= mem_r_data;
            // $display("val = %h\n", mem_r_data);
        end
        default: begin
            regfile_w_data <= ex_val;
            wb_bp_val <= ex_val;
        end
    endcase
end

endmodule
