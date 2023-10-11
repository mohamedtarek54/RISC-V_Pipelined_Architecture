module RISC_top_tb();

parameter PERIOD = 10;

reg clk_tb;
reg rst_tb;

always #(PERIOD/2)clk_tb = ~clk_tb;

initial begin
clk_tb = 1'b0;
rst_tb = 1'b0;
#PERIOD
rst_tb = 1'b1;

// initialize control signals
force u_top.u_data_path.StallD = 1'b0;
force u_top.u_data_path.PCSrcE = 1'b0;
#(3*PERIOD)
release u_top.u_data_path.StallD;
release u_top.u_data_path.PCSrcE;

#(35*PERIOD)
$finish;
end

// DUT
RISC_top u_top(
.clk(clk_tb),
.rst(rst_tb)
);

endmodule
