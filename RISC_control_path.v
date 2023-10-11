module RISC_control_path(
input wire [6:0] op,
input wire [2:0] funct3,
input wire funct7,

output wire Branch,
output wire [1:0] resultSrc,
output wire memWrite,
output wire [2:0] aluControl,
output wire aluSrc,
output wire [1:0] immSrc,
output wire regWrite
);

wire [1:0] aluOp;

RISC_main_decoder u_main_decoder (
.op(op),

.branch(Branch),
.resultSrc(resultSrc),
.memWrite(memWrite),
.aluSrc(aluSrc),
.immSrc(immSrc),
.regWrite(regWrite),
.aluOp(aluOp)
);

RISC_alu_decoder u_alu_decoder (
.aluOp(aluOp),
.op(op),
.funct3(funct3),
.funct7(funct7),

.aluControl(aluControl)
);

endmodule
