module memory_stage (
    input clk, reset,memory_read, memory_write, memory_push, memory_pop,
    input [15:0] address, write_data,
    output  [15:0] data_r,
    // inputs to ust pass
    input RegWrite,
    output RegWrite_r,
    input[2:0] reg_write_address_from_ex,
    output[2:0] reg_write_address_r_to_wb,
    input [15:0] sign_extend_from_ex,
    output [15:0] sign_extend_to_wb,
    input [15:0] alu_result_from_ex,
    output [15:0] alu_result_to_wb,
    input write_back_select_from_ex,
    output write_back_select_to_wb

);

    wire  [15:0] data;

    // Stage REG
    var_reg
    #(.size(17))
    var_reg_dut (
        .D ({data ,RegWrite } ),
        .clk (clk ),
        .Q  ( {data_r,RegWrite_r}),
        .rst (reset )
    );


    var_reg #(
    .size(3)
    ) var_reg_instance(
        .D(reg_write_address_from_ex),
        .clk(clk),
        .rst(rst),
        .Q(reg_write_address_r_to_wb)
    );

    var_reg #(
    .size(16)
    ) var_reg_instance2(
        .D(sign_extend_from_ex),
        .clk(clk),
        .rst(rst),
        .Q(sign_extend_to_wb)
    );

    var_reg #(
    .size(16)
    ) var_reg_instance3(
        .D(alu_result_from_ex),
        .clk(clk),
        .rst(rst),
        .Q(alu_result_to_wb)
    );

    var_reg #(
    .size(1)
    ) var_reg_instance4(
        .D(write_back_select_from_ex),
        .clk(clk),
        .rst(rst),
        .Q(write_back_select_to_wb)
    );


    reg [31:0] SP = (2**11) - 1; //stack pointer pointing at the last entry // @suppress "Register initialization in declaration. Consider using an explicit reset instead"
    reg [15:0] data_memory [0: (2 ** 11) -1]; //data memory of 4KB 

    assign data = (memory_read == 1) ? data_memory[address]:
    (memory_pop == 1) ? data_memory[SP[10:0]]:  16'bz;



    always @(posedge clk) begin

        if(memory_write)
        begin
            data_memory[address[10:0]] = write_data;
        end

        if (memory_push) begin
            SP = SP - 1;
            data_memory[SP] = write_data;
        end

        if (memory_pop)
        begin
            SP = SP + 1;
        end
    end

endmodule