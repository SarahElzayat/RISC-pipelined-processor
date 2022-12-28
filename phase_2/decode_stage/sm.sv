module sm (
	input clk,reset,
	input interrupt_signal,
	input [15:0] instruction,
	input [32-1:0] PC,
	output logic  reg_write, mem_read, mem_write, mem_pop,mem_push,
	output logic   clear_instruction ,flag_reg_select,pc_choose_memory,
	output logic [2 :0] jump_selector,
	output logic  [1:0] mem_src_select,
	output logic  [3:0] ALUOp,
	output logic  [1:0] wb_sel,
	output logic  pc_write,
	output logic  [1:0] mem_addsel,
	output logic  [1:0] carry_sel,
	output logic  alu_srcsel,
	output logic  outport_enable,
	output logic  inport_sel,
	output logic  flagreg_enable
);

	typedef enum int unsigned { IDLE,JUMP_1, PIPE_WAIT , PUSH_FLAGS , PUSH_PC1 ,PUSH_PC2, POP_PC1,POP_PC2,POP_FLAGS} State;

	State current_state;

	logic [4:0] counter;
	wire [4:0] opcode;

	assign opcode = instruction[15:11];

	// output logic
	always_comb
	begin
		//----------------default values-------------------
		//fetch stage signals
		pc_write = 1'b1;
		inport_sel = 1'b0;
		clear_instruction = 1'b0;
		// execution stage signals
		ALUOp = 4'b1111;
		alu_srcsel = 1'b0;
		jump_selector = 3'b000;
		carry_sel = 2'b00;
		flag_reg_select = 1'b0;
		flagreg_enable = 1'b0;
		// memory stage signals
		mem_read = 1'b0;
		mem_write = 1'b0;
		mem_pop = 1'b0;
		mem_push = 1'b0;
		mem_addsel = 2'b00;
		mem_src_select = 2'b00;
		// write back stage signals
		reg_write = 1'b0;
		wb_sel = 2'b01;
		outport_enable = 1'b0;
		case (current_state)
			IDLE :
			begin
				//NOTE - NORMAL EXECUTION
				// TODO- FADY HERE
				case (instruction[15:14])
					// R-type instructions (00)
					2'b00:begin
						// execution stage signals
						flagreg_enable = 1'b1;
						// write back stage signals
						reg_write = 1'b1;
						case(opcode[2:0])
							// NOT Rdst => 000
							3'b000:begin
								// execution stage signals
								ALUOp = 4'b0000;
							end

							// INC Rdst
							3'b001:begin
								// execution stage signals
								ALUOp = 4'b0001;
							end

							// DEC Rdst
							3'b010:begin
								// execution stage signals
								ALUOp = 4'b0010;
							end
							// ADD Rds,Rscr
							3'b011:begin
								// execution stage signals
								ALUOp = 4'b0011;
							end

							// SUB Rdst,Rscr
							3'b100:begin
								// execution stage signals
								ALUOp = 4'b0100;
							end

							// AND Rdst,Rscr
							3'b101:begin
								// execution stage signals
								ALUOp = 4'b0101;
							end

							// OR Rdst,Rscr
							4'b110:begin
								// execution stage signals
								ALUOp = 4'b0110;
							end
							default:;
						endcase
					end

					//I-type instructions with one operand (01)
					2'b01:begin
						case(opcode[2:0])
							// NOP
							3'b000:;
							// SETC
							3'b001:begin
								// execution stage signals
								carry_sel = 2'b01;
								flagreg_enable = 1'b1;
							end
							// CLRC
							3'b010:begin
								// execution stage signals
								carry_sel = 2'b10;
								flagreg_enable = 1'b1;
							end
							// OUT Rdst
							3'b011:begin
								// write back stage signals
								outport_enable = 1'b1;
							end
							// IN Rdst
							3'b100:begin
								//fetch stage signals
								inport_sel = 1'b1;
								// write back stage signals
								reg_write = 1'b1;
								//NOTE - @Atta ADDED THIS
								wb_sel = 2'b11;
							end
							// PUSH Rdst
							3'b101:begin
								// memory stage signals
								mem_write = 1'b1;
								mem_push = 1'b1;
								mem_addsel = 2'b10;
								mem_src_select = 2'b11;
							end
							// POP Rdst
							3'b110:begin
								// memory stage signals
								mem_read = 1'b1;
								mem_pop = 1'b1;
								mem_addsel = 2'b10;
								mem_src_select = 2'b11;
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b10;
							end
							default:;
						endcase
					end
					//I-type instructions with two operands (10)
					2'b10:begin
						case(opcode[2:0])
							// MOV Rdst,Rscr
							3'b000:begin
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b01;
							end
							// LDM Rdst,imm
							3'b001:begin
								//fetch stage signals
								clear_instruction = 1'b1;
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b00;
							end
							// LDD Rdst,Rscr
							3'b010:begin
								// memory stage signals
								mem_read = 1'b1;
								mem_addsel = 2'b01;
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b10;
							end
							// STD Rdst,Rscr
							3'b011:begin

								// memory stage signals
								mem_write = 1'b1;
								mem_addsel = 2'b11;
							end
							// SHL Rdst,imm
							3'b100:begin
								// execution stage signals
								ALUOp = 4'b0111;
								alu_srcsel = 1'b1;
								flagreg_enable = 1'b1;
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b01;
							end
							// SHR Rdst,imm
							3'b101:begin
								// execution stage signals
								ALUOp = 4'b1000;
								alu_srcsel = 1'b1;
								flagreg_enable = 1'b1;
								// write back stage signals
								reg_write = 1'b1;
								wb_sel = 2'b01;
							end
							default :;
						endcase
					end

					2'b11:
					begin
						// branches 
						case (instruction[13:11])
							3'b000 , 3'b001 , 3'b010 ,3'b011: // JMP zero , negative , carry , no-condition
							begin
								jump_selector <= {1'b1,instruction[12:11]};
							end
							3'b100: // call
							begin
								// push pc1 and pc2 
								// TODO: stop the fetch 
								// push pc_1 --> upper part first 
								mem_src_select <= 2'b01;
								mem_push <= 1'b1;
								// jmp-no-condition in execute stage
								jump_selector <= 3'B111;

							end
							3'b101: // ret
							begin
								// pop pc and continue
								mem_pop <= 1'b1; // first part
							end
							3'b110: // reti
							begin

							end
							default : ;
						endcase

					end
					default:
					begin
					end
				endcase
			end
			PIPE_WAIT:
			begin
				// TODO - insert the NOPS here in the pipeline
				if(counter > 0)
					clear_instruction <= 1'b1;

			end

			JUMP_1:
			begin

				// TODO: stop the fetch 
				// push pc2
				mem_src_select <= 2'b10;
				mem_push <= 1'b1;

			end
			PUSH_FLAGS :
			begin
				mem_src_select <= 2'b00;
				mem_push <= 1'b1;
			end
			PUSH_PC1:
			begin
				mem_src_select <= 2'b01;
				mem_push <= 1'b1;
			end
			PUSH_PC2:
			begin

				mem_src_select <= 2'b01;
				mem_push <= 1'b1;
			end
			POP_PC1:
			begin
				mem_pop <= 1'b1;
			end
			POP_PC2:
			begin
				// leach pop at the first cycle 
				if(counter == 0)
					mem_pop <= 1'b1;
					// It will take pass the first cycle (EXECUTE) and gget the PC in the second cycle (MEMORY) 
					// Change the PC HERE 
				if(counter  == 2)
				begin
					pc_choose_memory <= 1'b1;
				end

			end
			POP_FLAGS:
			begin
				mem_pop <= 1'b1;
				// TODO- make it work with POP in same cycle
				flag_reg_select <= 1'b1;
			end
			default :
			begin
			end
		endcase
	end

	// state ff and transition 
	always_ff@(posedge clk or negedge reset)
	begin
		if(reset)
			begin
				current_state <= IDLE;
			end
		else
			begin
				counter <= 0;
				case (current_state)
					IDLE:
					if(interrupt_signal == 1)
						begin
							current_state <= PIPE_WAIT;
						end else begin
						case (instruction[15:14])
							//NOTE - NORMAL EXECUTION
							2'b00:
							begin
							end
							2'b01:
							begin
							end
							2'b10:
							begin
							end
							2'b11:
							begin
								// branches 
								case (instruction[13:11])
									3'b000 , 3'b001 , 3'b010 ,3'b011: // JMP zero , negative , carry , no-condition
									begin
									end
									3'b100: // call 
									begin
										// push pc1 and pc2 
										current_state <= JUMP_1;
									end
									3'b101: // ret
									begin
										// pop pc and continue
										current_state <= POP_PC2;
									end
									3'b110: // reti
									begin
										current_state <= POP_FLAGS;
									end
									default : ;
								endcase

							end
							default:
							begin
								current_state <= IDLE;
							end
						endcase

					end

					PIPE_WAIT:
					begin
						counter <= counter +1;
						// wait 5 cycles 
						if(counter  == 4)
						begin
							current_state <= PUSH_PC1;
							counter <= 0;
						end
					end



					//-----------------------------------------------------CALL
					JUMP_1:
					begin
						current_state <= IDLE;
					end

					//-----------------------------------------------------INTERRUPT
					PUSH_PC1:
					begin
						current_state <= PUSH_PC2;
					end
					PUSH_PC2:
					begin
						current_state <= PUSH_FLAGS;
					end
					PUSH_FLAGS :
					begin
						current_state <= IDLE;
					end

					//-----------------------------------------------------RET 
					POP_FLAGS:
					begin
						current_state <= POP_PC1;

					end
					POP_PC1:
					begin
						current_state = POP_PC2;
					end
					POP_PC2:
					begin
						counter <= counter +1;
						if(counter  == 2)
						begin
							current_state <= IDLE;
							counter <= 0;
						end
					end

					default :
					current_state <= IDLE;

				endcase

			end
	end

endmodule