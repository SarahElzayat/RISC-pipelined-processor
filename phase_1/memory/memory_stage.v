module memory_stage (
    input clk, reset,memory_read, memory_write, memory_push, memory_pop,
    input [15:0] address, write_data,
    output  [15:0] data_r
);

    wire  [15:0] data;

    // Stage REG
    var_reg
    #(.size(16))
    var_reg_dut (
        .D (data ),
        .clk (clk ),
        .Q  ( data_r),
        .rst (reset )
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