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



endmodule