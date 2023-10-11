module RISC_main_decoder(
input wire [6:0] op,

output wire branch,
output wire [1:0] resultSrc,
output wire memWrite,
output wire aluSrc,
output wire [1:0] immSrc,
output wire regWrite,
output wire [1:0] aluOp
);

localparam [6:0]	LW = 7'b0000011,
					SW = 7'b0100011,
					R  = 7'b0110011,
					BEQ= 7'b1100011,
					I  = 7'b0010011;

reg [9:0] controls;
assign {branch, resultSrc, memWrite, aluSrc, immSrc, regWrite, aluOp} = controls;


always@(*) begin
case(op)
	LW:		controls = 10'b1_01_0_1_00_1_00;
	SW:		controls = 10'b0_01_1_1_01_0_00;
	R:		controls = 10'b0_00_0_0_00_1_10;
	BEQ:	controls = 10'b1_10_0_0_10_0_01;
	I:		controls = 10'b0_00_0_1_00_1_10;
	default:controls = 10'b0_00_0_0_00_0_00;
endcase
end

endmodule
