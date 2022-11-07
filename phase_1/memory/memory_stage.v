module memory_stage (
    clk,
    memory_read,
    memory_write,
    address,
    write_data,
    memory_push,
    memory_pop,
    data
);
  
input clk, memory_read, memory_write, memory_push, memory_pop;
input [15:0] address, write_data;
output reg [15:0] data;

reg [31:0] SP = (2**11) - 1; //stack pointer pointing at the last entry
reg [15:0] data_memory [0: (2 ** 11) -1]; //data memory of 4KB 


assign data = (memory_read == 1) ? data_memory[address]:
               (memory_pop == 1) ? data_memory[SP[10:0]]:  16'bz;


always @(posedge clk) begin
    
    if(memory_write)
        begin
            data_memory[address[10:0]] = write_data;
        end

    if (memory_push) begin
        SP = SP - 1;
        data_memory[SP] = write_data;
    end

    if (memory_pop)
    begin
        SP = SP + 1;
    end
end

endmodule