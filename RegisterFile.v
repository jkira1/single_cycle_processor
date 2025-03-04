module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, 
	input [3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

	// enables for reading + writing to and from registers using 1 hot
	wire [15:0] write_enable;
	wire [15:0] read_enable_1;
	wire [15:0] read_enable_2;

	// block of memory for all 16 registers
	wire [15:0] register_reads_1 [0:15];  
	wire [15:0] register_reads_2 [0:15];  
	
	// decode which register to write to if in writeback we write to register
	WriteDecoder_4_16 w_dec(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(write_enable));

	// decode which registers to read from (always reading)
	ReadDecoder_4_16 r_dec_0(.RegId(SrcReg1), .Wordline(read_enable_1));
	ReadDecoder_4_16 r_dec_1(.RegId(SrcReg2), .Wordline(read_enable_2));

	// instantiate all registers

	Register register_0(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[0]), 
		.ReadEnable1(read_enable_1[0]), 
		.ReadEnable2(read_enable_2[0]), 
		.Bitline1(register_reads_1[0]), 
		.Bitline2(register_reads_2[0])
	);

	Register register_1(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[1]), 
		.ReadEnable1(read_enable_1[1]), 
		.ReadEnable2(read_enable_2[1]), 
		.Bitline1(register_reads_1[1]), 
		.Bitline2(register_reads_2[1])
	);

	Register register_2(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[2]), 
		.ReadEnable1(read_enable_1[2]), 
		.ReadEnable2(read_enable_2[2]), 
		.Bitline1(register_reads_1[2]), 
		.Bitline2(register_reads_2[2])
	);

	Register register_3(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[3]), 
		.ReadEnable1(read_enable_1[3]), 
		.ReadEnable2(read_enable_2[3]), 
		.Bitline1(register_reads_1[3]), 
		.Bitline2(register_reads_2[3])
	);

	Register register_4(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[4]), 
		.ReadEnable1(read_enable_1[4]), 
		.ReadEnable2(read_enable_2[4]), 
		.Bitline1(register_reads_1[4]), 
		.Bitline2(register_reads_2[4])
	);

	Register register_5(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[5]), 
		.ReadEnable1(read_enable_1[5]), 
		.ReadEnable2(read_enable_2[5]), 
		.Bitline1(register_reads_1[5]), 
		.Bitline2(register_reads_2[5])
	);

	Register register_6(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[6]), 
		.ReadEnable1(read_enable_1[6]), 
		.ReadEnable2(read_enable_2[6]), 
		.Bitline1(register_reads_1[6]), 
		.Bitline2(register_reads_2[6])
	);

	Register register_7(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[7]), 
		.ReadEnable1(read_enable_1[7]), 
		.ReadEnable2(read_enable_2[7]), 
		.Bitline1(register_reads_1[7]), 
		.Bitline2(register_reads_2[7])
	);

		Register register_8(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[8]), 
		.ReadEnable1(read_enable_1[8]), 
		.ReadEnable2(read_enable_2[8]), 
		.Bitline1(register_reads_1[8]), 
		.Bitline2(register_reads_2[8])
	);

	Register register_9(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[9]), 
		.ReadEnable1(read_enable_1[9]), 
		.ReadEnable2(read_enable_2[9]), 
		.Bitline1(register_reads_1[9]), 
		.Bitline2(register_reads_2[9])
	);

	Register register_10(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[10]), 
		.ReadEnable1(read_enable_1[10]), 
		.ReadEnable2(read_enable_2[10]), 
		.Bitline1(register_reads_1[10]), 
		.Bitline2(register_reads_2[10])
	);

	Register register_11(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[11]), 
		.ReadEnable1(read_enable_1[11]), 
		.ReadEnable2(read_enable_2[11]), 
		.Bitline1(register_reads_1[11]), 
		.Bitline2(register_reads_2[11])
	);

	Register register_12(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[12]), 
		.ReadEnable1(read_enable_1[12]), 
		.ReadEnable2(read_enable_2[12]), 
		.Bitline1(register_reads_1[12]), 
		.Bitline2(register_reads_2[12])
	);

	Register register_13(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[13]), 
		.ReadEnable1(read_enable_1[13]), 
		.ReadEnable2(read_enable_2[13]), 
		.Bitline1(register_reads_1[13]), 
		.Bitline2(register_reads_2[13])
	);

	Register register_14(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[14]), 
		.ReadEnable1(read_enable_1[14]), 
		.ReadEnable2(read_enable_2[14]), 
		.Bitline1(register_reads_1[14]), 
		.Bitline2(register_reads_2[14])
	);

	Register register_15(
		.clk(clk),
		.rst(rst), 
		.D(DstData), 
		.WriteReg(write_enable[15]), 
		.ReadEnable1(read_enable_1[15]), 
		.ReadEnable2(read_enable_2[15]), 
		.Bitline1(register_reads_1[15]), 
		.Bitline2(register_reads_2[15])
	);

	// Use bypassing for read out (for single cycle don't use this)
    // assign SrcData1 = (WriteReg & (DstReg == SrcReg1)) ? DstData : register_reads_1[SrcReg1];
    // assign SrcData2 = (WriteReg & (DstReg == SrcReg2)) ? DstData : register_reads_2[SrcReg2];
    assign SrcData1 = register_reads_1[SrcReg1];
    assign SrcData2 = register_reads_2[SrcReg2];


endmodule
