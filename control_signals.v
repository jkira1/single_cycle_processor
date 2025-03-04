module control_signals (
    instr,
    RegWrite,
    ALUSrc,
    ALU_operation,
    PCSrc,
	memWrite,
	memRead,
	MemtoReg,
	hlt
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
    input [15:0] instr;

    // control signals
   	// decoder
    output reg RegWrite;
 	
 	// execute
    output reg ALUSrc;
	output reg [3:0] ALU_operation;

	// memory
	output reg PCSrc;
	output reg memWrite;
	output reg memRead;

	// writeback
	output reg MemtoReg;

	// hlt
	output reg hlt;

    always @(*) begin

        case (instr[15:12])
            4'b0000: begin 
            	// ADD instruction
	            RegWrite = 1'b1;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b0000;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b0001: begin 
                // SUB instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b0001;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b0010: begin 
                // XOR instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b0010;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;                
            end
            4'b0011: begin 
                // RED instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 1'b0011;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;                
            end
            4'b0100: begin 
                // SLL instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b0100;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;               
            end
            4'b0101: begin 
                // SRA instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b0101;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;                
            end
            4'b0110: begin 
                // ROR instruction                
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b0110;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b0111: begin 
                // PADDSB instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b0111;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1000: begin 
                // LW instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b1000;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b1;
    			MemtoReg = 1'b1;
            end
            4'b1001: begin 
                // SW instruction
                RegWrite = 1'b0;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b0001;
	   			PCSrc = 1'b0;
    			memWrite = 1'b1;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1010: begin 
                // LLB instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b1010;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1011: begin 
                // LHB instruction
                RegWrite = 1'b1;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b1011;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1100: begin 
                // B instruction
                RegWrite = 1'b0;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b1100;
	   			PCSrc = 1'b1;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1101: begin 
                // BR instruction
                RegWrite = 1'b0;
	  			ALUSrc = 1'b1;
	    		ALU_operation = 4'b1101;
	   			PCSrc = 1'b1;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1110: begin 
                // PCS instruction
                RegWrite = 1'b0;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b1110;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            4'b1111: begin 
                // HLT instruction
                RegWrite = 1'b0;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 4'b1111;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
            end
            default: begin 
                // Handle invalid opcode
                RegWrite = 1'b0;
	  			ALUSrc = 1'b0;
	    		ALU_operation = 1'b0;
	   			PCSrc = 1'b0;
    			memWrite = 1'b0;
    			memRead = 1'b0;
    			MemtoReg = 1'b0;
    			hlt = 1'b1;
            end
        endcase
    end

endmodule
