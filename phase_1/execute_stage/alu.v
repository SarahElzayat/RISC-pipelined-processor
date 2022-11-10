module alu(
    input [15:0] Op1,
    input [15:0] Op2,
    input [1:0]  AlUmode,
    output reg [15:0] result
);
    // we stick to dest being the first operand
    wire reg [15:0] result_s;

    var_reg  #(.size(16))
    pip_EX_MEM (
        .clk (clk ),
        .D (result_s ),
        .Q  ( result)
    );

    always @* begin
        case (AlUmode)
            //Add
            2'b00 : result_s = Op1 + Op2;
            //NOT
            2'b01 : result_s =  ~Op1;
            //PASS dest Register
            2'b10 : result_s = Op1;
            //NOP
            2'b11 : result_s = 16'b0;
            default : result_s = 16'b0;
        endcase
    end

endmodule 