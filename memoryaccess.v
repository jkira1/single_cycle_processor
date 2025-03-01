module memoryaccess (
	clk,
	rst_n,
	pc_inc_2,
	pc_branch,
	pc_out,
	PCSrc,
	aluResult,
	writeData,
	memWrite,
	memRead,
	readData,
	alu_out
);

	input clk;
	input rst_n;

	// pc mux
	input [15:0] pc_inc_2;
	input [15:0] pc_branch;

	// memory data
	input [15:0] aluResult;
	input [15:0] writeData;

	// decoder controls
	input PCSrc;
	input memWrite;
	input memRead;

	// outputs
	output [15:0] readData;
	output [15:0] alu_out;
	output [15:0] pc_out;

	memory1c memory0(
		.clk(clk), 
		.rst(~rst_n), 
		.enable(memRead), 
		.wr(memWrite), 
		.addr(aluResult), 
		.data_in(writeData), 
		.data_out(readData) 
	);

	
	assign pc_out = PCSrc ? pc_branch : pc_inc_2;

	assign alu_out = aluResult;

endmodule
