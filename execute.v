module execute (
	clk,
	rst_n,
	instr_sign_extended,
	pc_inc_2,
	read_data_1,
	read_data_2,
	pc_inc_2_out,
	pc_branch,
	PCSrc,
	ALUSrc,
	ALU_operation,
	aluResult,
	writeData
);

	/*
	ADD 0000
	SUB 0001
	XOR 0010
	RED 0011
	SLL 0100
	SRA 0101
	ROR 0110
	PADDSB 0111
	LW 1000
	SW 1001
	LLB 1010
	LHB 1011
	B 1100
	BR 1101
	PCS 1110
	HLT 1111
	*/

	// inputs
	input clk;
	input rst_n;
	input [15:0] instr_sign_extended;
	input [15:0] pc_inc_2;
	input [15:0] read_data_1;
	input [15:0] read_data_2;

	// decoder signals
	input ALUSrc;
	input [3:0] ALU_operation;
	input PCSrc;

	// outputs
	output [15:0] pc_inc_2_out;
	output [15:0] pc_branch;
	output [15:0] aluResult;
	output [15:0] writeData;

endmodule
