module sign_extend
# (
    parameter IN_WIDTH = 10,
    parameter OUT_WIDTH = 16
)
(
    input [IN_WIDTH -1 :0] in,
    output [OUT_WIDTH-1:0] out
);
    assign out = {{OUT_WIDTH{in[IN_WIDTH-1]}}, in};
endmodule