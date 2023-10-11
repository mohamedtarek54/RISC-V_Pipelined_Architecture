module RISC_alu_decoder(
input wire [1:0] aluOp,
input wire [6:0] op,
input wire [2:0] funct3,
input wire funct7,

output reg [2:0] aluControl
);

always@(*) begin
	casex({aluOp, funct3, op[5], funct7})
	7'b00xxxxx: aluControl = 3'b000; 
	7'b01xxxxx: aluControl = 3'b001;
	7'b1000000,
	7'b1000001, 
	7'b1000010: aluControl = 3'b000;
	7'b1000011: aluControl = 3'b001;
	7'b10010xx: aluControl = 3'b101;
	7'b10110xx: aluControl = 3'b011;
	7'b10111xx: aluControl = 3'b010;
	default   : aluControl = 3'b000;
	endcase
end

endmodule
