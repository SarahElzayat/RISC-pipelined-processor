module memory_stage (
    input clk, reset,memory_read, memory_write, memory_push, memory_pop,
    input [15:0] std_address, ldd_address, //read data1 & read data
    input [1:0] memory_address_select, memory_write_src_select,
    input[31:0] pc,
    input [2:0] flags,
    output [15:0] data_r, //wire on the inside
    output [31:0] shift_reg //reg on the inside
);

wire [15:0] data;
var_reg #(.size(16))
data_reg (
  .D (data ),
  .clk (clk ),
  .Q  (data_r),
  .rst (reset)
);

memory_stage_without_buffers
memory_stage_without_buffers_dut (
    .clk (clk ),
    .reset (reset ),
    .memory_read (memory_read ),
    .memory_write (memory_write ),
    .memory_push (memory_push ),
    .memory_pop (memory_pop ),
    .std_address (std_address ),
    .ldd_address (ldd_address ),
    .memory_address_select (memory_address_select ),
    .memory_write_src_select (memory_write_src_select ),
    .pc (pc ),
    .flags (flags ),
    .data  ( data),
    .shift_reg(shift_reg)
  );

endmodule