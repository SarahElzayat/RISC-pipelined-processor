module var_reg #(parameter size = 8)(
    input [size-1:0] D,
    input clk,
    input rst,
    output reg [size-1:0] Q
);

    always @(posedge clk)
    begin
        if (rst)
            Q <= 'bx;
        else
            Q <= D;
    end
endmodule 
