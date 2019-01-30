add wave -r /*
force -freeze sim:/addr_gen_bp_dwu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/addr_gen_bp_dwu/rst 1'h1 0
force -freeze sim:/addr_gen_bp_dwu/en 1'h0 0
run 100
force -freeze sim:/addr_gen_bp_dwu/rst 1'h0 0
force -freeze sim:/addr_gen_bp_dwu/en 1'h1 0
run 10000