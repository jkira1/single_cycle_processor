module writeback (
	clk,
	rst_n,
	instr,
	read_data,
	alu_out,
	MemtoReg,
	write_reg_data,
);

	input clk;
	input rst_n;
	input [15:0] instr;
	input [15:0] read_data;
	input [15:0] alu_out;

	input MemtoReg;

	output [15:0] write_reg_data;

	assign write_reg_data = MemtoReg ? read_data : alu_out;

endmodule
