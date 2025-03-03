module decoder (
	clk,
	rst_n,
	instr,
	pc_inc_2,
	// RegWrite,
	writeData,
	read_data_1,
	read_data_2,
	pc_inc_2_out,
	instr_sign_extended,

	// Control signals
	ALUSrc,
	ALU_operation,
	PCSrc,
	memWrite,
	memRead,
	MemtoReg
);

	// inputs
	input clk;
	input rst_n;
	input [15:0] instr;
	input [15:0] pc_inc_2;
	input [15:0] writeData;

	// decoder signal
	wire RegWrite;

	// outputs
	output [15:0] read_data_1;
	output [15:0] read_data_2;
	output [15:0] pc_inc_2_out;
	output [15:0] instr_sign_extended;

	// control signal outputs
   	// decoder
    // output RegWrite;
 	
 	// execute
    output ALUSrc;
	output [3:0] ALU_operation;

	// memory
	output PCSrc;
	output memWrite;
	output memRead;

	// writeback
	output MemtoReg;

	// interal nets
	wire internal_RegWrite;
    wire internal_ALUSrc;
    wire [3:0] internal_ALU_operation;
    wire internal_PCSrc;
    wire internal_memWrite;
    wire internal_memRead;
    wire internal_MemtoReg;

	RegisterFile regFile0(
		.clk(clk),
		.rst(rst_n),
		.WriteReg(RegWrite),
		.SrcReg1(instr[7:4]),
		.SrcReg2(instr[3:0]),
		.DstReg(instr[11:8]),
		.DstData(writeData),
		.SrcData1(read_data_1),
		.SrcData2(read_data_2)
	);

    control_signals decode_instruction0 (
        .instr(instr),
        .RegWrite(internal_RegWrite),
        .memRead(internal_memRead),
        .memWrite(internal_memWrite),
        .ALUSrc(internal_ALUSrc),
        .ALU_operation(internal_ALU_operation),
        .PCSrc(internal_PCSrc),
        .MemtoReg(internal_MemtoReg)
    );

    // pass decoder signals
    assign RegWrite = internal_RegWrite;
    assign ALUSrc = internal_ALUSrc;
    assign ALU_operation = internal_ALU_operation;
    assign PCSrc = internal_PCSrc;
    assign memWrite = internal_memWrite;
    assign memRead = internal_memRead;
    assign MemtoReg = internal_MemtoReg;

	assign pc_inc_2_out = pc_inc_2;
	assign instr_sign_extended = {{7{instr[8]}}, instr[8:0]};

endmodule
