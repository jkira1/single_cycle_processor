`timescale 1ns / 1ps

module execute_tb;
    reg clk, rst_n;
    reg [15:0] instr_sign_extended, read_data_1, read_data_2;
    reg [15:0] pc_inc_2;
    reg [3:0] ALU_operation;
    reg PCSrc, ALUSrc;
    
    wire [15:0] aluResult, writeData, pc_inc_2_out, pc_branch;
    wire Z, V, N;
    
    execute uut (
        .clk(clk),
        .rst_n(rst_n),
        .instr_sign_extended(instr_sign_extended),
        .pc_inc_2(pc_inc_2),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .pc_inc_2_out(pc_inc_2_out),
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
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst_n = 0;
        #10 rst_n = 1;
        
        // Test each instruction
        test_instr(4'b0000, 16'h0005, 16'h0003); // ADD
        test_instr(4'b0001, 16'h0007, 16'h0002); // SUB
        test_instr(4'b0010, 16'h00F0, 16'h0F0F); // XOR
        test_instr(4'b0011, 16'h1234, 16'h0000); // RED (Placeholder, adjust for actual behavior)
        test_instr(4'b0100, 16'h0001, 16'h0004); // SLL
        test_instr(4'b0101, 16'h8000, 16'h0001); // SRA
        test_instr(4'b0110, 16'h000F, 16'h0002); // ROR
        test_instr(4'b0111, 16'h8080, 16'h7070); // PADDSB
        test_instr(4'b1000, 16'h0000, 16'h0000); // LW (Handled separately)
        test_instr(4'b1001, 16'h0000, 16'h0000); // SW (Handled separately)
        test_instr(4'b1010, 16'h00FF, 16'h0000); // LLB
        test_instr(4'b1011, 16'hFF00, 16'h0000); // LHB
        test_instr(4'b1100, 16'h0000, 16'h0000); // B (Handled separately)
        test_instr(4'b1101, 16'h0000, 16'h0000); // BR (Handled separately)
        test_instr(4'b1110, 16'h0000, 16'h0000); // PCS
        test_instr(4'b1111, 16'h0000, 16'h0000); // HLT
        
        #20 $finish;
    end
    
    task test_instr;
        input [3:0] alu_op;
        input [15:0] data1, data2;
        begin
            ALU_operation = alu_op;
            read_data_1 = data1;
            read_data_2 = data2;
            ALUSrc = 0; PCSrc = 0;
            #10;
            $display("ALU Op: %b, Data1: %h, Data2: %h, Result: %h", ALU_operation, read_data_1, read_data_2, aluResult);
        end
    endtask
    
endmodule

