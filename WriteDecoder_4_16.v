module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);

	// convert to 1 hot
	assign Wordline = WriteReg ? (1 << RegId) : 16'b0;

endmodule
