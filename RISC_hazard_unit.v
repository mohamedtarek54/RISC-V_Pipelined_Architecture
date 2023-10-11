module RISC_hazard_unit(
input wire [4:0] Rs1E,
input wire [4:0] Rs2E,
input wire [4:0] RdM,
input wire [4:0] RdW,
input wire 		 RegWriteM,
input wire 		 RegWriteW,
input wire [4:0] Rs1D,
input wire [4:0] Rs2D,
input wire [4:0] RdE,
input wire ResultSrcE0,
input wire PCSrcE,

output reg [1:0] ForwardAE,
output reg [1:0] ForwardBE,
output wire		 StallF,
output wire		 StallD,
output wire		 FlushE,
output wire		 FlushD
);

// ForwardAE logic
always@(*) begin
	if((Rs1E == RdM) & RegWriteM & (Rs1E != 4'b0))
		ForwardAE = 2'b10;
	else if((Rs1E == RdW) & RegWriteW & (Rs1E != 4'b0))
		ForwardAE = 2'b01;
	else
		ForwardAE = 2'b00;
end

// ForwardBE logic
always@(*) begin
	if((Rs2E == RdM) & RegWriteM & (Rs2E != 4'b0))
		ForwardBE = 2'b10;
	else if((Rs2E == RdW) & RegWriteW & (Rs2E != 4'b0))
		ForwardBE = 2'b01;
	else
		ForwardBE = 2'b00;
end

// stall and flush logic
wire lwStall = ResultSrcE0 & ((Rs1D==RdE) | (Rs2D==RdE));
assign StallF = lwStall;
assign StallD = lwStall;
assign FlushE = lwStall | PCSrcE;
assign FlushD = PCSrcE;
endmodule
