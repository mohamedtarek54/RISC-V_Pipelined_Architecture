module RISC_data_path(
input wire clk,
input wire rst,
input wire RegWrite,
input wire [1:0] ResultSrc,
input wire MemWrite,
input wire Branch,
input wire [2:0] AluControl,
input wire AluSrc,
input wire [1:0] ImmSrc,
input wire [1:0] ForwardAE,
input wire [1:0] ForwardBE,
input wire 		 StallF,
input wire 		 StallD,
input wire 		 FlushE,
input wire 		 FlushD,

output wire [6:0] op,
output wire [2:0] funct3,
output wire funct7,
output wire [4:0] Rs1E,
output wire [4:0] Rs2E,
output wire [4:0] RdM,
output wire [4:0] RdW,
output wire [4:0] Rs1D,
output wire [4:0] Rs2D,
output wire [4:0] RdE,
output wire ResultSrcE0,
output wire PCSrcE,
output wire RegWriteM,
output wire RegWriteW
);

localparam MEM_DEPTH = 64, INSTR_DEPTH = 64;
// ---------------------------------------------
// --------------- FETCH STAGE -----------------
// ---------------------------------------------

wire [31:0] PCF, PCPlus4F, pcNext, ALUResultM;
RISC_pc #(.WIDTH(32)) u_pc (
.clk(clk),
.rst(rst),
.en(~StallF),
.pc_next(pcNext),

.pc(PCF)
);

RISC_add_4 u_add_4 (
.PC(PCF),

.PCPlus4(PCPlus4F)
);

wire [31:0] Instr;
RISC_instruction_mem #(.WIDTH(32), .DEPTH(INSTR_DEPTH)) u_instr_mem (
.addr(PCF>>2),

.RD(Instr)
);

// register fetch stage output 
wire [31:0] InstrD, PCD, PCPlus4D;
flop #(.WIDTH(32)) u_rd_flop (.clk(clk), .rst(FlushD), .en(~StallD), .d(Instr), .q(InstrD));
flop #(.WIDTH(32)) u_pcd_flop (.clk(clk), .rst(FlushD), .en(~StallD), .d(PCF), .q(PCD));
flop #(.WIDTH(32)) u_pc4d_flop (.clk(clk), .rst(FlushD), .en(~StallD), .d(PCPlus4F), .q(PCPlus4D));

// ---------------------------------------------
// -------------- DECODE STAGE -----------------
// ---------------------------------------------

wire [31:0] ResultW, RD1, RD2;
RISC_reg_file u_reg_file (
.clk(clk),
.rst(rst),
.WE3(RegWriteW),
.A1(InstrD[19:15]),
.A2(InstrD[24:20]),
.A3(RdW),
.WD3(ResultW),

.RD1(RD1),
.RD2(RD2)
);

wire [31:0] ImmExtD;
RISC_extend u_extend(
.Imm(InstrD[31:7]),
.ImmSrc(ImmSrc),

.ImmExt(ImmExtD)
);

// register decode stage outputs
wire [31:0] RD1E, RD2E, PCE, ImmExtE,PCPlus4E;
wire [1:0] ResultSrcE;
wire [2:0] AluControlE;
wire MemWriteE;
flop #(.WIDTH(32)) u_rf1_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(RD1), .q(RD1E));
flop #(.WIDTH(32)) u_rf2_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(RD2), .q(RD2E));
flop #(.WIDTH(32)) u_pce_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(PCD), .q(PCE));
flop #(.WIDTH(32)) u_immexte_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(ImmExtD), .q(ImmExtE));
flop #(.WIDTH(32)) u_pc4e_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(PCPlus4D), .q(PCPlus4E));
flop #(.WIDTH(5)) u_rde_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(InstrD[11:7]), .q(RdE));
// register control signals
flop #(.WIDTH(1)) u_c_rwe_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(RegWrite), .q(RegWriteE));
flop #(.WIDTH(2)) u_c_rse_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(ResultSrc), .q(ResultSrcE));
flop #(.WIDTH(1)) u_c_mwe_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(MemWrite), .q(MemWriteE));
flop #(.WIDTH(1)) u_c_be_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(Branch), .q(BranchE));
flop #(.WIDTH(3)) u_c_alue_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(AluControl), .q(AluControlE));
flop #(.WIDTH(1)) u_c_aluse_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(AluSrc), .q(AluSrcE));
// register instruction sources for hazard unit
flop #(.WIDTH(5)) u_rs1e_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(InstrD[19:15]), .q(Rs1E));
flop #(.WIDTH(5)) u_rs2e_flop (.clk(clk), .rst(FlushE), .en(1'b1), .d(InstrD[24:20]), .q(Rs2E));
// ---------------------------------------------
// -------------- EXECUTE STAGE ----------------
// ---------------------------------------------

wire [31:0] WriteDataE = (ForwardBE[1]) ? ALUResultM : ((ForwardBE[0])? ResultW:RD2E);
wire [31:0] SrcAE = (ForwardAE[1]) ? ALUResultM : ((ForwardAE[0]) ? ResultW : RD1E);
wire [31:0] SrcBE = (AluSrcE) ? ImmExtE : WriteDataE;
wire [31:0] ALUResultE, PCTargetE;
wire ZeroE;
assign PCSrcE = ZeroE & BranchE;

RISC_alu u_alu (
.SrcA(SrcAE),
.SrcB(SrcBE),
.AluControl(AluControlE),

.Zero(ZeroE),
.AluResult(ALUResultE)
);

RISC_add u_add(
.PC(PCE),
.ImmExt(ImmExtE),

.PCTarget(PCTargetE)
);

// register execute stage outputs
wire [31:0] WriteDataM, PCPlus4M;
wire MemWriteM;
wire [1:0] ResultSrcM;
flop #(.WIDTH(32)) u_alum_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(ALUResultE), .q(ALUResultM));
flop #(.WIDTH(32)) u_rd2m_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(RD2E), .q(WriteDataM));
flop #(.WIDTH(32)) u_pc4m_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(PCPlus4E), .q(PCPlus4M));
flop #(.WIDTH(5)) u_rdm_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(RdE), .q(RdM));
// register control signals
flop #(.WIDTH(1)) u_c_rwm_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(RegWriteE), .q(RegWriteM));
flop #(.WIDTH(2)) u_c_rsm_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(ResultSrcE), .q(ResultSrcM));
flop #(.WIDTH(1)) u_c_mwm_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(MemWriteE), .q(MemWriteM));
// ---------------------------------------------
// --------------- MEMORY STAGE ----------------
// ---------------------------------------------
wire [31:0] ReadDataM;

RISC_data_mem#(.WIDTH(32), .DEPTH(MEM_DEPTH)) u_data_mem (
.clk(clk),
.WE(MemWriteM),
.A(ALUResultM>>2), // intentional
.WD(WriteDataM),

.RD(ReadDataM)
);

// register memory stage outputs
wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
flop #(.WIDTH(32)) u_aluw_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(ALUResultM), .q(ALUResultW));
flop #(.WIDTH(32)) u_memw_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(ReadDataM), .q(ReadDataW));
flop #(.WIDTH(32)) u_pc4w_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(PCPlus4M), .q(PCPlus4W));
flop #(.WIDTH(5)) u_rdw_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(RdM), .q(RdW));
// register control signals
wire [1:0] ResultSrcW;
flop #(.WIDTH(1)) u_c_rww_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(RegWriteM), .q(RegWriteW));
flop #(.WIDTH(2)) u_c_rsw_flop (.clk(clk), .rst(~rst), .en(1'b1), .d(ResultSrcM), .q(ResultSrcW));
// ---------------------------------------------
// ------------- WRITE-BACK STAGE --------------
// ---------------------------------------------

assign ResultW = (ResultSrcW[1]) ? PCPlus4W : ((ResultSrcW[0])?ReadDataW:ALUResultW);

assign pcNext = (PCSrcE) ? PCTargetE : PCPlus4F;




// assign outputs
assign op			= InstrD[6:0];
assign funct3		= InstrD[14:12];
assign funct7		= InstrD[30];
assign Rs1D			= InstrD[19:15];
assign Rs2D			= InstrD[24:20];
assign ResultSrcE0	= ResultSrc[0];

endmodule
