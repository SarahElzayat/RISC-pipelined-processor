module execute_stage (
    input clk,
    input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
    input [15:0] Op1,
    input [15:0] Op2,
    input [1:0]  AlUmode,
    output  [15:0] result_r,

    // inputs to just pass
    input RegWrite,
    output RegWrite_r,
    input[2:0] reg_write_address_from_decode,
    output[2:0] reg_write_address_to_memory

);

    wire [15:0] result;
    var_reg  #(.size(16))
    pip_EX_MEM (
        .clk (clk ),
        .rst(reset),
        .D (result ),
        .Q  ( result_r)
    );

    var_reg  #(.size(1))
    pip_EX_MEM_regs (
        .clk (clk ),
        .rst(reset),
        .D (RegWrite ),
        .Q  ( RegWrite_r)
    );

    var_reg  #(.size(3))
    pip_EX_MEM_regs2 (
        .clk (clk ),
        .rst(reset),
        .D (reg_write_address_from_decode ),
        .Q  ( reg_write_address_to_memory)
    );

    alu
    alu_dut (
        .Op1 (Op1 ),
        .Op2 (Op2 ),
        .AlUmode (AlUmode ),
        .result  ( result)
    );


endmodule







