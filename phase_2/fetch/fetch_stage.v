module fetch_stage (
    input clk,
    input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
    output [15:0] instruction_r
);

    wire [15:0] instruction;
    var_reg #(.size(16))
    var_reg_dut (
        .D (instruction ),
        .clk (clk ),
        .Q  (instruction_r ),
        .rst (reset)
    );

    mem_fetch
    mem_fetch_dut (
        .clk (clk ),
        .reset (reset ),
        .instruction  ( instruction)
    );



endmodule







