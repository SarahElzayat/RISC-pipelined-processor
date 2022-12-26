module decode_stage(

	input clk,reset,
	input interrupt_signal,
	input [15:0] instruction,
	input [32-1:0]PC,
	output  reg_write, mem_read, mem_write, mem_pop,mem_push,
	output  carry_select, clear_instruction,flag_reg_select,pc_choose_memory,
	output [2 :0] jump_selector,
	output  [1:0] mem_src_select,
	output  [3:0] ALUOp,
	output  [1:0] wb_sel,
	output  pc_write,
	output  [1:0] mem_addsel,
	output  [1:0] mem_srcsel,
	output  [1:0] carry_sel,
	output  [1:0] alu_src1sel,
	output  [1:0] alu_src2sel,
	output  outport_enable,
	output  inport_sel,
	output  flagreg_enable,
	output  clear_intruction

);

endmodule