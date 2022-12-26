module ControlUnit(
	input [15:0] inst,
	output reg [3:0] ALUOp,
	output reg mem_pop,
	output reg mem_push,
	output reg reg_write,
	output reg [1:0] wb_sel,
	output reg mem_read,
	output reg mem_write,
	output reg [2:0] jump_sel,
	output reg pc_enable,
	output reg [1:0] mem_addsel,
	output reg [1:0] mem_srcsel,
	output reg flag_regsel,
	output reg [1:0] carry_sel,
	output reg [1:0] alu_src1sel,
	output reg [1:0] alu_src2sel,
	output reg outport_enable
	output reg inport_sel
	output reg flagreg_enable
	);
	wire [4:0] Opcode;
	assign Opcode = inst[15:11];
	always @*
	// type of the instruction j-type || r-type || i-type
	case (Opcode[4:3])
	// R-type instructions (00)
		2'b00:begin
			case(Opcode[2:0])
				// NOT Rdst => 000
				3'b000:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0000;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;	//useless
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end

				// INC & DEC instructions => 001
				3'b001:begin
					case(inst[10])
					// INC Rdst
						1'b0:begin
							//fetch stage signals
							pc_enable = 1'b1;
							inport_sel = 1'b0;
							// execution stage signals
							ALUOp = 4'b0001;
							alu_src1sel = 2'b10;
							alu_src2sel = 2'b00;	//useless
							jump_sel = 3'b000;
							carry_sel = 2'b00;
							flag_regsel = 1'b0;
							flagreg_enable = 1'b1;
							// memory stage signals (useless)
							mem_read = 1'b0;
							mem_write = 1'b0;
							mem_pop = 1'b0;
							mem_push = 1'b0;
							mem_addsel = 2'b00;
							mem_srcsel = 2'b00;
							// write back stage signals
							reg_write = 1'b1;
							wb_sel = 2'b10;
							outport_enable = 1'b0;
						end
					// DEC Rdst 
						1'b1:begin
							//fetch stage signals
							pc_enable = 1'b1;
							inport_sel = 1'b0;
							// execution stage signals
							ALUOp = 4'b0010;
							alu_src1sel = 2'b10;
							alu_src2sel = 2'b00;	//useless
							jump_sel = 3'b000;
							carry_sel = 2'b00;
							flag_regsel = 1'b0;
							flagreg_enable = 1'b1;
							// memory stage signals (useless)
							mem_read = 1'b0;
							mem_write = 1'b0;
							mem_pop = 1'b0;
							mem_push = 1'b0;
							mem_addsel = 2'b00;
							mem_srcsel = 2'b00;
							// write back stage signals
							reg_write = 1'b1;
							wb_sel = 2'b10;
							outport_enable = 1'b0;
						end
					endcase
				end

				// ADD Rds,Rscr
				3'b010:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0011;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
				
				// SUB Rdst,Rscr
				3'b011:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0100;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end

				// AND Rdst,Rscr
				3'b100:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0101;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end

				// OR Rdst,Rscr
				4'b101:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0110;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end

				// SHL Rdst,Rscr
				4'b110:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b0111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end

				// SHR Rdst,Rscr
				4'b111:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1000;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			endcase
		end
		
	//I-type instructions with one operand (01)
		2'b01:begin
			case(Opcode[2:0])
			// NOP
				3'b000:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b00;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b0;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// SETC
				3'b001:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b0;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// CLRC
				3'b010:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b10;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b1;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b0;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// OUT Rdst
				3'b011:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b0;
					wb_sel = 2'b10;
					outport_enable = 1'b1;
				end
			// IN Rdst
				3'b100:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b1;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals (useless)
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// PUSH Rdst
				3'b101:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b0;
					mem_write = 1'b1;
					mem_pop = 1'b0;
					mem_push = 1'b1;
					mem_addsel = 2'b10;
					mem_srcsel = 2'b11;
					// write back stage signals
					reg_write = 1'b0;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// POP Rdst
				3'b110:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b1;
					mem_write = 1'b0;
					mem_pop = 1'b1;
					mem_push = 1'b0;
					mem_addsel = 2'b10;
					mem_srcsel = 2'b11;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b01;
					outport_enable = 1'b0;
				end
			endcase
		end
	//I-type instructions with two operands (10)
		2'b10:begin
			case(Opcode[2:0])
			// MOV Rdst,Rscr
				3'b000:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b10;
					mem_srcsel = 2'b11;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b10;
					outport_enable = 1'b0;
				end
			// LDM Rdst,imm
				3'b001:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b0;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b00;
					mem_srcsel = 2'b00;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b00;
					outport_enable = 1'b0;

				end
			// LDD Rdst,Rscr
				3'b010:begin
					//fetch stage signals
					pc_enable = 1'b1;
					inport_sel = 1'b0;
					// execution stage signals
					ALUOp = 4'b1111;
					alu_src1sel = 2'b10;
					alu_src2sel = 2'b00;
					jump_sel = 3'b000;
					carry_sel = 2'b01;
					flag_regsel = 1'b0;
					flagreg_enable = 1'b0;
					// memory stage signals
					mem_read = 1'b1;
					mem_write = 1'b0;
					mem_pop = 1'b0;
					mem_push = 1'b0;
					mem_addsel = 2'b01;
					mem_srcsel = 2'b11;
					// write back stage signals
					reg_write = 1'b1;
					wb_sel = 2'b01;
					outport_enable = 1'b0;
				end
			// STD Rdst,Rscr
				3'b011:begin
					
				end
			endcase
		end
	endcase
endmodule
