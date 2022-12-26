module execute_stage_tb;
// Parameters
parameter T = 10;

// Inputs
reg clk, reset;
reg flag_regsel, flagreg_enable;
reg mem_pop, mem_push, mem_read, mem_write, pc_enable, reg_write;
reg [1:0] carry_sel, alu_src1_select, alu_src2_select, memory_address_select, memory_write_src_select, wb_sel;
reg [15:0] read_data1, read_data2, LDM_value;
reg [15:0] write_back_data, reg_data1_from_mem, reg_data2_from_mem;
reg [2:0] conditions_from_memory_pop, jump_selector;
reg [3:0] ALU_Op;
reg [4:0] shamt;
reg [31:0] PC;

// Outputs
wire [15:0] ALU_result;
wire [2:0] conditionCodeRegister;

execute_stage 
execute_stage_dut (
  .clk (clk),
  .reset (reset),
  .read_data1 (read_data1),
  .read_data2 (read_data2),
  .ALU_Op (ALU_Op),
  .carry_sel (carry_sel),
  .mem_pop (mem_pop),
  .mem_push (mem_push),
  .mem_read (mem_read),
  .mem_write (mem_write),
  .pc_enable (pc_enable),
  .LDM_value (LDM_value),
  .reg_data1_from_mem (reg_data1_from_mem),
  .reg_data2_from_mem (reg_data2_from_mem),
  .write_back_data (write_back_data),
  .conditions_from_memory_pop (conditions_from_memory_pop),
  .jump_selector (jump_selector),
  .memory_address_select (memory_address_select),
  .memory_write_src_select (memory_write_src_select),
  .wb_sel (wb_sel),
  .result_out (ALU_result),
  .shamt (shamt),
  .PC (PC),
  .alu_src1_select (alu_src1_select),
  .alu_src2_select (alu_src2_select),
  .conditionCodeRegister_out (conditionCodeRegister)
);

initial begin
  read_data1 = 15;
  read_data2 = 24;
  ALU_Op = 4'b0011; // Add
  carry_sel = 2'b00;

  #T;
  read_data1 = 15;
  read_data2 = 24;
  ALU_Op = 4'b0011; // Add
  carry_sel = 2'b00;

  #T;
  read_data1 = 15;
  read_data2 = 24;
  ALU_Op = 4'b0011; // Add
  carry_sel = 2'b00;

  #T;
  read_data1 = 15;
  read_data2 = 24;
  ALU_Op = 4'b0011; // Add
  carry_sel = 2'b00;

  #T;
  read_data1 = 15;
  read_data2 = 24;
  ALU_Op = 4'b0011; // Add
  carry_sel = 2'b00;

  #T;
  $finish;
end

always
  #(T/2) clk = !clk ;

endmodule