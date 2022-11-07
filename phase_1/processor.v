module processor(
    input clk,
    input rst
);

    wire [15:0]instruction;

    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (rst ),
        .instruction  ( instruction)
    );

    wire[15:0] write_back_data;

    wire [1:0] ALUOp;
    wire  WB_ALUtoReg, RegWrite, MemRead, MemWrite;
    wire  [15:0] reg_file_read_data1,reg_file_read_data2;
    wire  [15:0] sign_extend_output;

    decode_stage
    decode_stage_dut (
        .clk (clk ),
        .rst (rst ),
        .instruction (instruction ),
        .regFile_write_data (write_back_data ),
        .ALUOp (ALUOp ),
        .WB_ALUtoReg (WB_ALUtoReg ),
        .RegWrite (RegWrite ),
        .MemRead (MemRead ),
        .MemWrite (MemWrite ),
        .reg_file_read_data1 (reg_file_read_data1 ),
        .reg_file_read_data2 (reg_file_read_data2 ),
        .sign_extend_output  ( sign_extend_output)
    );

    wire  [15:0] ALU_out;
    alu
    alu_dut (
        .Op1 (reg_file_read_data1 ),
        .Op2 (reg_file_read_data2 ),
        .AlUmode (ALUOp ),
        .result  ( ALU_out)
    );


    wire [15:0] mem_out;
    memory_stage
    memory_stage_dut (
        .clk (clk ),
        . memory_read ( MemRead ),
        . memory_write ( MemWrite ),
        . memory_push ( 0 ),
        . memory_pop ( 0 ),
        .address (ALU_out ),
        . write_data ( reg_file_read_data1 ),
        .data  ( mem_out)
    );


    write_back_stage
    write_back_stage_dut (
        .sel (WB_ALUtoReg ),
        .immediate_value (sign_extend_output ),
        . alu_value ( ALU_out ),
        .data  ( write_back_data)
    );



endmodule 
