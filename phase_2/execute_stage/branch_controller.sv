module branch_controller (
    input [2:0] jump_selector,
    input [2:0] condition_signals,

    output reg result
);

wire carry, negative, zero, branch_enable;
wire [1:0] jmp_type;

assign carry = condition_signals[2];
assign negative = condition_signals[1];
assign zero = condition_signals[0];
assign branch_enable = jump_selector[2];
assign jmp_type = jump_selector[1:0];

always @* begin
    if (branch_enable == 1'b1) begin
        case (jmp_type)
            2'b00: // JZ
                if (zero == 1'b1) result = 1;
                else result = 0;
            2'b01: // JN
                if (negative == 1'b1) result = 1;
                else result = 0;
            2'b10: // JC
                if (carry == 1'b1) result = 1;
                else result = 0;
            2'b11: // JMP
                result = 1;

            default: result = 0;
        endcase
    end
    else if (branch_enable == 1'b0) begin
        result = 0;
    end
end

endmodule