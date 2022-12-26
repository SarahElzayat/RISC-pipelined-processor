module var_reg_with_enable #(parameter size = 8)(
    input [size-1:0] D,
    input clk,
    input en,
    input rst,
    output reg [size-1:0] Q
);

    always @(posedge clk)
    begin
        if (rst)
            Q <= 'bx;
        else
            if (en)
                Q <= D;
    end
endmodule 
