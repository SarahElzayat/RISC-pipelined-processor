module fetch_stage (
    input clk,
    input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
    input pc_enable,
    input pc_write,
    input [15:0] pc_write_back_value,
    input clear_instruction, //overrides the current instruction with NOP (selector of the output mux)
    output [31:0] pc_plus_one_r,
    output [15:0] instruction_r
  );

  wire [15:0] instruction;
  var_reg #(.size(16))
          instruction_reg (
            .D (instruction ),
            .clk (clk ),
            .Q  (instruction_r ),
            .rst (reset)
          );


  wire [31:0] pc_plus_one;
  var_reg #(.size(32))
          pc_plus_one_reg (
            .D (pc_plus_one ),
            .clk (clk ),
            .Q  (pc_plus_one_r ),
            .rst (reset)
          );

  mem_fetch
    mem_fetch_dut (
      .clk (clk ),
      .reset (reset ),
      .pc_enable(pc_enable),
      .pc_write(pc_write),
      .pc_write_back_value( pc_write_back_value),
      .clear_instruction(clear_instruction),
      .pc_plus_one(pc_plus_one_r),
      .instruction  (instruction)
    );



endmodule







