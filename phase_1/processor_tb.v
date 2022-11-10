module processor_tb;

    // Parameters
    parameter integer CLK_PERIOD = 20;
    // Ports
    reg clk = 0;
    reg rst = 0;

    processor
    processor_dut (
        .clk (clk ),
        .rst  ( rst)
    );

    initial begin
        begin
            #CLK_PERIOD rst = 1;
            #CLK_PERIOD rst = 0;

            #(CLK_PERIOD* 25)

            $finish;
        end
    end

    always
    #5  clk = ! clk ;

endmodule
