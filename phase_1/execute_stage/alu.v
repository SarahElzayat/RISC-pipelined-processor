module alu(
    input [15:0] Op1,
    input [15:0] Op2,
    input [1:0]  AlUmode,
    input [1:0] carrySelect,
    output [2:0] conditionCodeRegister,
    output reg [15:0] result
);
    // We stick to destination being the first operand

    reg carry;
    wire zero, negative;


    always @* begin
        carry = 0;
        case (AlUmode)
            //Add
            2'b00: 
                {carry, result} = Op1 + Op2;

            //NOT
            2'b01: result =  ~Op1;
            //PASS dest Register
            2'b10: result = Op1;
            //NOP
            2'b11: result = 16'b0;

            default: result = 16'b0;
        endcase
    end



    assign negative = result[15];
    assign zero = (result == 0);



    assign conditionCodeRegister = {carry, negative, zero};

endmodule