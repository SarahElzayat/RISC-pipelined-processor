module decode_stage(
    input clk,
    input rst
);
    wire [15:0] inst;

    wire [15:0] inst;
    wire ALUOp, ALUtoReg, RegWrite, MemRead, MemWrite;

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
