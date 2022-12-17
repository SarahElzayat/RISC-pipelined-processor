module sm (
	input clk,reset,
	input interrupt_signal,
	input opcode[15:0],
	input [32-1:0]PC,
	output reg_write, mem_read, mem_write, mem_pop,mem_push,carry_select, clear_instruction,
	output [3:0] jump_selector,alu_op
);
	typedef enum int unsigned { IDLE ,JUMP_1,JUMP_2, PIPE_WAIT , PUSH_FLAGS , PUSH_PC1 ,PUSH_PC2, EXEC_INT, POP_PC1,POP_PC2,POP_FLAGS} State;
	State current_state;

	logic reti_signal ;
	assign reti_signal = opcode[15:11] == 5'b101010;
	logic is_branch;
	assign is_branch = opcode[15:14] == 2'b11;

	// output logic
	always_comb
	begin
		case (current_state)
			IDLE :
			begin
				if(is_branch)
					begin
					end
				else
					begin
					end
			end
			PIPE_WAIT:
			begin
			end
			JUMP_1:
			begin
			end
			JUMP_2:
			begin
			end
			PUSH_FLAGS :
			begin
			end
			PUSH_PC1:
			begin
			end
			PUSH_PC2:
			begin
			end
			EXEC_INT:
			begin
			end
			POP_PC1:
			begin
			end
			POP_PC2:
			begin
			end
			POP_FLAGS:
			begin
			end
			default :
			begin
			end
		endcase
	end

	logic [4:0] counter;
	// state ff and transition 
	always_ff@(posedge clk or negedge reset)
	begin
		if(reset)
			current_state <= IDLE;
		else
			begin
				counter <= 0;
				case (current_state)
					IDLE :
					begin
					end
					PIPE_WAIT:
					begin
						counter <= counter +1;
						if(counter  == 4)
						begin
							current_state <= PUSH_FLAGS;
							counter <= 0;
						end
						JUMP_1:
						begin
						end
						JUMP_2:
						begin
						end
					end
					PUSH_FLAGS :
					begin
						current_state <= PUSH_PC1;
					end
					PUSH_PC1:
					begin
						current_state <= PUSH_PC2;
					end
					PUSH_PC2:
					begin
						current_state <= EXEC_INT;
					end

					EXEC_INT:
					begin
						if(reti_signal)
							current_state <= POP_PC1;

					end
					POP_PC1:
					begin
						current_state = POP_PC2;
					end
					POP_PC2:
					begin
						current_state = POP_FLAGS;
					end
					POP_FLAGS:
					begin
						// the poped pc is in the interrupts Area 
						if(PC < 2^5)
							current_state <= EXEC_INT;
						else
							current_state <= IDLE;

					end

					default :
					current_state <= IDLE;

				endcase

			end
	end

endmodule

