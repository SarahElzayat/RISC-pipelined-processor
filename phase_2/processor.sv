module processor(
    input clk,
    input rst,
    input interrupt_signal,
    output [15:0]  input_port,
    output [15:0]  out_port
);
    wire [15:0] instruction;
    wire [31:0] pc_plus_one_r;
    wire clear_instruction_fet;
    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (rst ),
        .pc_write (pc_write ),
        .pc_write_back_value (pc_write_back_value ),
        .clear_instruction (clear_instruction_fet ),
        .pc_plus_one_r (pc_plus_one_r ),
        .instruction_r  ( instruction_r)
    );


    wire [15:0] write_back_data;

    wire [3:0] alu_op_dec;
    wire [1:0] carry_sel_dec;

    wire outport_enable_dec, outport_enable_ex;

    wire [1:0] wb_sel_dec, wb_sel_ex;
    wire reg_write_dec, reg_write_ex;

    wire [1:0] alu_src1_select, alu_src2_select;
    wire [15:0] read_data1, read_data2;

    wire [15:0] reg_data1_from_mem, reg_data2_from_mem, reg_data1_from_dec, reg_data2_from_dec;
    wire [4:0] shamt;

    wire [2:0] write_address_from_wb, flag_register_ex;
    wire [2:0] write_address_from_decode, jump_selector, conditions_from_memory_pop;

    wire mem_push_ex, mem_pop_ex;
    wire [15:0] read_data1_ex, read_data2_ex;
    wire [31:0] new_PC_ex, PC_dec, PC_ex;

    wire [1:0] memory_address_select_dec, memory_write_src_select_dec;
    wire [1:0] memory_address_select_ex, memory_write_src_select_ex;

    wire mem_push_dec, mem_pop_dec, flagreg_enable, flag_reg_select;
    wire mem_read_dec, mem_write_dec;
    wire mem_read_ex, mem_write_ex;

    wire [15:0] reg_write_mem;

    wire [31:0] pc_plus_one_dec, pc_plus_one_ex;
    wire pc_choose_memory_dec, pc_choose_memory_ex;

    wire [2:0] reg_write_address_dec,reg_write_address_mem, reg_write_address_ex;
    wire [3:0] shamt_dec, shamt_ex;

    wire flag_reg_select_dec;
    wire alu_src_dec;

    wire [2:0] jump_selector_dec;
    wire [1:0] mem_src_select_r;

    decode_stage
    decode_stage_dut (
        .clk (clk ),
        .reset (rst ),
        .interrupt_signal (interrupt_signal ),
        .instruction (instruction ),
        .PC (pc_plus_one_r),
        .reg_write_r (reg_write_r ),
        .mem_read_r (mem_read_r ),
        .mem_write_r (mem_write_r ),
        .mem_pop_r (mem_pop_dec ),
        .mem_push_r (mem_push_dec ),
        .carry_select_r (carry_select_r ),
        .clear_instruction_r (clear_instruction_r ),
        .flag_reg_select_r (flag_reg_select_dec ),
        .pc_choose_memory_r (pc_choose_memory_dec ),
        .jump_selector_r (jump_selector_dec ),
        .mem_src_select_r (memory_write_src_select_dec ),
        .ALUOp_r (alu_op_dec ),
        .wb_sel_r (wb_sel_dec ),
        .alu_srcsel(alu_src_dec),
        .pc_write_r (pc_write_r ),
        .mem_addsel_r (memory_address_select_dec ),
        .carry_sel_r (carry_sel_dec ),
        .outport_enable_r (outport_enable_dec ),
        .inport_sel_r (inport_sel_r ),
        .flagreg_enable_r (flagreg_enable_r ),
        .clear_intruction_r  ( clear_intruction_r),
        .reg_write_wb(reg_write_mem),
        .reg_write_data_from_wb(write_back_data),
        .reg_write_address_from_wb(reg_write_address_mem),
        .reg_write_address_r(reg_write_address_dec),
        .reg_file_read_data1(reg_data1_from_dec),
        .reg_file_read_data2(reg_data2_from_dec),
        .shamt_out(shamt_dec)
    );


    wire [15:0] ALU_out, read_data1_out, read_data2_out;
    wire [2:0] write_address_to_mem;
    wire  [15:0] LDM_value_dec, LDM_value_ex;
    wire outport_enable_mem;


    execute_stage
    execute_stage_dut (
        .clk (clk),
        .reset (rst),
        .carry_sel (carry_sel_dec),
        .alu_src_select (alu_src_dec),
        .read_data1 (read_data1),
        .read_data2 (read_data2),
        .shamt (shamt_dec),
        .ALU_Op (alu_op_decdec),
        .write_back_data (write_back_data),
        .reg_data1_from_mem (reg_data1_from_mem),
        .reg_data2_from_mem (reg_data2_from_mem),
        .read_data1_out (read_data1_ex),
        .read_data2_out (read_data2_ex),
        .jump_selector (jump_selector_dec),
        .flag_regsel (flag_reg_select_dec),
        .flagreg_enable (flagreg_enable_r),
        .conditions_from_memory_pop (conditions_from_memory_pop),
        .pc_plus_one (pc_plus_one_dec),
        .pc_choose_memory (pc_choose_memory_dec),
        .pc_plus_one_out (pc_plus_one_ex),
        .pc_choose_memory_out (pc_choose_memory_ex),
        .result_out (ALU_out),
        .new_PC_out (new_PC_ex),
        .flag_register_out (flag_register_ex),
        .PC (PC_dec),
        .PC_out (PC_ex),
        .LDM_value (LDM_value_dec),
        .LDM_value_out (LDM_value_ex),
        .mem_pop (mem_pop_dec),
        .mem_pop_out (mem_pop_ex),
        .mem_push (mem_push_dec),
        .mem_push_out (mem_push_ex),
        .reg_write (reg_write_dec),
        .reg_write_out (reg_write_ex),
        .wb_sel (wb_sel_dec),
        .wb_sel_out (wb_sel_ex),
        .reg_write_address (reg_write_address_dec),
        .reg_write_address_out (reg_write_address_ex),
        .mem_read (mem_read_dec),
        .mem_read_out (mem_read_ex),
        .mem_write (mem_write_dec),
        .mem_write_out (mem_write_ex),
        .memory_address_select (memory_address_select_dec),
        .memory_address_select_out (memory_address_select_ex),
        .memory_write_src_select (memory_write_src_select_dec),
        .memory_write_src_select_out (memory_write_src_select_ex),
        .outport_enable (outport_enable_dec),
        .outport_enable_out (outport_enable_ex)
    );


    wire [15:0] ALU_out_to_wb;

    wire write_back_sel_to_wb;

    wire [15:0] mem_data;
    wire [31:0] shift_reg;
    wire [15:0] ldm_value_mem;
    wire [1:0] wb_sel_mem;
    wire [15:0] alu_value_mem;


    memory_stage
    memory_stage_dut (

        .clk (clk),
        .reset (rst),
        .memory_read ( mem_read_ex ),
        .memory_write ( mem_write_ex ),
        .memory_push ( mem_push_ex ),
        .memory_pop ( mem_pop_ex ),
        .std_address(read_data1_ex),
        .ldd_address(read_data2_ex),
        .memory_address_select ( memory_address_select_ex ),
        .memory_write_src_select ( memory_write_src_select_ex ),
        .pc (PC_ex),
        .flags (flag_register_ex),
        .data_r  ( mem_data),
        .shift_reg  ( shift_reg),

        // passing 
        .alu_value(ALU_ex),
        .alu_value_out(alu_value_mem),
        .LDM_value(LDM_value_ex),
        .LDM_value_out(ldm_value_mem),
        .reg_write(reg_write_ex),
        .reg_write_out(reg_write_mem),
        .wb_sel(wb_sel_ex),
        .wb_sel_out(wb_sel_mem),
        .outport_enable(outport_enable_ex),
        .outport_enable_out(outport_enable_mem),
        .reg_write_address(reg_write_address_ex),
        .reg_write_address_out(reg_write_address_mem)
    );



    write_back_stage
    write_back_stage_dut (
        .clk (clk ),
        .rst (rst ),
        .sel (wb_sel_mem ),
        .outport_enable (outport_enable_mem ),
        .immediate_value (ldm_value_mem),
        .alu_value (alu_value_mem ),
        .mem_data (mem_data ),
        .data (write_back_data ),
        .outport  (out_port)
    );



endmodule 
