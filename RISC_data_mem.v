module RISC_data_mem#(parameter WIDTH=32, DEPTH = 64, ADDR=$clog2(DEPTH))(
input wire clk,
input wire WE,
input wire [ADDR-1:0] A,
input wire [WIDTH-1:0] WD,

output wire [WIDTH-1:0] RD
);

reg [WIDTH-1:0] data_mem [DEPTH-1:0];

always@(posedge clk) begin
	if(WE)
		data_mem[A] <= WD;
end

assign RD = data_mem[A];

endmodule
