module alu (
    input clk,
    input [1:0] carry_sel,
    input [2:0] alu_src2_select,
    input [15:0] read_data1,
    input [15:0] read_data2,
    input [2:0] alu_src1_select,
    input alu_src_select,
    input [3:0] shamt,
    input [3:0] ALU_Op,
    input [15:0] write_back_data,
    input [15:0] alu_result_from_ex,
    input flag_regsel,
    input flagreg_enable,
    input [15:0] ex_inPortValue,
    input [15:0] mem_inPortValue,
    input [2:0] conditions_from_memory_pop,

    output reg [2:0] flag_register,
    output reg [15:0] result,
    output  [15:0] Op1,
    output  [15:0] Op2
);

    reg alu_carry;
    wire carry, zero, negative;
    wire [2:0] alu_flags;

    wire [15:0]  firstMux;

    assign Op1 =
    (alu_src1_select === 3'b000) ? write_back_data :
    (alu_src1_select === 3'b001) ? alu_result_from_ex :
    (alu_src1_select === 3'b010) ? read_data1 :
    (alu_src1_select === 3'b011) ? ex_inPortValue :
    (alu_src1_select === 3'b100) ? mem_inPortValue : 'bz;

    assign firstMux =
    (alu_src_select === 1'b0) ? read_data2 :
    (alu_src_select === 1'b1) ? shamt : 'bz;

    assign Op2 =
    (alu_src2_select === 3'b000) ? write_back_data :
    (alu_src2_select === 3'b001) ? alu_result_from_ex :
    (alu_src2_select === 3'b010) ? firstMux :
    (alu_src2_select === 3'b011) ? ex_inPortValue :
    (alu_src2_select === 3'b100) ? mem_inPortValue : 'bz;
    always @* begin
        alu_carry = 0;
        case (ALU_Op)
            4'b0000: result = ~Op1;

            4'b0001: {alu_carry, result} = Op1 + 1;

            4'b0010: {alu_carry, result} = Op1 - 1;

            4'b0011: {alu_carry, result} = Op1 + Op2;

            4'b0100: {alu_carry, result} = Op2 - Op1;

            4'b0101: {alu_carry, result} = Op1 & Op2;

            4'b0110: {alu_carry, result} = Op1 | Op2;

            4'b0111: {alu_carry, result} = {alu_carry, Op1} << Op2;

            4'b1000: {result, alu_carry} = {Op1, alu_carry} >> Op2;

            default: result = Op2;
        endcase
    end

    assign negative = result[15];
    assign zero = (result === 0);

    assign carry =
    (carry_sel === 2'b00) ? alu_carry :
    (carry_sel === 2'b01) ? 1 :
    (carry_sel === 2'b10) ? 0 : 'bz;

    assign alu_flags = {carry, negative, zero};

    always @(negedge clk) begin
        flag_register =
        (flag_regsel === 1'b0) ? alu_flags :
        (flag_regsel === 1'b1) ? conditions_from_memory_pop : 'bz;
    end

endmodule