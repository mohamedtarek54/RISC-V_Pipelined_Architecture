module RISC_instruction_mem #(parameter WIDTH = 32, DEPTH = 64)(
input wire [WIDTH-1:0] addr,

output wire [WIDTH-1:0] RD
);

reg [WIDTH-1:0] instr_mem [0:DEPTH-1];

initial begin
	$readmemh("program.txt", instr_mem);
end

assign RD = instr_mem[addr];

endmodule
