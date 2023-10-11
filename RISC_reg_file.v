module RISC_reg_file(
input wire clk,
input wire rst,
input wire WE3,
input wire [4:0] A1,
input wire [4:0] A2,
input wire [4:0] A3,
input wire [31:0] WD3,

output wire [31:0] RD1,
output wire [31:0] RD2
);

reg [31:0] reg_file [31:0];
integer i;

// write on falling edge of clock
always @ (negedge clk) begin
if(!rst) begin
	for(i=0; i<32; i=i+1) begin
		reg_file[i] <= 32'b0;
	end
end
else if(WE3)
	reg_file[A3] <= WD3;
	
end

assign RD1 = reg_file[A1];
assign RD2 = reg_file[A2];
endmodule
