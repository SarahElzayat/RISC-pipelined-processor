module fetch_stage_tb;

  // Parameters
  localparam T = 10;
  // Ports
  reg clk = 0;
  reg reset = 0;
  reg pc_enable = 0;
  reg pc_write = 0;
  reg [15:0] pc_write_back_value;
  reg clear_instruction = 0;
  wire [31:0] pc_plus_one_r;
  wire [15:0] instruction_r;

  fetch_stage
    fetch_stage_dut (
      .clk (clk ),
      .reset (reset ),
      .pc_enable (pc_enable ),
      .pc_write (pc_write ),
      .pc_write_back_value (pc_write_back_value ),
      .clear_instruction (clear_instruction ),
      .pc_plus_one_r (pc_plus_one_r ),
      .instruction_r  ( instruction_r)
    );

  initial
  begin
    begin
      reset = 1;
      #T;
      reset = 0;
      pc_enable = 1;
      #(T*5);
      pc_write = 1;
      // pc_write_back_value = 2**7;
      // #T;
      for (int i=0; i<16; i=i+1)
      begin
        pc_write_back_value = 2**7 + i;
        #T;
      end
      pc_write = 0;
      pc_write_back_value = 50;
      #(T*3);
      clear_instruction = 1;
      #T;
      pc_write = 1;
      #T;
    end
  end

  always
    #(T/2)  clk = ! clk ;

endmodule
