module memory_stage_without_buffers_tb;

  // Parameters
    localparam T = 10 ;
  // Ports
  reg clk = 0;
  reg reset = 0;
  reg memory_read = 0;
  reg memory_write = 0;
  reg memory_push = 0;
  reg memory_pop = 0;
  reg [15:0] std_address = 0;
  reg [15:0]ldd_address = 0;
  reg [1:0] memory_address_select =0;
  reg [1:0]memory_write_src_select = 0;
  reg [31:0] pc =0;
  reg [2:0] flags =0;
  wire [15:0] data;// = 0;
wire [31:0] shift_reg;
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

  initial begin
    begin
        reset = 1;
        #T;
        reset = 0;
        #T;
        pc = 'hDCBAABCD;
        std_address = 20;
        flags = 3'b111;
        memory_write = 1;
        memory_push = 1;
        memory_write_src_select = 2'b00;
        memory_address_select = 2'b00; //pc
        #T;
        // #T;
        
        memory_write_src_select = 2'b01;
        #T;
        memory_write_src_select = 2'b10;
        #T;
        memory_write_src_select = 2'b11;
        #T;
        memory_push = 0;
        memory_write = 0;
        memory_pop = 1;
        memory_read = 1;
        #(T*5);



    end
  end

  always
    #(T/2)  clk = ! clk ;

endmodule
