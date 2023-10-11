module RISC_extend(
input wire [31:7] Imm,
input wire [1:0] ImmSrc,

output reg [31:0] ImmExt
);

always@(*) begin
case(ImmSrc)
2'b00: ImmExt = {{20{Imm[31]}}, Imm[31:20]};
2'b01: ImmExt = {{20{Imm[31]}}, Imm[31:25], Imm[11:7]};
2'b10: ImmExt = {{20{Imm[31]}}, Imm[7], Imm[30:25], Imm[11:8], 1'b0};
default: ImmExt = 32'bx;
endcase
end


endmodule
