module write_back_stage (
    immediate_value,
    alu_value,
    sel,
    data
);

input sel;
input [15:0] immediate_value, alu_value;
output reg [15:0] data;

assign data = (sel == 0)? immediate_value:
            (sel == 1)? alu_value: 16'bz;
    
endmodule