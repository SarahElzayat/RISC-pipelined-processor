force -freeze sim:/processor/rst 1 0 -cancel 20
force -freeze sim:/processor/clk 1 0, 0 {5 ps} -r 10
force -freeze sim:/processor/instruction 4'h8905 0
# 5 cycles 
# F D E M W
#   F D E M W
