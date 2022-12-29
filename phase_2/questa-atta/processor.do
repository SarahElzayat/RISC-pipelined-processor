mem load -i D:/academic_material/third_year/ARCH2/RISC-pipelined-processor/assembler/output.mem /processor/fetch_stage_dut/mem_fetch_dut/instruction_memory
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/processor/rst 0
run 10
force -freeze sim:/processor/input_port 16'h0003 0 
run
run
run
run
force -freeze sim:/processor/input_port 16'h0007 0
run
run
run
run
run
