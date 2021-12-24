// alu.v

`include "alu_codes.v"

module alu(
    input  wire [3:0] alu_code,
    input  wire [31:0] op1,
    input  wire [31:0] op2,
    output wire [31:0] res
);

reg [31:0] xres;
assign res = xres;

always @* begin
    case (alu_code)
        `NONE : xres <= 32'h0;
        `ADD  : xres <= op1 + op2;
        `SUB  : xres <= op1 - op2;
        `LS   : xres <= op1 << op2;
        `RSL  : xres <= op1 >> op2;
        `RSA  : xres <= $signed(op1) >>> op2;
        `CMP  : xres <= { 30'h0, $signed(op1) < $signed(op2), op1 == op2 };
        `CMPU : xres <= { 30'h0, op1 < op2, op1 == op2 };
        `OR   : xres <= op1 | op2;
        `XOR  : xres <= op1 ^ op2;
        `AND  : xres <= op1 & op2;
    endcase
end

endmodule
