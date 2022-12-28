module hazard_controller(
    input branch_result,
    input [15:0] R1_dec,
    input [15:0] R2_dec,
    input [15:0] R1_fetch,
    input [15:0] R2_fetch,

    output flush_fetch,
    output flush_decode,
    output stall_fetch,
    output stall_decode,
    output pc_write
);

    assign flush_fetch = branch_result === 1'b1 ;
    assign flush_decode = branch_result === 1'b1;

    // Staalling is just inserting a nop instruction in the pipeline at the execute stage and stoping the fetch stage temporarily


endmodule : hazard_controller
