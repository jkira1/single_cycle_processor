module decoder (
	clk,
	rst_n,
	instr,
	pc_inc_2,
	RegWrite,
	writeData,
	read_data_1,
	read_data_2,
	pc_inc_2_out
);

	// inputs
	input clk;
	input rst_n;
	input [15:0] instr;
	input [15:0] pc_inc_2;
	input [15:0] writeData;

	// decoder signal
	input RegWrite;

	// outputs
	output [15:0] read_data_1;
	output [15:0] read_data_2;
	output [15:0] pc_inc_2_out;

endmodule
