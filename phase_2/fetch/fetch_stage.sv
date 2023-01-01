module fetch_stage (
  input clk,
  input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
  input pc_write,
  input stall_fetch,
  input [31:0] pc_write_back_value,
  input clear_instruction, //overrides the current instruction with NOP (selector of the output mux)
  output [31:0] pc_plus_one_s,
  output [31:0] pc_plus_one_r,
  output [15:0] instruction_r,
  output [15:0] immediate_value
);

  wire [15:0] instruction;
  var_reg_with_enable #(.size(16))
  instruction_reg (
    .D (instruction ),
    .clk (clk ),
    .en(~stall_fetch),
    .Q  (instruction_r ),
    .rst (reset)
  );

  // wire [15:0] immediate_value_s;
  // var_reg #(.size(16))
  // immediate_value_reg (
  //   .D (immediate_value_s ),
  //   .clk (clk ),
  //   .Q  (immediate_value ),
  //   .rst (reset)
  // );


  var_reg_with_enable #(.size(32))
  pc_plus_one_reg (
    .D (pc_plus_one_s ),
    .clk (clk ),
    .en(~stall_fetch),
    .Q  (pc_plus_one_r ),
    .rst (reset)
  );

  mem_fetch
  mem_fetch_dut (
    .clk (clk ),
    .reset (reset ),
    .pc_write(pc_write),
    .pc_write_back_value( pc_write_back_value),
    .clear_instruction(clear_instruction),
    .pc_plus_one(pc_plus_one_s),
    .instruction  (instruction),
    .immediate_value(immediate_value)
  );


endmodule







