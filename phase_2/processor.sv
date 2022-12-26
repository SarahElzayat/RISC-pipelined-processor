module processor(
    input clk,
    input rst,
    output [15:0]  input_port,
    output [15:0]  out_port
);
    wire [15:0] instruction;

    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (reset ),
        .pc_write (pc_write ),
        .pc_write_back_value (pc_write_back_value ),
        .clear_instruction (clear_instruction ),
        .pc_plus_one_r (pc_plus_one_r ),
        .instruction_r  ( instruction_r)
    );




    wire[15:0] write_back_data;

    wire [3:0] ALU_Op;
    wire [1:0] carry_sel;
    wire wb_sel, reg_write, mem_read, mem_write;
    wire [1:0] alu_src1_select, alu_src2_select;
    wire [15:0] reg_file_read_data1, reg_file_read_data2;
    wire [15:0] sign_extend_output_from_decode;
    wire [15:0] sign_extend_output_from_ex;
    wire [15:0] sign_extend_output_to_wb;

    wire RegWrite_from_mem;
    wire [2:0] write_address_from_wb;
    wire [2:0] write_address_from_decode;
    wire mem_push_out, mem_pop_out, mem_read_out, mem_write_out;


    decode_stage
    decode_stage_dut (
        .clk (clk ),
        .rst (rst ),
        .instruction (instruction ),
        .regFile_write_data (write_back_data),
        .ALUOp_r (ALUOp ),
        .carrySelect_r (carrySelect),
        .WB_ALUtoReg_r (write_back_sel ),
        .RegWrite_r (RegWrite ),
        .MemRead_r ( MemRead ),
        .MemWrite_r (MemWrite ),
        .reg_file_read_data1_r (reg_file_read_data1 ),
        .reg_file_read_data2_r (reg_file_read_data2 ),
        .sign_extend_output_r  ( sign_extend_output_from_decode),
        .regFile_write_from_wb(RegWrite_from_mem),
        .reg_write_address_from_wb(write_address_from_wb),
        .reg_write_address_r(write_address_from_decode)

    );


    wire RegWrite_from_ex;

    wire [15:0] ALU_out, read_data1_out, read_data2_out;
    wire [2:0] write_address_to_mem;
    wire [4:0] shamt;

    execute_stage
    execute_stage_dut (
        .clk (clk),
        .reset (reset),
        .carry_sel (carry_sel),
        .alu_src2_select (alu_src2_select),
        .read_data1 (read_data1),
        .read_data2 (read_data2),
        .alu_src1_select (alu_src1_select),
        .shamt (shamt),
        .ALU_Op (ALU_Op),
        .write_back_data (write_back_data),
        .reg_data1_from_mem (reg_data1_from_mem),
        .reg_data2_from_mem (reg_data2_from_mem),
        .read_data1_out (read_data1_out),
        .read_data2_out (read_data2_out),
        .jump_selector (jump_selector),
        .flag_regsel (flag_regsel),
        .flagreg_enable (flagreg_enable),
        .conditions_from_memory_pop (conditions_from_memory_pop),
        .result_out (result_out),
        .new_PC_out (new_PC_out),
        .flag_register_out (flag_register_out),
        .PC (PC),
        .PC_out (PC_out),
        .LDM_value (LDM_value),
        .LDM_value_out (LDM_value_out),
        .mem_pop (mem_pop),
        .mem_pop_out (mem_pop_out),
        .mem_push (mem_push),
        .mem_push_out (mem_push_out),
        .reg_write (reg_write),
        .reg_write_out (reg_write_out),
        .wb_sel (wb_sel),
        .wb_sel_out (wb_sel_out),
        .mem_read (mem_read),
        .mem_read_out (mem_read_out),
        .mem_write (mem_write),
        .mem_write_out (mem_write_out),
        .pc_enable (pc_enable),
        .pc_enable_out (pc_enable_out),
        .memory_address_select (memory_address_select),
        .memory_address_select_out (memory_address_select_out),
        .memory_write_src_select (memory_write_src_select),
        .memory_write_src_select_out (memory_write_src_select_out)
    );


    wire [15:0] ALU_out_to_wb;

    wire write_back_sel_to_wb;

    

    
    wire [15:0] mem_data;
    wire [31:0] shift_reg;
    wire [15:0] mem_ldm_value;
    wire [15:0] mem_reg_write;
    wire [15:0] mem_wb_sel;
    wire [15:0] mem_pc_enable;
    memory_stage
    memory_stage_dut (
        .clk (clk),
        .reset (reset),
        .memory_read ( mem_read_out ),
        .memory_write ( mem_write_out ),
        . memory_push ( mem_push_out ),
        . memory_pop ( mem_pop_out ),
        .std_address(read_data1_out),
        .ldd_address(read_data2_out),
        . memory_address_select ( memory_address_select_out ),
        . memory_write_src_select ( memory_write_src_select_out ),
        .pc (PC_out),
        .flags (flag_register_out),
        .data_r  ( mem_data),
        .shift_reg  ( shift_reg),

        // passing 

        .LDM_value(LDM_value_out),
        .LDM_value_out(mem_ldm_value),

        .reg_write(reg_write_out),
        .reg_write_out(mem_reg_write),
        
        .wb_sel(wb_sel_out),
        .wb_sel_out(mem_wb_sel),

        .pc_enable(pc_enable_out),
        .pc_enable_out(mem_pc_enable)
    );










    
    write_back_stage
    write_back_stage_dut (
        .clk (clk ),
        .rst (rst ),
        .sel (write_back_sel_to_wb ),
        .outport_enable (outport_enable ),
        .immediate_value (immediate_value ),
        .alu_value (ALU_out_to_wb ),
        .mem_data (mem_data ),
        .data (write_back_data ),
        .outport  (out_port)
    );



endmodule 
