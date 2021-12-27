// mem.v

`include "exec_insn_types.v"

module mem(
    input wire        clk,
    input wire [3:0]  insn_type,
    input wire [3:0]  insn_sub_type,
    input wire [31:0] ex_val,
    input wire [31:0] store_val,
    input wire [4:0]  wb_reg,

    output reg [4:0]  wb_reg_r,
    output reg [31:0] wb_val,
    output reg [4:0]  bp_mem_reg,
    output reg [31:0] bp_mem_val,
    output reg [29:0] ram_r_addr,
    output reg [29:0] ram_w_addr,
    output reg [31:0] ram_w_data,
    output reg [3:0]  ram_byte_en,
    output reg        ram_w_en,
    output reg        use_mem_output,
    output reg [3:0]  insn_type_r
);

always @(posedge clk) begin
    wb_val <= ex_val;
    wb_reg_r <= wb_reg;
    insn_type_r <= insn_type;
end

always @(posedge clk) begin
    bp_mem_reg <= 0;
    bp_mem_val <= 0;
    case (insn_type)
        `L_TYPE: begin
            use_mem_output <= 1;
            ram_w_en <= 0;
            ram_r_addr <= ex_val[31:2];
        end
        `S_TYPE: begin
            use_mem_output <= 0;
            ram_w_en <= 1;
            ram_w_addr <= ex_val[31:2];
            case (insn_sub_type)
                `S_W: begin
                    ram_byte_en <= 4'b1111;
                    ram_w_data <= store_val;
                end
                `S_H: begin
                    case (ex_val[1:0])
                        2'b00 : begin
                            ram_byte_en <= 4'b0011;
                            ram_w_data <= store_val;
                        end
                        2'b10: begin
                            ram_byte_en <= 4'b1100;
                            ram_w_data <= store_val << 16;
                        end
                        default: $display("bad ma");
                    endcase
                end
                `S_B: begin
                    case (ex_val[1:0])
                        2'b00: begin
                            ram_byte_en <= 4'b0001;
                            ram_w_data <= store_val;
                        end
                        2'b01: begin
                            ram_byte_en <= 4'b0010;
                            ram_w_data <= store_val << 8;
                        end
                        2'b10: begin
                            ram_byte_en <= 4'b0100;
                            ram_w_data <= store_val << 16;
                        end
                        2'b11: begin
                            ram_byte_en <= 4'b1000;
                            ram_w_data <= store_val << 24;
                        end
                        default: $display("bad ma");
                    endcase
                end
            endcase
        end
        default: begin
            use_mem_output <= 0;
            wb_val <= ex_val;
            wb_reg_r <= wb_reg;
            ram_w_en <= 0;
        end
    endcase
end

endmodule
