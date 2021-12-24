// regfile_tb.v

`timescale 1 ns/10 ps

module regfile_tb;

reg clk = 0;
always #5 clk <= ~clk;

reg [4:0] r1_reg_name;
wire [31:0] r1_reg_val;

reg [4:0] r2_reg_name;
wire [31:0] r2_reg_val;

reg w_enable = 0;
reg [4:0] w_reg_name;
reg [31:0] w_reg_val;

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

integer cnt = 0;

initial begin
    r1_reg_name <= 0;
    r2_reg_name <= 0;

    #10 // clock front
    $display("p1 r %d = %x (0 expected)", r1_reg_name, r1_reg_val);
    $display("p2 r %d = %x (0 expected)", r2_reg_name, r2_reg_val);
    if (r1_reg_val == 0) begin
        cnt = cnt + 1;
        $display("p1 read zero ok!");
    end

    if (r2_reg_val == 0) begin
        cnt = cnt + 1;
        $display("p2 read zero ok!");
    end

    $display("");

    w_reg_name = 5;
    w_reg_val = 42;
    w_enable = 1;

    #10 // clock front
    $display("w %d = %x ", w_reg_name, w_reg_val);

    w_reg_name = 3;
    w_reg_val = 53;

    #10 // clock front
    $display("w %d = %x", w_reg_name, w_reg_val);

    $display("");

    w_enable = 0;
    r1_reg_name = 5;
    r2_reg_name = 3;

    #10 // clock front
    $display("p1 r %d = %x (%x expected)", r1_reg_name, r1_reg_val, 42);
    $display("p2 r %d = %x (%x expected)", r2_reg_name, r2_reg_val, 53);

    if (r1_reg_val == 42) begin
        cnt = cnt + 1;
        $display("p1 read after write ok!");
    end
    if (r2_reg_val == 53) begin
        cnt = cnt + 1;
        $display("p2 read after write ok!");
    end

    if (cnt == 4)
        $display("\nTEST OK!");
    else
        $display("\nTEST FAIL!");

    $finish;        
end

endmodule
