module BitCell(input clk, input rst, input D, input WriteEnable, 
	input ReadEnable1, input ReadEnable2, inout Bitline1, inout Bitline2);

	wire q;

	// flop incoming data only when we write to this register
	dff dff_bit(.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

	// read out only if we are asking to read from this register
	assign Bitline1 = ReadEnable1 ? q : 1'bz;
	assign Bitline2 = ReadEnable2 ? q : 1'bz;

endmodule