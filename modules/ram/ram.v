// ram.v

module ram(
    // clk
    input wire clk,

    // read 1
    input wire [29:0] r1_addr,
    output reg [31:0] r1_val,

    // read 2
    input wire [29:0] r2_addr,
    output reg [31:0] r2_val,

    // write
    input wire w_enable,
    input wire [29:0] w_addr,
    input wire [31:0] w_val,
    input wire [3:0] byte_en
);

reg [31:0] data [0 : 499];

integer i;

initial begin
    $display("Loading ELF...");
    $readmemh("/Users/vadimpy/dev/hard/rv32i_cpu/c_test/simple.hex", data);
    $display("ELF was loaded");
end

// debug
// always @(posedge clk) begin
//     $display("print: %d", data[0]);
// end

// read
always @(posedge clk) begin
    r1_val <= data[r1_addr];
    r2_val <= data[r2_addr];
end

// write
always @(posedge clk) begin
    if (byte_en[0])
        data[w_addr][7:0] <= w_val[7:0];
    if (byte_en[1])
        data[w_addr][15:8] <= w_val[15:8];
    if (byte_en[2])
        data[w_addr][23:16] <= w_val[23:16];
    if (byte_en[3])
        data[w_addr][31:24] <= w_val[31:24];
end

endmodule