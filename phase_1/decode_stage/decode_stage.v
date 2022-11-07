module decode_stage(
    input clk,
    input rst,
    input [15:0] instruction,
    output[1:0] ALUOp,
    output ALUtoReg, RegWrite, MemRead, MemWrite,

);

    wire [15:0] inst;

    ControlUnit
    ControlUnit_dut (
        .inst (inst ),
        .ALUOp (ALUOp ),
        .ALUtoReg (ALUtoReg ),
        .RegWrite (RegWrite ),
        .MemRead (MemRead ),
        .MemWrite  ( MemWrite)
    );

    wire RegWrite;
    wire [2:0] write_address;
    wire [15:0] write_data;
    wire [2:0] read_address1,read_address2
    wire [15:0] read_data1,read_data12

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
        .write_address (write_address ),
        .write_data (write_data ),
        .read_address1 (read_address1 ),
        .read_address2 (read_address2 ),
        .read_data1 (read_data1 ),
        .read_data2  ( read_data2)
    );


    sign_extend
    sign_extend_dut (
        .in (in ),
        .out  ( out)
    );


endmodule
