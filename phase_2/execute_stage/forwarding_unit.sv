module forwarding_unit (
    input ex_inPortSelect,
    input mem_inPortSelect,
    input [15:0] ex_inPortValue,
    input [15:0] mem_inPortValue,

    input [2:0] ex_mem_rdest,
    input ex_mem_reg_write,

    input [2:0] mem_wb_rdest,
    input mem_wb_reg_write,

    input [3:0] rsrc,
    input [3:0] rdest,

    output reg [2:0] alu_src1_select,
    output reg [2:0] alu_src2_select
);

    /*
in r1
in r1
-----
F D E M W
  F D E M W
    F D E M W

ADD R1, 5
ADD R2, 10
ADD R1, R2

*/


    always @(*) begin
        alu_src1_select = 3'b010; // read_data1
        alu_src2_select = 3'b010; // read_data2 or shamt

        if (ex_mem_reg_write === 1'b1 && ex_mem_rdest === rdest) begin
            alu_src1_select = 3'b001; // ALU RESULT
            if (ex_inPortSelect) alu_src1_select = 3'b011; // ex_inPortValue
        end
        else if (mem_wb_reg_write === 1'b1 && mem_wb_rdest === rdest) begin
            alu_src1_select = 3'b000; // write_back_data
            if (mem_inPortSelect) alu_src1_select = 3'b100; // mem_inPortValue
        end

        if (ex_mem_reg_write === 1'b1 && ex_mem_rdest === rsrc) begin
            alu_src2_select = 3'b001; // ALU RESULT
            if (ex_inPortSelect) alu_src2_select = 3'b011; // ex_inPortValue
        end
        else if (mem_wb_reg_write === 1'b1 && mem_wb_rdest === rsrc) begin
            alu_src2_select = 3'b000; // write_back_data
            if (mem_inPortSelect) alu_src2_select = 3'b100; // mem_inPortValue
        end
    end

endmodule