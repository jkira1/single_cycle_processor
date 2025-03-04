// module cpu (
// 	clk,
// 	rst_n,
// 	hlt,
// 	pc_out
// );

// 	input clk;
// 	input rst_n;

// 	output hlt;
// 	output [15:0] pc_out;

	
// 	// fetch
// 	wire [15:0] pc_inc_2;
//     wire [15:0] instr;

// 	fetch fetch0(
// 		.clk(clk), 
// 		.rst_n(rst_n), 
// 		.pc(pc_inc_2), 
// 		.pc_inc_2(pc_inc_2), 
// 		.instr(instr)
// 	);

// 	assign pc_out = pc_inc_2;

// endmodule

module cpu (
	clk,
	rst_n,
	hlt,
	pc_out
);

	input clk;
	input rst_n;

	output hlt;
	output [15:0] pc_out;

	// Fetch stage signals
	wire [15:0] pc_inc_2;
	wire [15:0] instr;

	// Decoder stage signals
	wire [15:0] read_data_1;
	wire [15:0] read_data_2;
	wire [15:0] pc_inc_2_out;
	wire [15:0] instr_sign_extended;

	// Control signals
	wire ALUSrc;
	wire [3:0] ALU_operation;
	wire PCSrc;
	wire memWrite;
	wire memRead;
	wire MemtoReg;

	// Execute stage signals
	wire [15:0] pc_branch;
	wire [15:0] aluResult;
	wire [15:0] writeData;
	// wire [15:0] pc_inc_2_mem;
	wire Z, V, N;

	// Memory Access stage signals
	wire [15:0] readData;
	wire [15:0] alu_out;
	wire [15:0] pc_select;

	// Writeback stage signals
	wire [15:0] write_reg_data;

	// Fetch stage
	fetch fetch0 (
		.clk(clk), 
		.rst_n(rst_n), 
		.pc(pc_out), 
		.pc_inc_2(pc_inc_2), 
		.instr(instr)
	);

	// Decode stage
	decoder decoder0 (
		.clk(clk),
		.rst_n(rst_n),
		.instr(instr),
		.pc_inc_2(pc_inc_2),
		.writeData(write_reg_data),  // Data to be written to the register file
		.read_data_1(read_data_1),
		.read_data_2(read_data_2),
		.pc_inc_2_out(pc_inc_2_out),
		.instr_sign_extended(instr_sign_extended),

		// Control signals
		.ALUSrc(ALUSrc),
		.ALU_operation(ALU_operation),
		.PCSrc(PCSrc),
		.memWrite(memWrite),
		.memRead(memRead),
		.MemtoReg(MemtoReg),
		.hlt(hlt)
	);

	// // Execute stage
	execute execute0 (
		.clk(clk),
		.rst_n(rst_n),
		.instr_sign_extended(instr_sign_extended),
		.pc_inc_2(pc_inc_2),
		.read_data_1(read_data_1),
		.read_data_2(read_data_2),
		.pc_inc_2_out(),
		.pc_branch(pc_branch),
		.PCSrc(PCSrc),
		.ALUSrc(ALUSrc),
		.ALU_operation(ALU_operation),
		.aluResult(aluResult),
		.writeData(writeData),
		.Z(Z),
		.V(V),
		.N(N)
	);

	// Memory Access stage
	memoryaccess memoryaccess0 (
		.clk(clk),
		.rst_n(rst_n),
		.pc_inc_2(pc_inc_2),
		.pc_branch(pc_branch),
		.pc_out(pc_select),
		.PCSrc(PCSrc),
		.aluResult(aluResult),
		.writeData(writeData),
		.memWrite(memWrite),
		.memRead(memRead),
		.readData(readData),
		.alu_out(alu_out)
	);	

	// Writeback stage
	writeback writeback0(
		.clk(clk),
		.rst_n(rst_n),
		.instr(instr),
		.read_data(readData),
		.alu_out(alu_out),
		.MemtoReg(MemtoReg),
		.write_reg_data(write_reg_data)
	);

	assign pc_out = pc_select;

endmodule
