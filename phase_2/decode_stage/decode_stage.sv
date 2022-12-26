module decode_stage(
	input clk,reset,
	input interrupt_signal,
	input [15:0] instruction,
	input [32-1:0]PC,

	output  reg_write_r, mem_read_r, mem_write_r, mem_pop_r,mem_push_r,
	output  carry_select_r, clear_instruction_r,flag_reg_select_r,pc_choose_memory_r,
	output [2 :0] jump_selector_r,
	output  [1:0] mem_src_select_r,
	output  [3:0] ALUOp_r,
	output  [1:0] wb_sel_r,
	output  pc_write_r,
	output  [1:0] mem_addsel_r,
	output  [1:0] mem_srcsel_r,
	output  [1:0] carry_sel_r,
	output  [1:0] alu_src1sel_r,
	output  [1:0] alu_src2sel_r,
	output  outport_enable_r,
	output  inport_sel_r,
	output  flagreg_enable_r,
	output  clear_intruction_r

);

	wire reg_write, mem_read, mem_write, mem_pop,mem_push;
	wire carry_select, clear_instruction,flag_reg_select,pc_choose_memory;
	wire [2:0] jump_selector;
	wire [1:0] mem_src_select;
	wire [3:0] ALUOp;
	wire [1:0] wb_sel;
	wire pc_write;
	wire [1:0] mem_addsel;
	wire [1:0] mem_srcsel;
	wire [1:0] carry_sel;
	wire [1:0] alu_src1sel;
	wire [1:0] alu_src2sel;
	wire alu_srcsel;
	wire outport_enable;
	wire inport_sel;
	wire flagreg_enable;
	wire clear_intruction;

	var_reg #(.size(5))
	var_reg_1 (
		.D ({reg_write, mem_read, mem_write, mem_pop,mem_push} ),
		.clk (clk ),
		.Q  ({ reg_write_r, mem_read_r, mem_write_r, mem_pop_r,mem_push_r} ),
		.rst (reset)
	);

	var_reg #(.size(12))
	var_reg_2 (
		.D ({jump_selector, mem_src_select, ALUOp, wb_sel,pc_write} ),
		.clk (clk ),
		.Q  ({ jump_selector_r,mem_src_select_r,ALUOp_r,wb_sel_r,pc_write_r} ),
		.rst (reset)
	);
	
	var_reg #(.size(10))
	var_reg_3 (
		.D ({mem_addsel,mem_srcsel,carry_sel,alu_src1sel,alu_src2sel} ),
		.clk (clk ),
		.Q  ({ mem_addsel_r,mem_srcsel_r,carry_sel_r,alu_src1sel_r,alu_src2sel_r} ),
		.rst (reset)
	);

	var_reg #(.size(10))
	var_reg_4 (
		.D ({outport_enable,inport_sel,flagreg_enable,clear_intruction} ),
		.clk (clk ),
		.Q  ({ outport_enable_r, inport_sel_r, flagreg_enable_r, clear_intruction_r} ),
		.rst (reset)
	);

	
	sm control_unit(
		.clk(clk),
		.reset(reset),
		.interrupt_signal(interrupt_signal),
		.instruction(instruction),
		.PC(PC),
		.reg_write(reg_write),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.mem_pop(mem_pop),
		.mem_push(mem_push),
		.carry_select(carry_select),
		.clear_instruction(clear_instruction),
		.flag_reg_select(flag_reg_select),
		.pc_choose_memory(pc_choose_memory),
		.jump_selector(jump_selector),
		.mem_src_select(mem_src_select),
		.ALUOp(ALUOp),
		.wb_sel(wb_sel),
		.pc_write(pc_write),
		.mem_addsel(mem_addsel),
		.mem_srcsel(mem_srcsel),
		.carry_sel(carry_sel),
		.alu_srcsel(alu_srcsel),
		.outport_enable(outport_enable),
		.inport_sel(inport_sel),
		.flagreg_enable(flagreg_enable),
		.clear_intruction(clear_intruction)
	);
endmodule