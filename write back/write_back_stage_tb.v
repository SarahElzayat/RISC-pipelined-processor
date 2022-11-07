module write_back_stage_tb;

  // Parameters
parameter T = 10;

  // Ports
  reg sel = 0;
  reg [15:0] immediate_value;
  reg [15:0]  alu_value;
  wire [15:0] data;

  write_back_stage 
  write_back_stage_dut (
    .sel (sel ),
    .immediate_value (immediate_value ),
    . alu_value ( alu_value ),
    .data  ( data)
  );

  initial begin
    begin

        immediate_value = 150;
        alu_value = 120;
        sel =0;
        #T;
        sel = 1;
      $finish;
    end
  end


endmodule
