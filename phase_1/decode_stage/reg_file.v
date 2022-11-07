module reg_file #(parameter WIDTH = 16 , parameter N_REGS = 8) (
    input clk,
    input rst,
    //write address
    input RegWrite,
    input [$clog2(N_REGS)  -1 :0] write_address,
    input [WIDTH - 1:0] write_data,
    //read
    // input RegRead,
    input [$clog2(N_REGS)  -1 :0] read_address1,
    input [$clog2(N_REGS)  -1 :0] read_address2,
    output  [WIDTH - 1:0] read_data1,
    output  [WIDTH - 1:0] read_data2
);
    // reg file as an array
    reg [WIDTH -1 :0] reg_file [0:N_REGS -1];


    integer i;

    always @(posedge clk, posedge rst)
    begin : writeBlock
        if(rst)
            begin
                for ( i =0 ; i < N_REGS ; i= i+1 )
                    reg_file[i] = 0;
            end
        else
            begin


                if (RegWrite)
                    reg_file[write_address] = write_data;

            end
    end


    // always @(negedge clk, posedge rst)
    // begin
    //     if(rst)
    //         begin
    //             read_data1 = 0;
    //             read_data2 = 0;
    //         end
    //     else
    //         if (RegRead)
    //         begin
    //             read_data1 = reg_file[read_address1];
    //             read_data2 = reg_file[read_address2];
    //         end
    // end

    assign read_data1 = reg_file[read_address1];
    assign read_data2 = reg_file[read_address2];

endmodule
