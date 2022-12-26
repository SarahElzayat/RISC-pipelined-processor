module memory_stage_tb;

  // Parameters
  parameter T = 10;
  // Ports
  reg clk = 0;
  reg  memory_read = 0;
  reg  memory_write = 0;
  reg  memory_push = 0;
  reg  memory_pop = 0;
  reg [15:0] address;
  reg [15:0]  write_data;
  wire [15:0] data;

  memory_stage 
  memory_stage_dut (
    .clk (clk ),
    . memory_read ( memory_read ),
    . memory_write ( memory_write ),
    . memory_push ( memory_push ),
    . memory_pop ( memory_pop ),
    .address (address ),
    . write_data ( write_data ),
    .data  ( data)
  );

  initial begin
    begin

    memory_read = 1;
    address = 2046;
    #T;
    memory_push = 1;
    write_data = 55;
    #T;
    memory_push = 0;
    memory_pop = 1;
    #T;
    memory_write = 1;
    write_data = 555;
    #T;
      $finish;
    end
  end

  always
    #5  clk = ! clk ;

endmodule
