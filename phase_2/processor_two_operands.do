log * -r
<<<<<<< Updated upstream:phase_2/processor_two_operands.do
mem load -i D:/arch_project/RISC-pipelined-processor/assembler/output.mem /processor/fetch_stage_dut/mem_fetch_dut/instruction_memory
mem load -i data_memory_initial.mem /processor/memory_stage_dut/memory_stage_without_buffers_dut/data_memory
=======
mem load -i D:/academic_material/third_year/ARCH2/RISC-pipelined-processor/assembler/output.mem /processor/fetch_stage_dut/mem_fetch_dut/instruction_memory
>>>>>>> Stashed changes:phase_2/processor.do
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/processor/rst 0
<<<<<<< Updated upstream:phase_2/processor_two_operands.do
run
run 
force -freeze sim:/processor/input_port 'h5
run
force -freeze sim:/processor/input_port 'h19
run
force -freeze sim:/processor/input_port 'hFFFF
run
force -freeze sim:/processor/input_port 'hF320
run

=======
force -freeze sim:/processor/input_port 16'h0001 0 
run 100
force -freeze sim:/processor/input_port 16'h0002 0 
run 100
force -freeze sim:/processor/input_port 16'h0003 0 
run 100
force -freeze sim:/processor/input_port 16'h0004 0
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
# force -freeze sim:/processor/input_port 16'h0007 0
# run
# run
# run
# run
# run
>>>>>>> Stashed changes:phase_2/processor.do
