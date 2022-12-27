onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processor/decode_stage_dut/control_unit/counter
add wave -noupdate /processor/decode_stage_dut/control_unit/current_state
add wave -noupdate /processor/rst
add wave -noupdate /processor/out_port
add wave -noupdate /processor/clk
add wave -noupdate /processor/decode_stage_dut/ALUOp
add wave -noupdate /processor/decode_stage_dut/ALUOp_r
add wave -noupdate /processor/decode_stage_dut/reg_write
add wave -noupdate /processor/decode_stage_dut/reg_write_address_from_wb
add wave -noupdate /processor/decode_stage_dut/reg_write_address_r
add wave -noupdate /processor/decode_stage_dut/reg_file_read_data1
add wave -noupdate /processor/decode_stage_dut/reg_file_read_data2
add wave -noupdate /processor/decode_stage_dut/reg_file_dut/write_address
add wave -noupdate /processor/decode_stage_dut/reg_file_dut/read_address1
add wave -noupdate /processor/decode_stage_dut/reg_file_dut/read_address2
add wave -noupdate /processor/fetch_stage_dut/instruction_r
add wave -noupdate /processor/write_back_data
add wave -noupdate /processor/wb_sel_dec
add wave -noupdate /processor/wb_sel_ex
add wave -noupdate /processor/wb_sel_mem
add wave -noupdate /processor/alu_src_dec
add wave -noupdate /processor/alu_value_mem
add wave -noupdate /processor/reg_write_address_dec
add wave -noupdate /processor/reg_write_address_ex
add wave -noupdate /processor/reg_write_address_mem
add wave -noupdate /processor/write_back_stage_dut/data
add wave -noupdate /processor/decode_stage_dut/reg_write_data_from_wb
add wave -noupdate /processor/write_back_stage_dut/sel
add wave -noupdate /processor/execute_stage_dut/alu_src1_select
add wave -noupdate /processor/execute_stage_dut/alu_src2_select
add wave -noupdate /processor/execute_stage_dut/alu_dut/Op1
add wave -noupdate /processor/execute_stage_dut/alu_dut/Op2
add wave -noupdate /processor/execute_stage_dut/alu_dut/alu_src1_select
add wave -noupdate /processor/execute_stage_dut/alu_dut/alu_src_select
add wave -noupdate /processor/decode_stage_dut/reg_file_dut/reg_file
add wave -noupdate /processor/execute_stage_dut/flag_register
add wave -noupdate /processor/memory_stage_dut/memory_push
add wave -noupdate /processor/memory_stage_dut/memory_write
add wave -noupdate /processor/memory_stage_dut/std_address
add wave -noupdate -radix binary /processor/memory_stage_dut/memory_stage_without_buffers_dut/sp
add wave -noupdate /processor/memory_stage_dut/memory_stage_without_buffers_dut/memory_address_select
add wave -noupdate -radix binary /processor/memory_stage_dut/memory_stage_without_buffers_dut/final_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3980 ns} 0} {{Cursor 2} {2020 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 453
configure wave -valuecolwidth 378
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3955 ns} {4029 ns}
