module memory_stage_without_buffers (
  input clk, reset,memory_read, memory_write, memory_push, memory_pop, interrupt, pc_choose_memory,
  input [15:0] std_address, ldd_address, //read data1 & read data
  input [1:0] memory_address_select, memory_write_src_select,
  input[31:0] pc, pc_from_mux_ex,
  input [2:0] flags,
  output [15:0] data,
  output [31:0] final_pc,
  output [31:0] shift_reg
);


  // read - write - push - pop
  wire [10:0] final_address;
  wire [15:0] write_data;

  assign write_data =
  (memory_write_src_select === 2'b00) ? {13'b0,flags} :
  (memory_write_src_select === 2'b01) ? pc[31:16] : //pc upper
  (memory_write_src_select === 2'b10) ? pc[15:0] : // pc lower
  (memory_write_src_select === 2'b11) ? (memory_push === 1'b1) ? std_address : ldd_address : 'bz; //read data 1


  reg [31:0] temp_shift_reg;
  reg  [31:0] sp; //stack pointer pointing at the last entry // @suppress "Register initialization in declaration. Consider using an explicit reset instead"
  reg [15:0] data_memory [0: (2 ** 10) -1]; //data memory of 4KB

  assign data = (memory_read == 1) ? data_memory[final_address] : 'bz;
  assign shift_reg = temp_shift_reg;


  assign final_address = (memory_address_select === 2'b00)? std_address[10:0] :
  (memory_address_select === 2'b01)? ldd_address[10:0] :
  (memory_address_select === 2'b10)? sp : 'bz;

  wire[31:0] temp_pc;
  assign temp_pc = (pc_choose_memory === 1'b1) ? shift_reg: pc_from_mux_ex  ;
  assign final_pc = (interrupt === 1'b1) ? 32'b0 : temp_pc;

  always @(posedge clk)
  begin

    if(reset)
      begin
        sp = (2**10);
        temp_shift_reg = 0;
      end

    else
      begin

        if (memory_push === 1'b1 && sp > 0)
        begin
          sp = sp - 1;
        end

        if (memory_pop === 1'b1 && sp < 2**10 )
        begin
          sp = sp + 1;
        end

        if(memory_write)
        begin
          data_memory[final_address] = write_data;
        end

        if(memory_read)
        begin
          temp_shift_reg = temp_shift_reg>>16;
          temp_shift_reg = {data, temp_shift_reg[15:0]};
        end
      end

  end

endmodule
