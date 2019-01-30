add wave -r /*
force -freeze sim:/addr_gen_upd_w/clk 1 0, 0 {25 ns} -r 50
force -freeze sim:/addr_gen_upd_w/rst 1'h1 0
force -freeze sim:/addr_gen_upd_w/en 1'h0 0
run 50
force -freeze sim:/addr_gen_upd_w/rst 1'h0 0
force -freeze sim:/addr_gen_upd_w/en 1'h1 0
run 5000