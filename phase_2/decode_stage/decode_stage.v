module decode_stage(
    input clk,
    input rst,
    input [15:0] instruction,
    output[1:0] ALUOp_r,
    output[1:0] carrySelect_r,
    output        WB_ALUtoReg_r, RegWrite_r, MemRead_r, MemWrite_r,
    output [15:0] reg_file_read_data1_r,reg_file_read_data2_r,
    output [15:0] sign_extend_output_r,
    //from or to write back
    input [15:0] regFile_write_data,
    input  regFile_write_from_wb,
    input[2:0] reg_write_address_from_wb,
    output[2:0] reg_write_address_r


);


    wire[1:0] ALUOp;
    wire[1:0] carrySelect;
    wire WB_ALUtoReg, RegWrite, MemRead, MemWrite;
    wire [15:0] reg_file_read_data1,reg_file_read_data2;
    wire [15:0] sign_extend_output;



    var_reg
    #(.size(56))
    var_reg_dut (
        .D ({ALUOp, carrySelect, WB_ALUtoReg, RegWrite, MemRead, MemWrite,
        reg_file_read_data1,reg_file_read_data2,
        sign_extend_output} ),
        .clk (clk ),
        .Q  ( {ALUOp_r, carrySelect_r, WB_ALUtoReg_r, RegWrite_r, MemRead_r, MemWrite_r,
        reg_file_read_data1_r,reg_file_read_data2_r,
        sign_extend_output_r}),
        .rst (rst)
    );

    
    var_reg #(
    .size(3)
    ) var_reg_instance(
        .D(instruction[12:10] ),
        .clk(clk),
        .rst(rst),
        .Q(reg_write_address_r)
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
        // TODO 
        .RegWrite (regFile_write_from_wb ),
        .write_address (reg_write_address_from_wb),
        .write_data (regFile_write_data ),
        // 12 11 10 9 8 7 6 5 4 3 2 1 0
        .read_address1 (instruction[12:10] ),
        .read_address2 (instruction[9:7] ),
        .read_data1 (reg_file_read_data1 ),
        .read_data2  ( reg_file_read_data2)
    );

    sign_extend
    sign_extend_dut (
        .in (instruction[9:0]),
        .out  ( sign_extend_output)
    );
endmodule
