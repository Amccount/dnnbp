force -freeze sim:/top_level/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/top_level/rst_fsm 1 0
run 100
force -freeze sim:/top_level/rst_fsm 0 0
run 200