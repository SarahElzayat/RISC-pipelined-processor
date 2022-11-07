module alu(
    input [15:0] Op1,
    input [15:0] Op2,
    input [1:0]  AlUmode,
    output reg [15:0] result
);

    always @* begin
        case (AlUmode)
            //Add
            2'b00 : result = Op1 + Op2;
            //NOT
            2'b01 : result =  ~Op1;
            //PASS dest Register
            2'b10 : result = Op2;
            //NOP
            2'b11 : result = 16'b0;
            default : result = 16'b0;
        endcase
    end

endmodule 