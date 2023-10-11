module RISC_top(
input wire clk,
input wire rst
);

// control unit signals
wire [6:0] op;
wire [2:0] funct3;
wire [2:0] aluControl;
wire [1:0] immSrc;
wire [1:0] resultSrc;

// hazard unit signals
wire [1:0] ForwardAE, ForwardBE;
wire [4:0] Rs1E, Rs2E, RdM, RdW, Rs1D, Rs2D, RdE;

RISC_control_path u_control_path (
.op(op),
.funct3(funct3),
.funct7(funct7),

.Branch(Branch),
.resultSrc(resultSrc),
.memWrite(memWrite),
.aluControl(aluControl),
.aluSrc(aluSrc),
.immSrc(immSrc),
.regWrite(regWrite)
);


RISC_data_path u_data_path (
.clk(clk),
.rst(rst),
.Branch(Branch),
.ResultSrc(resultSrc),
.MemWrite(memWrite),
.AluControl(aluControl),
.AluSrc(aluSrc),
.ImmSrc(immSrc),
.RegWrite(regWrite),
.ForwardAE(ForwardAE),
.ForwardBE(ForwardBE),
.StallF(StallF),
.StallD(StallD),
.FlushE(FlushE),
.FlushD(FlushD),

.op(op),
.funct3(funct3),
.funct7(funct7),
.Rs1E(Rs1E),
.Rs2E(Rs2E),
.RdM(RdM),
.RdW(RdW),
.Rs1D(Rs1D),
.Rs2D(Rs2D),
.RdE(RdE),
.ResultSrcE0(ResultSrcE0),
.PCSrcE(PCSrcE),
.RegWriteM(RegWriteM),
.RegWriteW(RegWriteW)
);

RISC_hazard_unit u_hazard_unit (
.Rs1E(Rs1E),
.Rs2E(Rs2E),
.RdM(RdM),
.RdW(RdW),
.RegWriteM(RegWriteM),
.RegWriteW(RegWriteW),
.Rs1D(Rs1D),
.Rs2D(Rs2D),
.RdE(RdE),
.ResultSrcE0(ResultSrcE0),
.PCSrcE(PCSrcE),

.ForwardAE(ForwardAE),
.ForwardBE(ForwardBE),
.StallF(StallF),
.StallD(StallD),
.FlushE(FlushE),
.FlushD(FlushD)
);
endmodule
