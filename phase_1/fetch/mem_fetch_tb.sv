module mem_fetch_tb;

  // Parameters
  localparam T = 10 ;
  // Ports
  reg clk = 0;
  reg reset = 0;
  reg pc_enable = 0;
  reg pc_write = 0;
  reg [15:0] pc_write_back_value;
  reg clear_instruction = 0;
  wire [31:0] pc_plus_one;
  wire [15:0] instruction;

  mem_fetch
    mem_fetch_dut (
      .clk (clk ),
      .reset (reset ),
      .pc_enable (pc_enable ),
      .pc_write (pc_write ),
      .pc_write_back_value (pc_write_back_value ),
      .clear_instruction (clear_instruction ),
      .pc_plus_one (pc_plus_one ),
      .instruction  ( instruction)
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
    #(T/2) clk = ! clk ;

endmodule
