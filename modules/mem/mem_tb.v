// mem_tb.v

`timescale 1 ns/10 ps

module mem_tb;

reg clk = 0;
always #5 clk <= ~clk;

reg [29:0] r1_addr;
wire [31:0] r1_val;

reg [29:0] r2_addr;
wire [31:0] r2_val;

reg w_enable;
reg [29:0] w_addr;
reg [31:0] w_val;
reg [3:0] byte_en;

mem mem(
    clk,
    r1_addr,
    r1_val,
    r2_addr,
    r2_val,
    w_enable,
    w_addr,
    w_val,
    byte_en
);

integer cnt = 0;

initial begin
    $display("MEM TEST\n");

    w_enable = 1;
    w_addr = 30'h7000;
    byte_en = 4'b1111;
    w_val = 32'hDEADBEEF;
    #10
    $display("w %h to %h with mask %b", w_val, w_addr, byte_en);

    w_enable = 0;
    r1_addr = w_addr;
    #10

    $display("r %h from %h (0xDEADBEEF expected)", r1_val, r1_addr);
    if (r1_val == w_val) begin
        cnt = cnt + 1;
        $display("Test 1 ok!\n");
    end
    else
        $display("Test 1 fail!\n");

    w_enable = 1;
    byte_en = 4'b0011;
    w_val = 32'h0000C0DE;
    #10

    $display("w %h to %h with mask %b", w_val, w_addr, byte_en);

    w_enable = 0;
    #10

    $display("r %h from %h (0xDEADC0DDE expected)", r1_val, r1_addr);
    if (r1_val == 32'hDEADC0DE) begin
        cnt = cnt + 1;
        $display("Test 2 ok!\n");
    end
    else
        $display("Test 2 fail!\n");

    if (cnt == 2)
        $display("TEST OK!");
    else
        $display("TEST FAIL!");

    $finish; 
end

endmodule