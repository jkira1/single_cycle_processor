module ReadDecoder_4_16(input [3:0] RegId, output [15:0] Wordline);

	// convert to 1 hot
	assign Wordline = 1 << RegId;

endmodule