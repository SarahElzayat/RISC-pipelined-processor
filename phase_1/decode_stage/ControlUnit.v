module ControlUnit(inst,ALUtoReg,RegWrite,MemRead,MemWrite,ALUOp);
input [15:0] inst;
wire [2:0] Opcode;
output reg [1:0] ALUOp;
output reg ALUtoReg,RegWrite,MemRead,MemWrite;
assign Opcode = inst[15:13];
always @*
case (Opcode)
	//Load instruction LDM R1,0h
	3'b001:begin
	ALUtoReg = 'b0;
	RegWrite = 'b1;
	MemRead = 'b0;
	MemWrite = 'b0;
	ALUOp = 'bxx; 
	end

	//Store instruction STD R1,R2
	3'b010:begin
	ALUtoReg = 'bx;
	RegWrite = 'b0;
	MemRead = 'b0;
	MemWrite = 'b1;
	ALUOp = 'b10;
	end

	//Add instruction ADD,NOT
	3'b011: begin
	ALUtoReg = 'b1;
	RegWrite = 'b1;
	MemRead = 'b0;
	MemWrite = 'b0;
	ALUOp = 'b00;
	end
	
	//not instruction
	3'b100: begin
	ALUtoReg = 'b1;
	RegWrite = 'b1;
	MemRead = 'b0;
	MemWrite = 'b0;
	ALUOp = 'b01;
	end

	//no operation
	3'b101:begin
	ALUtoReg = 'bx;
	RegWrite = 'b0;
	MemRead = 'b0;
	MemWrite = 'b0;
	ALUOp = 'b11;
	end

	default : begin 
     	ALUtoReg= 1'b0;
     	RegWrite= 1'b0;
    	MemRead = 1'b0;
     	MemWrite= 1'b0;
	ALUOp = 'bxx;
    	end

endcase
endmodule
