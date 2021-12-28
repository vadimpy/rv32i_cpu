// run.v

`timescale 1ps/1ps

module run;

reg clk = 0;
always #5 clk <= ~clk;

top soc(clk);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,run);
    #600
    $finish;
end

endmodule
