module processor(
    input clk,
    input rst,
    output [2:0] conditionCodeRegister
);
    wire [15:0] instruction;

    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (rst ),
        .instruction_r  ( instruction)
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
        .Op1 (reg_file_read_data1 ),
        .Op2 (reg_file_read_data2 ),
        .AlUmode (ALUOp ),
        .carrySelect (carrySelect),
        .result_r  ( ALU_out),
        .conditionCodeRegister_r (conditionCodeRegister),
        .RegWrite_r (RegWrite_from_ex ),
        .RegWrite(RegWrite),
        .reg_write_address_to_memory(write_address_to_mem),
        .reg_write_address_from_decode(write_address_from_decode),
        .sign_extend_from_decode(sign_extend_output_from_decode),
        .sign_extend_to_memory(sign_extend_output_from_ex),
        .write_back_select_from_decode(write_back_sel),
        .write_back_select_to_memory(write_back_sel_to_mem),
        .reg_file_read_data1_from_decode(reg_file_read_data1),
        .reg_file_read_data2_from_decode(reg_file_read_data2),
        .reg_file_read_data1_to_mem(reg_file_read_data1_to_mem),
        .reg_file_read_data2_to_mem(reg_file_read_data2_to_mem),
        .memRead_from_decode (MemRead)  ,
        .memRead_to_mem (MemRead_to_mem)      ,
        .memWrite_from_decode(MemWrite),
        .memWrite_to_mem(MemWrite_to_mem)
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
