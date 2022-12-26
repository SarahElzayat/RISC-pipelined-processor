module memory_stage_without_buffers (
    input clk, reset,memory_read, memory_write, memory_push, memory_pop,
    input [15:0] address, write_data, pc_lower, pc_upper,
    input [2:0] flags,
    output  [15:0] data,

    // inputs to ust pass
    input RegWrite,
    output RegWrite_r,
    input[2:0] reg_write_address_from_ex,
    output[2:0] reg_write_address_r_to_wb,
    input [15:0] sign_extend_from_ex,
    output [15:0] sign_extend_to_wb,
    input [15:0] alu_result_from_ex,
    output [15:0] alu_result_to_wb,
    input write_back_select_from_ex,
    output write_back_select_to_wb

  );

  // wire  [15:0] data;




  reg [31:0] SP = (2**10) - 1; //stack pointer pointing at the last entry // @suppress "Register initialization in declaration. Consider using an explicit reset instead"
  reg [15:0] data_memory [0: (2 ** 10) -1]; //data memory of 4KB

  assign data = (memory_read == 1) ? data_memory[address]:
         (memory_pop == 1) ? data_memory[SP[10:0]]:  16'bz;



  always @(posedge clk)
  begin

    if(memory_write)
    begin
      data_memory[address[10:0]] = write_data;
    end

    if (memory_push)
    begin
      SP = SP - 1;
      data_memory[SP] = write_data;
    end

    if (memory_pop)
    begin
      SP = SP + 1;
    end
  end

endmodule
