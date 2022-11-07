module decode_stage(
    input clk,
    input rst,
    input [15:0] instruction,
    //from write back
    input [15:0] regFile_write_data,

    output[1:0] ALUOp,
    output WB_ALUtoReg, RegWrite, MemRead, MemWrite,
    output [15:0] reg_file_read_data1,reg_file_read_data2,
    output [15:0] sign_extend_output

);


    ControlUnit
    ControlUnit_dut (
        .inst (instruction ),
        .ALUOp (ALUOp ),
        .WB_ALUtoReg (WB_ALUtoReg ),
        .RegWrite (RegWrite ),
        .MemRead (MemRead ),
        .MemWrite  ( MemWrite)
    );

    reg_file
    #(
    .WIDTH(16 ),
    .N_REGS (
    8 )
    )
    reg_file_dut (
        .clk (clk ),
        .rst (rst ),
        .RegWrite (RegWrite ),
        .write_address (regFile_write_address ),
        .write_data (regFile_write_data ),
        .read_address1 (instruction[15:13] ),
        .read_address2 (instruction[12:10] ),
        .read_data1 (reg_file_read_data1 ),
        .read_data2  ( reg_file_read_data2)
    );

    sign_extend
    sign_extend_dut (
        .in (instruction[9:0]),
        .out  ( sign_extend_output)
    );


endmodule
