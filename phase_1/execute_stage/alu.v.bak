module alu(
    input [15:0] Op1,
    input [15:0] Op2,
    input [1:0]  AlUmode,
    input [1:0] carrySelect,
    output [2:0] conditionCodeRegister,
    output reg [15:0] result
);
    // We stick to destination being the first operand

    always @* begin
        case (AlUmode)
            //Add
            2'b00:  result = Op1 + Op2;
            //NOT
            2'b01: result =  ~Op1;
            //PASS dest Register
            2'b10: result = Op1;
            //NOP
            2'b11: result = 16'b0;

            default: result = 16'b0;
        endcase
    end

    reg carry, zero, negative;
    reg [16:0] sum;

    always @* begin
        // Negative
        if (result[15]) negative = 1;
        else negative = 0;

        // Zero
        if (result == 0) zero = 1;
        else zero = 0;

        // Carry
        case (carrySelect)
            // Reset
            2'b00: carry = 0;
            // Set
            2'b01: carry = 1;
            // ALU
            2'b10:
            if (AlUmode == 2'b00) begin
                sum = Op1 + Op2;
                result = sum[15:0];
                carry = sum[16];
            end
            else begin
                carry = 0;
            end

            default: carry = 0;
        endcase
    end

    assign conditionCodeRegister = {carry, negative, zero};

endmodule