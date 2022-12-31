module hazard_controller(
    input branch_result,
    input [3:0] R_dest_dec,
    input [3:0] R_src_dec,
    input [3:0] R_dest_fetch,
    input [3:0] R_src_fetch,
    input mem_read_dec,
    output flush_fetch,
    output reg  stall_fetch,
    output flush_decode,
    output reg pc_write
);

    reg clear_control_signals;
    assign flush_fetch = branch_result === 1'b1 ;
    assign flush_decode = clear_control_signals | branch_result === 1'b1;

    // Staalling is just inserting a nop instruction in the pipeline at the execute stage and stoping the fetch stage temporarily
    always @(*) begin
        // default values
        clear_control_signals = 1'b0;
        pc_write = 1'b1;
        stall_fetch = 1'b0;

        if(mem_read_dec === 1'b1 && (R_dest_dec === R_src_fetch || R_dest_dec === R_dest_fetch )) begin
            clear_control_signals = 1'b1;
            pc_write = 1'b0;
            stall_fetch = 1'b1;
        end
    end

endmodule : hazard_controller
