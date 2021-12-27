// run.v

`timescale 1ps/1ps

module run;

reg clk = 0;
always #5 clk <= ~clk;

top soc(clk);

initial begin
    #600
    $finish;
end

endmodule
