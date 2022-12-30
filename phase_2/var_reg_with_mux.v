module var_reg_with_mux #(parameter size = 8)(
    input [size-1:0] D,
    input clk,
    input rst,
    input mux_clear,
    output reg [size-1:0] Q
);

    always @(posedge clk, posedge rst)
    begin
        if (rst)
            Q <= 'bz;
        else if (mux_clear)
            Q <= 'b0;
        else
            Q <= D;
    end
endmodule 
