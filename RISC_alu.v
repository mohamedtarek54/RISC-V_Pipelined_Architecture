module RISC_alu(
input wire [31:0] SrcA,
input wire [31:0] SrcB,
input wire [2:0] AluControl,

output wire Zero,
output reg [31:0] AluResult
);

always@(*) begin
	case(AluControl)
	3'b000: AluResult = SrcA + SrcB;
	3'b001: AluResult = SrcA - SrcB;
	3'b010: AluResult = SrcA & SrcB;
	3'b011: AluResult = SrcA | SrcB;
	3'b101: AluResult = (SrcA<SrcB)? 32'b1 : 32'b0;
	default: AluResult = 32'b0;
	endcase
end

assign Zero = (AluControl==3'b001 && AluResult == 32'b0) ? 1'b1 : 1'b0;
endmodule
