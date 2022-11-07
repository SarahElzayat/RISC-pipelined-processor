module processor(
    input clk,
    input rst
);

    wire [15:0]instruction;

    fetch_stage
    fetch_stage_dut (
        .clk (clk ),
        .reset (reset ),
        .instruction  ( instruction)
    );

    



endmodule 
