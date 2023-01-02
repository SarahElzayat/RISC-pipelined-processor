log * -r
mem load -i D:/academic_material/third_year/ARCH2/RISC-pipelined-processor/assembler/output.mem /processor/fetch_stage_dut/mem_fetch_dut/instruction_memory
mem load -i D:/academic_material/third_year/ARCH2/RISC-pipelined-processor/Phase_2/data_memory_initial.mem /processor/memory_stage_dut/memory_stage_without_buffers_dut/data_memory
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/processor/rst 0
run 200
force -freeze sim:/processor/input_port 16'h0300 0 
run 100
# push R6
run 100
force -freeze sim:/processor/input_port 16'h040 0
run 100
force -freeze sim:/processor/input_port 16'h0300 0
run 100
force -freeze sim:/processor/input_port 16'h0100 0
run 100
force -freeze sim:/processor/input_port 16'h07fe 0
run 100
force -freeze sim:/processor/input_port 16'h0040 0
run 100
# force -freeze sim:/processor/interrupt_signal 1
run 100
force -freeze sim:/processor/interrupt_signal 0
run 800
force -freeze sim:/processor/interrupt_signal 1
run 100
force -freeze sim:/processor/interrupt_signal 0
run 3000

# run
# force interrupt_signal 1
# run 200
# force interrupt_signal 0
# run
# run
# run
# run
# run
# run
# run
# run
# run
# run
