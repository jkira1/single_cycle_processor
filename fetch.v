module fetch (	
	clk,
	rst_n,
	pc,
	pc_inc_2,
	instr
);
	
	input clk;
	input rst_n;
	input [15:0] pc;

	output [15:0] pc_inc_2;
	output [15:0] instr;

	wire [15:0] pc_add;

	memory1c instruction_memory(
		.clk(clk), 
		.rst(~rst_n), 
		.enable(1'b1), 
		.wr(1'b0), 
		.addr(pc), 
		.data_in(16'b0), 
		.data_out(instr)
	);

	assign pc_add = pc + 2;

	// temporary flop for debugging
	dff ff[15:0](
		.clk(clk),
		.rst(~rst_n),
		.q(pc_inc_2),
		.d(pc_add),
		.wen(1'b1)
	);

endmodule
