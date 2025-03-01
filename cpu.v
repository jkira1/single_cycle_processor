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

	/*
	// fetch
	wire [15:0] pc_inc_2;
    wire [15:0] instr;

	fetch fetch0(.clk(clk), .rst_n(rst_n), .pc(pc_inc_2), .pc_inc_2(pc_inc_2), .instr(instr));

	assign pc_out = pc_inc_2;
	*/

endmodule