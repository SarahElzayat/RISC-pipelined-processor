module write_back_stage (
    input clk,rst ,
    input [1:0] sel,
    input outport_enable,
    input [15:0] immediate_value, alu_value, mem_data, input_port_val,
    output  [15:0] data,
    output  [15:0] outport
);

    assign data = (sel === 2'b00)? immediate_value:
    (sel === 2'b01)? alu_value:
    (sel === 2'b10)? mem_data:
    ( sel === 2'b11)? input_port_val:
    16'bz;


    var_reg_with_enable
    #(
    .size (
    16 )
    )
    var_reg_with_enable_dut (
        .D (data),
        .clk (clk ),
        .en (outport_enable ),
        .rst (rst ),
        .Q  ( outport)
    );


endmodule