module hazard_controller(
    input branch_result,
    input [2:0] R_dest_dec,
    input [2:0] R_src_dec,
    input [2:0] R_dest_fetch,
    input [2:0] R_src_fetch,
    input mem_read_dec,

    output flush_fetch,
    output flush_decode,
    output reg stall_fetch,
    output reg stall_decode,
    output reg pc_write
);

    assign flush_fetch = branch_result === 1'b1 ;
    assign flush_decode = branch_result === 1'b1;

    // Staalling is just inserting a nop instruction in the pipeline at the execute stage and stoping the fetch stage temporarily
    always @(*) begin
        // default values
        stall_fetch = 1'b0;
        stall_decode = 1'b0;
        pc_write = 1'b1;


        if(mem_read_dec === 1'b1 && (R_dest_dec === R_src_fetch || R_dest_dec === R_dest_fetch )) begin
            stall_fetch = 1'b1;
            stall_decode = 1'b1;
            pc_write = 1'b0;
        end
    end

endmodule : hazard_controller
