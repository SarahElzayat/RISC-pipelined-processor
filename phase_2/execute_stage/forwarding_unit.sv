module forwarding_unit (
    input [2:0] ex_mem_rdest,
    input ex_mem_reg_write,

    input [2:0] mem_wb_rdest,
    input mem_wb_reg_write,

    input [2:0] rsrc,
    input [2:0] rdest,

    output reg [1:0] alu_src1_select,
    output reg [1:0] alu_src2_select
);

always @(*) begin
    alu_src1_select = 2'b10; // read_data1
    alu_src2_select = 2'b10; // read_data2 or shamt

    if (ex_mem_reg_write === 1'b1 && ex_mem_rdest === rsrc)
        alu_src1_select = 2'b01; // reg_data1_from_mem
    else if (mem_wb_reg_write === 1'b1 && mem_wb_rdest === rsrc)
        alu_src1_select = 2'b00; // write_back_data

    if (ex_mem_reg_write === 1'b1 && ex_mem_rdest === rdest)
        alu_src2_select = 2'b01; // reg_data2_from_mem
    else if (mem_wb_reg_write === 1'b1 && mem_wb_rdest === rdest)
        alu_src2_select = 2'b00; // write_back_data
end

endmodule