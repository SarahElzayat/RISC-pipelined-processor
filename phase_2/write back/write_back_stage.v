module write_back_stage (
    input [1:0] sel,
    input [15:0] immediate_value, alu_value, mem_data,
    output  [15:0] data
);

    assign data = (sel == 2'b00)? immediate_value:
                  (sel == 2'b01)? alu_value:
                  (sel == 2'b10)? alu_value: 16'bz;
                  (sel == 2'b01)? alu_value: 16'bz;


endmodule