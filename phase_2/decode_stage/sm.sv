module sm (
	input clk,reset,
	input interrupt_signal,
	input [15:0] opcode,
	input [32-1:0]PC,
	output reg reg_write, mem_read, mem_write, mem_pop,mem_push,carry_select, clear_instruction,flag_reg_select,pc_choose_memory,
	output reg[2 :0] jump_selector,
	output reg [1:0] mem_src_select
);
	typedef enum int unsigned { IDLE ,JUMP_1, PIPE_WAIT , PUSH_FLAGS , PUSH_PC1 ,PUSH_PC2, POP_PC1,POP_PC2,POP_FLAGS} State;
	State current_state;
	logic [4:0] counter;


	// output logic
	always_comb
	begin
		case (current_state)
			IDLE :
			begin
				//NOTE - NORMAL EXECUTION
				// TODO- FADY HERE
				case (opcode[15:14])
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
						case (opcode[13:11])
							3'b000 , 3'b001 , 3'b010 ,3'b011: // JMP zero , negative , carry , no-condition
							begin
								jump_selector <= {1'b1,opcode[12:11]};
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
						case (opcode[15:14])
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
								case (opcode[13:11])
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

