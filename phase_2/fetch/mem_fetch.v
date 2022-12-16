module mem_fetch (
    input clk,
    input reset, //the reset signal resets the pc to 2^5 (first address of the instructions memory)
    output [15:0] instruction
);

    reg [31:0] PC; // = 2**5; //program counter(initally 2^5) 

    //  word width                memory entries 
    reg [15:0] instruction_memory [0: (2 ** 20) -1 ]; //instruction memeory of 2MB size, the first 2^5 entries are reserved for interrupts,
    // the rest is reserved of the instructions.

    reg [2:0]clk_counter; //counts 5 cycles of the clock to fetch the next instruction
	
    // assign instruction = instruction_memory[PC];
    assign instruction = clk_counter == 0? instruction_memory[PC]: 'hA000;

    always @(posedge clk) begin

        if (reset == 1) begin
            PC = 2**5;
            clk_counter = 0;
        end

        else begin

            if(clk_counter == 4) //in case it's been 5 clock cycles, increment the PC to fetch the next instruction
                begin
                    PC = PC + 1; //TODO change into pc-incrementing module in the next phase to deal with branching
                    clk_counter = 0;
                end
            else
                clk_counter = clk_counter + 1;

        end

    end





endmodule







