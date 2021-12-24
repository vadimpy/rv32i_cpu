// alu_tb.v

`timescale 1ps/1ps

`include "alu_codes.v"

module alu_tb;

reg [3:0] alu_code;
reg [31:0] op1;
reg [31:0] op2;
wire [31:0] res;

alu alu(
    alu_code,
    op1,
    op2,
    res
);

integer test_cnt = 0;
integer expected = 0;

initial begin
    alu_code = `NONE;
    expected = 0;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("NONE ok!");
        test_cnt = test_cnt + 1;
    end
    #1

    alu_code = `ADD;
    op1 = 123;
    op2 = 7;
    expected = 130;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("ADD ok!");
        test_cnt = test_cnt + 1;
    end
    #1

    alu_code = `SUB;
    op1 = 123;
    op2 = 125;
    expected = -2;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("SUB ok!");
        test_cnt = test_cnt + 1;
    end
    #1
    
    alu_code = `LS;
    op1 = 3;
    op2 = 2;
    expected = 12;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("LS ok!");
        test_cnt = test_cnt + 1;
    end
    #1

    alu_code = `RSA;
    op1 = -16;
    op2 = 2;
    expected = -4;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("RSA ok!");
        test_cnt = test_cnt + 1;
    end
    #1

    alu_code = `RSL;
    op1 = 32'b11111111_11111111_11111111_11111111;
    op2 = 2;
    expected = 32'b00111111_11111111_11111111_11111111;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("RSL ok!");
        test_cnt = test_cnt + 1;
    end

    alu_code = `CMP;
    op1 = -2;
    op2 = 2;
    expected = 32'b10;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("CMP ok!");
        test_cnt = test_cnt + 1;
    end

    alu_code = `CMPU;
    op1 = -2;
    op2 = 2;
    expected = 32'b00;
    #1
    $display("\n------------\n");
    $display("alu_code: %b", alu_code);
    $display("op1: d %d b %b", op1, op1);
    $display("op2: d %d b %b", op2, op2);
    $display("res: d %d b %b", res, res);
    $display("expected: d %d b %b", expected, expected);
    if (expected == res) begin
        $display("CMPU ok!");
        test_cnt = test_cnt + 1;
    end

    if (test_cnt == 8)
        $display("\nALU TESTS OK!");
    else
        $display("\nALU TESTS FAIL!"); 

end

endmodule
