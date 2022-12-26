module processor(
    input clk,
    input rst,
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

    wire [1:0] ALUOp;
    wire [1:0] carrySelect;
    wire  write_back_sel, RegWrite, MemRead, MemWrite;
    wire  [15:0] reg_file_read_data1,reg_file_read_data2;
    wire  [15:0] sign_extend_output_from_decode;
    wire  [15:0] sign_extend_output_from_ex;
    wire  [15:0] sign_extend_output_to_wb;

    wire RegWrite_from_mem;
    wire [2:0] write_address_from_wb;
    wire [2:0] write_address_from_decode;


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

    wire  [15:0] ALU_out;
    wire  [15:0] reg_file_read_data1_to_mem ;
    wire  [15:0] reg_file_read_data2_to_mem ;
    wire MemRead_to_mem ,MemWrite_to_mem;
    wire [2:0] write_address_to_mem;
    wire write_back_sel_to_mem;

    execute_stage
    execute_stage_dut (
        .clk (clk ),
        .reset (reset ),
        .carry_sel (carry_sel ),
        .alu_src2_select (alu_src2_select ),
        .read_data1 (read_data1 ),
        .read_data2 (read_data2 ),
        .alu_src1_select (alu_src1_select ),
        .shamt (shamt ),
        .ALU_Op (ALU_Op ),
        .write_back_data (write_back_data ),
        .reg_data1_from_mem (reg_data1_from_mem ),
        .reg_data2_from_mem (reg_data2_from_mem ),
        .jump_selector (jump_selector ),
        .flag_regsel (flag_regsel ),
        .flagreg_enable (flagreg_enable ),
        .conditions_from_memory_pop (conditions_from_memory_pop ),
        .result_out (result_out ),
        .new_PC_out (new_PC_out ),
        .flag_register_out (flag_register_out ),
        .PC (PC ),
        .PC_out (PC_out ),
        .LDM_value (LDM_value ),
        .LDM_value_out (LDM_value_out ),
        .mem_pop (mem_pop ),
        .mem_pop_out (mem_pop_out ),
        .mem_push (mem_push ),
        .mem_push_out (mem_push_out ),
        .reg_write (reg_write ),
        .reg_write_out (reg_write_out ),
        .wb_sel (wb_sel ),
        .wb_sel_out (wb_sel_out ),
        .mem_read (mem_read ),
        .mem_read_out (mem_read_out ),
        .mem_write (mem_write ),
        .mem_write_out (mem_write_out ),
        .pc_enable (pc_enable ),
        .pc_enable_out (pc_enable_out ),
        .memory_address_select (memory_address_select ),
        .memory_address_select_out (memory_address_select_out ),
        .memory_write_src_select (memory_write_src_select ),
        .memory_write_src_select_out  ( memory_write_src_select_out)
    );


    wire  [15:0] ALU_out_to_wb;

    wire [15:0] mem_out;
    wire write_back_sel_to_wb;




    memory_stage
    memory_stage_dut (
        .clk (clk ),
        .reset (reset ),
        . memory_read ( MemRead_to_mem ),
        . memory_write ( MemWrite_to_mem ),
        . memory_push ( 1'b0 ),
        . memory_pop ( 1'b0 ),
        .address (ALU_out ),
        . write_data (reg_file_read_data2_to_mem),
        .data_r  ( mem_out),

        // passing 
        .RegWrite(RegWrite_from_ex),
        .RegWrite_r(RegWrite_from_mem),
        .reg_write_address_r_to_wb(write_address_from_wb),
        .reg_write_address_from_ex(write_address_to_mem),
        .sign_extend_from_ex(sign_extend_output_from_ex),
        .sign_extend_to_wb(sign_extend_output_to_wb),
        .alu_result_from_ex(ALU_out),
        .alu_result_to_wb(ALU_out_to_wb),
        .write_back_select_from_ex(write_back_sel_to_mem),
        .write_back_select_to_wb(write_back_sel_to_wb)
    );


    write_back_stage
    write_back_stage_dut (
        .sel (write_back_sel_to_wb ),
        .immediate_value (sign_extend_output_to_wb),
        . alu_value ( ALU_out_to_wb ),
        .data  ( write_back_data)
    );



endmodule 
