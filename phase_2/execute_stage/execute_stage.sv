module execute_stage (
    input clk,
    input reset,

    // Inputs to ALU
    input [1:0] carry_sel,
    input [15:0] read_data1, // Rdest
    input [15:0] read_data2, // Rsrc
    input alu_src_select, // Select dest
    input [3:0] shamt,
    input [3:0] ALU_Op,
    input [15:0] write_back_data,
    input [15:0] alu_result_from_mem,
    input [2:0] jump_selector,
    input [3:0] r_scr_buff,r_dst_buff, r_dst_buff_ex,
    input flag_regsel,
    input flagreg_enable,
    input [2:0] conditions_from_memory_pop,

    output [15:0] result_out, // ALU Result
    output [31:0] new_PC, // ALU Result
    output [2:0] flag_register, // Carry, negative, zero

    input [31:0] PC,

    // inputs to just pass
    input [15:0] LDM_value,
    output [15:0] LDM_value_out,

    input mem_pop,
    output mem_pop_out,

    input mem_push,
    output mem_push_out,

    input reg_write,
    output reg_write_out,

    input pc_choose_interrupt,
    output pc_choose_interrupt_out,

    input [1:0] wb_sel,
    output [1:0] wb_sel_out,

    input mem_read,
    output mem_read_out,

    input mem_write,
    output mem_write_out,

    input outport_enable,
    output outport_enable_out,

    input [1:0] memory_address_select,
    output [1:0] memory_address_select_out,

    input [1:0] memory_write_src_select,
    output [1:0] memory_write_src_select_out,

    input [31:0] pc_plus_one,
    output [31:0] pc_plus_one_out,

    input pc_choose_memory,
    output pc_choose_memory_out,
    
    input pc_plus_1_or_pc_minus_1,
    output pc_plus_1_or_pc_minus_1_out,

    input [2:0] reg_write_address,
    output [2:0] reg_write_address_out,

    output [15:0] read_data1_out,
    output [15:0] read_data2_out,

    input [15:0] ex_inPortValue,
    output [15:0] ex_inPortValue_buff,

    input ex_inPortSelect,
    input ex_inPortSelect_buff,

    input mem_inPortSelect,
    input [15:0] mem_inPortValue,

    // FU
    input [3:0] mem_wb_rdest,
    input mem_wb_reg_write,
    output branch_result
);

    wire [15:0] result;
    wire [2:0] flags;
    wire [2:0] alu_src1_select;
    wire [2:0] alu_src2_select;
    wire [15:0] Op1, Op2;

    // FORWARDING
    forwarding_unit FU (
        .ex_mem_rdest (reg_write_address_out),
        .ex_mem_reg_write (reg_write_out),
        .mem_wb_rdest (mem_wb_rdest),
        .mem_wb_reg_write (mem_wb_reg_write),
        .rsrc (r_scr_buff),
        .rdest (r_dst_buff),
        .ex_inPortSelect (ex_inPortSelect_buff),
        .mem_inPortSelect (mem_inPortSelect),
        .alu_src1_select (alu_src1_select),
        .alu_src2_select (alu_src2_select)
    );

    // BRANCHING
    branch_controller branching (
        .jump_selector (jump_selector),
        .condition_signals (flag_register),
        .result (branch_result)
    );

    assign new_PC =
    (branch_result === 0) ? PC :
    (branch_result === 1) ? {{16{Op1[15]}}, Op1} : PC;

    // BUFFERS  
    var_reg #(.size(16))
    buffer1 (
        .clk (clk),
        .rst(reset),
        .D (result),
        .Q (result_out)
    );

    var_reg #(.size(16))
    buffer123 (
        .clk (clk),
        .rst(reset),
        .D (ex_inPortValue),
        .Q (ex_inPortValue_buff)
    );

    var_reg_flags #(.size(3))
    buffer2 (
        // NOTE : Flag Reg works on negedge of clk
        .clk (clk),
        .rst(reset),
        .en (flagreg_enable),
        .D (flags),
        .Q (flag_register)
    );

    var_reg #(.size(1))
    buffer3 (
        .clk (clk),
        .rst(reset),
        .D (reg_write),
        .Q (reg_write_out)
    );

    var_reg #(.size(2))
    buffer4 (
        .clk (clk),
        .rst(reset),
        .D ({outport_enable, pc_plus_1_or_pc_minus_1}),
        .Q ({outport_enable_out, pc_plus_1_or_pc_minus_1_out})
    );

    var_reg #(.size(5))
    buffer5 (
        .clk (clk),
        .rst(reset),
        .D ({memory_address_select, memory_write_src_select,pc_choose_interrupt}),
        .Q ({memory_address_select_out, memory_write_src_select_out,pc_choose_interrupt_out})
    );

    var_reg #(.size(5))
    buffer6 (
        .clk (clk),
        .rst(reset),
        .D ({wb_sel, reg_write_address}),
        .Q ({wb_sel_out, reg_write_address_out})
    );

    var_reg #(.size(33))
    buffer8 (
        .clk (clk),
        .rst(reset),
        .D ({pc_plus_one, pc_choose_memory}),
        .Q ({pc_plus_one_out, pc_choose_memory_out})
    );

    var_reg #(.size(16))
    buffer10 (
        .clk (clk),
        .rst(reset),
        .D (LDM_value),
        .Q (LDM_value_out)
    );

    var_reg #(.size(32))
    buffer11 (
        .clk (clk),
        .rst(reset),
        .D ({Op1, Op2}),
        .Q ({read_data1_out, read_data2_out})
    );

    var_reg #(.size(1))
    buffer121 (
        .clk (clk),
        .rst(reset),
        .D ({ex_inPortSelect}),
        .Q ({ex_inPortSelect_buff})
    );

    var_reg #(.size(2))
    buffer12 (
        .clk (clk),
        .rst (reset),
        .D ({mem_pop, mem_push}),
        .Q ({mem_pop_out, mem_push_out})
    );

    var_reg #(.size(4))
    buffer131 (
        .clk (clk),
        .rst (reset),
        .D (r_dst_buff),
        .Q (r_dst_buff_ex)
    );

    var_reg #(.size(2))
    buffer13 (
        .clk (clk),
        .rst (reset),
        .D ({mem_read, mem_write}),
        .Q ({mem_read_out, mem_write_out})
    );
    wire flag_regsel_r;
    var_reg #(.size(1))
    buffer14 (
        .clk (clk),
        .rst (reset),
        .D ({flag_regsel}),
        .Q ({flag_regsel_r})
    );

    // ALU
    alu
    alu_dut (
        .clk (clk),
        .carry_sel (carry_sel),
        .alu_src2_select (alu_src2_select),
        .ex_inPortValue (ex_inPortValue_buff),
        .mem_inPortValue (mem_inPortValue),
        .read_data1 (read_data1),
        .read_data2 (read_data2),
        .Op1 (Op1),
        .Op2 (Op2),
        .alu_src1_select (alu_src1_select),
        .alu_src_select (alu_src_select),
        .shamt (shamt),
        .ALU_Op (ALU_Op),
        .write_back_data (write_back_data),
        .alu_result_from_ex (result_out),
        .flag_regsel (flag_regsel_r),
        .flagreg_enable (flagreg_enable),
        .conditions_from_memory_pop (conditions_from_memory_pop),
        .flags (flags),
        .old_flags (flag_register),
        .result (result)
    );

endmodule







