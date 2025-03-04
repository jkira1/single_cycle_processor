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
	writeData,
	Z, V, N  // Flag outputs
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
	input [15:0] read_data_1;               // rs (first register operand)
	input [15:0] read_data_2;               // rt (second register operand)

	// decoder signals
	input ALUSrc;
	input [3:0] ALU_operation;
	input PCSrc;

	// outputs
	output [15:0] pc_inc_2_out;
	output [15:0] pc_branch;
	output reg [15:0] aluResult;    // changed to reg
	output [15:0] writeData;
	output Z;
	output V;
	output N;

    // declaration/signals
    wire [15:0] alu_b = ALUSrc ? instr_sign_extended : read_data_2;
    wire [15:0] add_sub_result, padsb_result, red_result;
    wire [15:0] sll_result, sra_result, ror_result;
    wire overflow_add, overflow_sub;

    wire [15:0] lw_result;
    wire [15:0] sw_result;
    wire [15:0] llb_result;
    wire [15:0] lhb_result;
    wire [15:0] b_result;
    wire [15:0] br_result;
    wire [15:0] pcs_result;
    wire [15:0] hlt_result;


	// Added 8 other operations
    always @(*) begin
        case(ALU_operation)
            4'b0000: aluResult = add_sub_result;            // ADD
            4'b0001: aluResult = add_sub_result;            // SUB
            4'b0010: aluResult = read_data_1 ^ alu_b;       // XOR
            4'b0011: aluResult = red_result;                // RED
            4'b0100: aluResult = sll_result;                // SLL
            4'b0101: aluResult = sra_result;                // SRA
            4'b0110: aluResult = ror_result;                // ROR
            4'b0111: aluResult = padsb_result;              // PADDSB

            4'b1000: aluResult = lw_result;
            4'b1001: aluResult = sw_result;
            4'b1010: aluResult = llb_result;
            4'b1011: aluResult = lhb_result;

            // B & BR do not perform ALU operations, they compute a new PC
            4'b1100: aluResult = 16'h0000;
            4'b1101: aluResult = 16'h0000;

            4'b1110: aluResult = pcs_result;
            4'b1111: aluResult = hlt_result;
            default: aluResult = 16'h0000;
        endcase
    end



    // LW & SW
    wire [15:0] offset_sign_extended;
    assign offset_sign_extended = {{12{instr_sign_extended[3]}}, instr_sign_extended[3:0]};
    wire lw_cout;
    wire sw_cout;
    
    cla_16bit lw_adder (
        .a(read_data_1 & 16'hFFFE),         // Base address (aligned)
        .b(offset_sign_extended << 1),      // Shifted offset
        .cin(1'b0),                         // No carry-in for addition
        .sum(lw_result),                    // Assign computed address to lw_result
        .cout(lw_cout)                      // Overflow carry (not used here)
    );

    cla_16bit sw_adder (
        .a(read_data_1 & 16'hFFFE),
        .b(offset_sign_extended << 1),
        .cin(1'b0),
        .sum(sw_result),
        .cout(sw_cout)
    );


    // LLB & LHB
    wire [7:0] immediate;
    assign immediate = instr_sign_extended[7:0];
    assign llb_result = (read_data_1 & 16'hFF00) | immediate;
    assign lhb_result = (read_data_1 & 16'h00FF) | (immediate << 8);


    // B & BR
    wire [2:0] branch_condition;
    assign branch_condition = instr_sign_extended[11:9];

    wire [8:0] branch_offset;
    assign branch_offset = instr_sign_extended[8:0];

    wire [15:0] branch_offset_sign_extended;
    assign branch_offset_sign_extended = {{7{branch_offset[8]}}, branch_offset};

    wire take_branch;
    assign take_branch =
        (branch_condition == 3'b000 && Z == 0) ||
        (branch_condition == 3'b001 && Z == 1) ||
        (branch_condition == 3'b010 && (Z == 0 && N == 0)) ||
        (branch_condition == 3'b011 && N == 1) ||
        (branch_condition == 3'b100 && (Z == 1 || N == 0)) ||
        (branch_condition == 3'b101 && (N == 1 || Z == 1)) ||
        (branch_condition == 3'b110 && V == 1) ||
        (branch_condition == 3'b111);
    
    wire [15:0] b_target;
    cla_16bit b_adder (
        .a(pc_inc_2),                   
        .b(branch_offset_sign_extended << 1), 
        .cin(1'b0),
        .sum(b_target),
        .cout()
    );

    wire [15:0] br_target;
    assign br_target = read_data_1;

    assign pc_branch = (ALU_operation == 4'b1100) ? (take_branch ? b_target : pc_inc_2) :
                       (ALU_operation == 4'b1101) ? (take_branch ? br_target : pc_inc_2) :
                       (pc_inc_2);
    

    // PCS & HLT
    assign pcs_result = pc_inc_2;

    wire [15:0] current_pc;
    cla_16bit current_pc_subtractor (
        .a(pc_inc_2),
        .b(16'hFFFE),
        .cin(1'b0),
        .sum(current_pc),
        .cout()
    );
    assign hlt_result = current_pc;









    // -------------------
    // Add / Sub 
    // -------------------
    wire [15:0] alu_b_neg;
    cla_16bit two_comp_adder (
        .a(~alu_b),
        .b(16'h0001),
        .cin(1'b0),
        .sum(alu_b_neg),
        .cout()
    );
    wire [15:0] alu_b_final = ALU_operation[0] ? alu_b_neg : alu_b;
    cla_16bit add_cla(
        .a(read_data_1),
        .b(alu_b_final),
        .cin(ALU_operation[0]),
        .sum(add_sub_result_raw), // Raw sum before saturation
        .cout(overflow_add)
    );
    // Saturation
    wire add_ovfl = (read_data_1[15] == alu_b_final[15]) && 
                   (add_sub_result_raw[15] != read_data_1[15]);
    wire sub_ovfl = (read_data_1[15] != alu_b_final[15]) && 
                   (add_sub_result_raw[15] != read_data_1[15]);  
    assign add_sub_result = (ALU_operation[0] ? sub_ovfl : add_ovfl) ? 
        (read_data_1[15] ? 16'h8000 : 16'h7FFF) : add_sub_result_raw;

 
    // -------------------
    // PADDSB
    // -------------------
    wire [4:0] sum_0, sum_1, sum_2, sum_3;

    cla_5bit padsb_adder_0 (.a({read_data_1[3], read_data_1[3:0]}), .b({alu_b[3], alu_b[3:0]}), .cin(1'b0), .sum(sum_0));
    cla_5bit padsb_adder_1 (.a({read_data_1[7], read_data_1[7:4]}), .b({alu_b[7], alu_b[7:4]}), .cin(1'b0), .sum(sum_1));
    cla_5bit padsb_adder_2 (.a({read_data_1[11], read_data_1[11:8]}), .b({alu_b[11], alu_b[11:8]}), .cin(1'b0), .sum(sum_2));
    cla_5bit padsb_adder_3 (.a({read_data_1[15], read_data_1[15:12]}), .b({alu_b[15], alu_b[15:12]}), .cin(1'b0), .sum(sum_3));

    assign padsb_result = {
        (sum_3[4] != sum_3[3]) ? (sum_3[4] ? 4'b1000 : 4'b0111) : sum_3[3:0],
        (sum_2[4] != sum_2[3]) ? (sum_2[4] ? 4'b1000 : 4'b0111) : sum_2[3:0],
        (sum_1[4] != sum_1[3]) ? (sum_1[4] ? 4'b1000 : 4'b0111) : sum_1[3:0],
        (sum_0[4] != sum_0[3]) ? (sum_0[4] ? 4'b1000 : 4'b0111) : sum_0[3:0]
    };


    // -------------------
    // RED
    // ------------------- 
    wire [4:0] sum_ae, sum_bf, sum_cg, sum_dh; // 5-bit: 4 sum + 1 cout
    wire [5:0] sum_ab, sum_cd;                 // 6-bit: 5 sum + 1 cout
    wire [6:0] final_sum;                      // 7-bit: 6 sum + 1 cout (unused)

    // First level: Add 4-bit pairs with CLA
    cla_4bit red_ae (
        .a(read_data_1[15:12]), 
        .b(alu_b[15:12]), 
        .cin(1'b0), 
        .sum(sum_ae[3:0]), 
        .cout(sum_ae[4])
    );
    cla_4bit red_bf (
        .a(read_data_1[11:8]), 
        .b(alu_b[11:8]), 
        .cin(1'b0), 
        .sum(sum_bf[3:0]), 
        .cout(sum_bf[4])
    );
    cla_4bit red_cg (
        .a(read_data_1[7:4]), 
        .b(alu_b[7:4]), 
        .cin(1'b0), 
        .sum(sum_cg[3:0]), 
        .cout(sum_cg[4])
    );
    cla_4bit red_dh (
        .a(read_data_1[3:0]), 
        .b(alu_b[3:0]), 
        .cin(1'b0), 
        .sum(sum_dh[3:0]), 
        .cout(sum_dh[4])
    );

    // Second level: Sum pairs of 5-bit results
    cla_5bit red_ab (
        .a(sum_ae), 
        .b(sum_bf), 
        .cin(1'b0), 
        .sum(sum_ab[4:0]), 
        .cout(sum_ab[5])
    );
    cla_5bit red_cd (
        .a(sum_cg), 
        .b(sum_dh), 
        .cin(1'b0), 
        .sum(sum_cd[4:0]), 
        .cout(sum_cd[5])
    );

    // Final level: Sum 6-bit results
    cla_6bit red_final (
        .a(sum_ab), 
        .b(sum_cd), 
        .cin(1'b0), 
        .sum(final_sum[5:0]), 
        .cout(final_sum[6])
    );

    // Sign-extend 6-bit result to 16 bits
    assign red_result = {{10{final_sum[5]}}, final_sum[5:0]};

    // -------------------
    // SHIFT 
    // -------------------
    
    // SLL
    shifter_sll sll_unit(
        .data(read_data_1),
        .shift_amt(alu_b[3:0]),
        .result(sll_result)
    );
    
    // SRA
    shifter_sra sra_unit(
        .data(read_data_1),
        .shift_amt(alu_b[3:0]),
        .result(sra_result)
    );
    
    // ROR
    shifter_ror ror_unit(
        .data(read_data_1),
        .shift_amt(alu_b[3:0]),
        .result(ror_result)
    );

    // -----------------
    // FLAG 
    // -----------------
    assign Z = (aluResult == 16'h0000);
    assign V = (ALU_operation == 4'b0000) ? add_ovfl : 
              (ALU_operation == 4'b0001) ? sub_ovfl : 1'b0;
    assign N = aluResult[15];

endmodule


// --------------------------------------------------
// cla IMPLEMENTATION
// --------------------------------------------------
module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g, p, c;

    // Generate (g) and Propagate (p) signals
    assign g = a & b;
    assign p = a ^ b;

    // Carry Look-Ahead Logic
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                  (p[2] & p[1] & p[0] & c[0]);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                  (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum Computation
    assign sum = p ^ c;
endmodule


module cla_5bit (
    input [4:0] a,
    input [4:0] b,
    input cin,
    output [4:0] sum,
    output cout
);
    wire [4:0] g, p, c;

    assign g = a & b;
    assign p = a ^ b;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                  (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                  (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign cout = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | 
                  (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) | 
                  (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c;
endmodule


module cla_6bit (
    input [5:0] a,
    input [5:0] b,
    input cin,
    output [5:0] sum,
    output cout
);
    wire [5:0] g, p, c;

    assign g = a & b;
    assign p = a ^ b;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                  (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                  (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | 
                  (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) | 
                  (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign cout = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | 
                  (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | 
                  (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | 
                  (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum = p ^ c;
endmodule


module cla_4bit_group (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output gg,  // Group generate
    output gp   // Group propagate
);
    wire [3:0] g, p, c;
    
    assign g = a & b;
    assign p = a | b;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                  (p[2] & p[1] & p[0] & c[0]);
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                  (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    
    assign sum = a ^ b ^ c;
    assign gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                (p[3] & p[2] & p[1] & g[0]);
    assign gp = p[3] & p[2] & p[1] & p[0];
endmodule

module cla_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [3:0] gg, gp;  // Group generate/propagate
    wire [4:0] c_block; // Block carries (cin + 4 groups)
    
    assign c_block[0] = cin;
    
    // Instantiate 4-bit CLA groups
    cla_4bit_group block0 (
        .a(a[3:0]), .b(b[3:0]), .cin(c_block[0]),
        .sum(sum[3:0]), .cout(), .gg(gg[0]), .gp(gp[0])
    );
    
    cla_4bit_group block1 (
        .a(a[7:4]), .b(b[7:4]), .cin(c_block[1]),
        .sum(sum[7:4]), .cout(), .gg(gg[1]), .gp(gp[1])
    );
    
    cla_4bit_group block2 (
        .a(a[11:8]), .b(b[11:8]), .cin(c_block[2]),
        .sum(sum[11:8]), .cout(), .gg(gg[2]), .gp(gp[2])
    );
    
    cla_4bit_group block3 (
        .a(a[15:12]), .b(b[15:12]), .cin(c_block[3]),
        .sum(sum[15:12]), .cout(), .gg(gg[3]), .gp(gp[3])
    );
    
    // Block Carry Look-Ahead
    assign c_block[1] = gg[0] | (gp[0] & c_block[0]);
    assign c_block[2] = gg[1] | (gp[1] & gg[0]) | (gp[1] & gp[0] & c_block[0]);
    assign c_block[3] = gg[2] | (gp[2] & gg[1]) | (gp[2] & gp[1] & gg[0]) | 
                        (gp[2] & gp[1] & gp[0] & c_block[0]);
    assign cout = gg[3] | (gp[3] & gg[2]) | (gp[3] & gp[2] & gg[1]) | 
                  (gp[3] & gp[2] & gp[1] & gg[0]) | 
                  (gp[3] & gp[2] & gp[1] & gp[0] & c_block[0]);
endmodule



// --------------------------------------------------
// MODULES FOR SHIFT OPERATIONS
// --------------------------------------------------
module shifter_sll(
    input [15:0] data,
    input [3:0] shift_amt,
    output [15:0] result
);
    // 4:1 mux implementation
    wire [15:0] stage1 = shift_amt[0] ? {data[14:0], 1'b0} : data;
    wire [15:0] stage2 = shift_amt[1] ? {stage1[13:0], 2'b00} : stage1;
    wire [15:0] stage3 = shift_amt[2] ? {stage2[11:0], 4'b0000} : stage2;
    assign result = shift_amt[3] ? {stage3[7:0], 8'b00000000} : stage3;
endmodule

module shifter_sra(
    input [15:0] data,
    input [3:0] shift_amt,
    output [15:0] result
);
    // Arithmetic shift with sign extension
    wire [15:0] stage1 = shift_amt[3] ? {{8{data[15]}}, data[15:8]} : data;
    wire [15:0] stage2 = shift_amt[2] ? {{4{stage1[15]}}, stage1[15:4]} : stage1;
    wire [15:0] stage3 = shift_amt[1] ? {{2{stage2[15]}}, stage2[15:2]} : stage2;
    assign result = shift_amt[0] ? {{1{stage3[15]}}, stage3[15:1]} : stage3;
endmodule

module shifter_ror(
    input [15:0] data,
    input [3:0] shift_amt,
    output [15:0] result
);
    // Barrel rotator using 4:1 muxes
    wire [15:0] stage1 = shift_amt[0] ? {data[0], data[15:1]} : data;
    wire [15:0] stage2 = shift_amt[1] ? {stage1[1:0], stage1[15:2]} : stage1;
    wire [15:0] stage3 = shift_amt[2] ? {stage2[3:0], stage2[15:4]} : stage2;
    assign result = shift_amt[3] ? {stage3[7:0], stage3[15:8]} : stage3;
endmodule
