module RISC_pc #(parameter WIDTH = 32)(
input wire clk,
input wire rst,
input wire en,
input wire [WIDTH-1:0] pc_next,

output reg [WIDTH-1:0] pc
);

always @(posedge clk or negedge rst) begin
if(!rst)
	pc <= 'b0;
else if(en)
	pc <= pc_next;
end

endmodule
