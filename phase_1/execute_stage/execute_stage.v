module execute_stage (
    input clk, // Clock
    input reset, // The reset signal resets the PC to 2^5 (First address of the instructions memory)
    input [15:0] Op1, // First operand
    input [15:0] Op2, // Second operand
    input [1:0] AlUmode, // ALU Operation
    output [15:0] result_r, // ALU Result
    output [2:0] conditionCodeRegister_r, // Carry, negative, zero
    input [1:0] carrySelect, // Set, reset, ALU

    // inputs to just pass to the next stage
    input RegWrite,
    output RegWrite_r,

    input [2:0] reg_write_address_from_decode,
    output [2:0] reg_write_address_to_memory,

    input [15:0] sign_extend_from_decode,
    output [15:0] sign_extend_to_memory,

    input write_back_select_from_decode,
    output write_back_select_to_memory,

    input [15:0] reg_file_read_data1_from_decode,
    input [15:0] reg_file_read_data2_from_decode,

    output [15:0] reg_file_read_data1_to_mem,
    output [15:0] reg_file_read_data2_to_mem,

    input memRead_from_decode,
    output memRead_to_mem,

    input memWrite_from_decode,
    output memWrite_to_mem
);

    // ALU Result
    wire [15:0] result;
    var_reg  #(.size(16))
    pip_EX_MEM (
        .clk (clk),
        .rst(reset),
        .D (result),
        .Q (result_r)
    );

    // Condition Code Register
    wire [2:0] conditionCodeRegister;
    var_reg  #(.size(3))
    pip_EX_MEMM (
        .clk (clk),
        .rst(reset),
        .D (conditionCodeRegister),
        .Q (conditionCodeRegister_r)
    );

    // RegWrite signal
    var_reg  #(.size(1))
    pip_EX_MEM_regs (
        .clk (clk),
        .rst(reset),
        .D (RegWrite),
        .Q (RegWrite_r)
    );

    // RegWrite address
    var_reg  #(.size(3))
    pip_EX_MEM_regs2 (
        .clk (clk),
        .rst(reset),
        .D (reg_write_address_from_decode),
        .Q (reg_write_address_to_memory)
    );

    // Signed-extended bits
    var_reg  #(.size(16))
    pip_EX_MEM_regs3 (
        .clk (clk),
        .rst(reset),
        .D (sign_extend_from_decode),
        .Q (sign_extend_to_memory)
    );

    // Write-back signal
    var_reg  #(.size(1))
    pip_EX_MEM_regs4 (
        .clk (clk),
        .rst(reset),
        .D (write_back_select_from_decode),
        .Q (write_back_select_to_memory)
    );

    // Read_Data 1 & 2
    var_reg  #(.size(16*2))
    pip_EX_MEM_regs45 (
        .clk (clk ),
        .rst(reset),
        .D ({
        reg_file_read_data1_from_decode,
        reg_file_read_data2_from_decode
        }),
        .Q ({
        reg_file_read_data1_to_mem,
        reg_file_read_data2_to_mem
        })
    );

    // memRead & memWrite signals
    var_reg  #(.size(2))
    pip_EX_MEM_regs5 (
        .clk (clk),
        .rst (reset),
        .D ({memRead_from_decode,
        memWrite_from_decode
        }),
        .Q ({
        memRead_to_mem,
        memWrite_to_mem
        })
    );

    // ALU
    alu
    alu_dut (
        .Op1 (Op1),
        .Op2 (Op2),
        .AlUmode (AlUmode),
        .carrySelect (carrySelect),
        .conditionCodeRegister (conditionCodeRegister),
        .result (result)
    );

endmodule







