module ControlUnit(inst,WB_ALUtoReg,RegWrite,MemRead,MemWrite,ALUOp);
	input [15:0] inst;
	wire [2:0] Opcode;
	output reg [1:0] ALUOp;
	output reg WB_ALUtoReg,RegWrite,MemRead,MemWrite;
	assign Opcode = inst[15:13];
	always @*
	case (Opcode)
		//Load instruction LDM R1,0h
		// 0010_0100_0000_0000
		// 2400
		// LDM R2,2h
		// 0010_1000_0000_0010
		// 2802
		//// LDM R3,4h
		//// 0010_1100_0000_0100
		//// 2C04
		//NOP 
		// 1010_0000_0000_0000
		// A000
		// Add R2,R1
		// 011 _0 01_010 _000_0000
		// 6500
		// R1 = 2 now
		// NOT R1
		// 1000 0100 00000000
		// 8400
		// STD R2,R1
		// 010 001 010 000 0000
		// 4500

		3'b001:begin
			WB_ALUtoReg = 'b0;
			RegWrite = 'b1;
			MemRead = 'b0;
			MemWrite = 'b0;
			ALUOp = 'bxx;
		end

		//Store instruction STD R1,R2
		3'b010:begin
			WB_ALUtoReg = 'bx;
			RegWrite = 'b0;
			MemRead = 'b0;
			MemWrite = 'b1;
			ALUOp = 'b10;
		end

		//Add instruction ADD,NOT
		3'b011: begin
			WB_ALUtoReg = 'b1;
			RegWrite = 'b1;
			MemRead = 'b0;
			MemWrite = 'b0;
			ALUOp = 'b00;
		end

		//not instruction
		// 1000 0100 00000000
		// 8400
		3'b100: begin
			WB_ALUtoReg = 'b1;
			RegWrite = 'b1;
			MemRead = 'b0;
			MemWrite = 'b0;
			ALUOp = 'b01;
		end

		//no operation
		3'b101:begin
			WB_ALUtoReg = 'bx;
			RegWrite = 'b0;
			MemRead = 'b0;
			MemWrite = 'b0;
			ALUOp = 'b11;
		end

		default : begin
			WB_ALUtoReg= 1'b0;
			RegWrite= 1'b0;
			MemRead = 1'b0;
			MemWrite= 1'b0;
			ALUOp = 'bxx;
		end

	endcase
endmodule
