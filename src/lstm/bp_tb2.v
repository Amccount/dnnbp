module bp_tb2();

// parameters
parameter ADDR_WIDTH = 12;
parameter WIDTH = 24;
parameter FRAC = 16;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 53;
parameter LAYR1_CELL = 53;
parameter LAYR2_CELL = 8;

reg clk, rst;

wire en_delta_2;
wire update, bp;
wire acc_x1, acc_h1;
wire acc_x2, acc_h2;
wire wr_dout_2, wr_dstate_2;
wire [1:0] sel_in1_2, sel_in1_1;
wire [1:0] sel_in2_2, sel_in2_1;
wire sel_in3_2, sel_in3_1;
wire [1:0] sel_in4_2, sel_in4_1;
wire [2:0] sel_in5_2, sel_in5_1;
wire [1:0] sel_x1_1_2, sel_x1_1_1;
wire sel_x1_2_2, sel_x1_2_1;
wire [1:0] sel_x2_2_2, sel_x2_2_1;
wire sel_as_1_2, sel_as_1_1;
wire [1:0] sel_as_2_2, sel_as_2_1;
wire sel_addsub_2, sel_addsub_1;
wire [1:0] sel_temp_2, sel_temp_1;
wire wr_da2, wr_di2, wr_df2, wr_do2;
wire wr_dx2, wr_dout_1, wr_dstate_1;
wire wr_da1, wr_di1, wr_df1, wr_do1;
wire rst_cost, acc_cost;

wire signed [WIDTH-1:0] o_cost;

wire [ADDR_WIDTH-1:0] rd_addr_b_c1;
wire [ADDR_WIDTH-1:0] wr_addr_a_wa_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_wi_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_wf_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_wo_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_ua_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_ui_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_uf_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_uo_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_ba_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_bi_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_bf_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_bo_1;

wire [ADDR_WIDTH-1:0] rd_addr_b_a1;
wire [ADDR_WIDTH-1:0] rd_addr_b_f1;
wire [ADDR_WIDTH-1:0] rd_addr_b_i1;
wire [ADDR_WIDTH-1:0] rd_addr_b_o1;

wire [ADDR_WIDTH-1:0] wr_addr_a_wa_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_wi_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_wf_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_wo_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_ua_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_ui_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_uf_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_uo_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_ba_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_bi_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_bf_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_bo_2;

wire [ADDR_WIDTH-1:0] o_addr_dout_2;
wire [ADDR_WIDTH-1:0] wr_addr_a_dstate_2;
wire [ADDR_WIDTH-1:0] rd_addr_b_dstate_2;

wire [ADDR_WIDTH-1:0] wr_addr_a_dx2;
wire [ADDR_WIDTH-1:0] rd_addr_b_dx2;

wire [ADDR_WIDTH-1:0] wr_addr_a_dout_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_dstate_1;
wire [ADDR_WIDTH-1:0] rd_addr_b_dout_1;
wire [ADDR_WIDTH-1:0] rd_addr_b_dstate_1;

wire [ADDR_WIDTH-1:0] wr_addr_a_da1;
wire [ADDR_WIDTH-1:0] wr_addr_a_di1;
wire [ADDR_WIDTH-1:0] wr_addr_a_df1;
wire [ADDR_WIDTH-1:0] wr_addr_a_do1;

wire [ADDR_WIDTH-1:0] o_addr_aioht_2, o_addr_aioht_1;
wire [ADDR_WIDTH-1:0] o_addr_fc_2, o_addr_fc_1;

wire [ADDR_WIDTH-1:0] o_addr_dgates_2, o_addr_dgates_1;

wire [ADDR_WIDTH-1:0] o_addr_dx2;
wire [ADDR_WIDTH-1:0] o_addr_dx2_dgate;
wire [ADDR_WIDTH-1:0] o_addr_dout2_dgate;
wire [ADDR_WIDTH-1:0] o_addr_dout1_dgate;
wire [ADDR_WIDTH-1:0] o_addr_dx2_w;
wire [ADDR_WIDTH-1:0] o_addr_dout2_u;
wire [ADDR_WIDTH-1:0] o_addr_dout1_u;

wire [ADDR_WIDTH-1:0] o_addr_dout_1;

wire en_dx2, en_dout2, en_dout1;
wire en_rw_dout2;

datapath #(
		.WIDTH(WIDTH),
		.FRAC(FRAC),
		.TIMESTEP(TIMESTEP)
	) datapath (
		.clk                (clk),
		.rst                (rst),
		.wr_h1              (),
		.wr_c1              (),
		.wr_wa_1            (),
		.wr_wi_1            (),
		.wr_wf_1            (),
		.wr_wo_1            (),
		.wr_ua_1            (),
		.wr_ui_1            (),
		.wr_uf_1            (),
		.wr_uo_1            (),
		.wr_ba_1            (),
		.wr_bi_1            (),
		.wr_bf_1            (),
		.wr_bo_1            (),
		.wr_addr_a_h1       (),
		.wr_addr_a_c1       (),
		.upd_addr_a_wa_1    (),
		.upd_addr_a_wi_1    (),
		.upd_addr_a_wf_1    (),
		.upd_addr_a_wo_1    (),
		.bp_addr_a_wa_1     (),
		.bp_addr_a_wi_1     (),
		.bp_addr_a_wf_1     (),
		.bp_addr_a_wo_1     (),
		.upd_addr_a_ua_1    (),
		.upd_addr_a_ui_1    (),
		.upd_addr_a_uf_1    (),
		.upd_addr_a_uo_1    (),
		.bp_addr_a_ua_1     (o_addr_dout1_u),
		.bp_addr_a_ui_1     (o_addr_dout1_u),
		.bp_addr_a_uf_1     (o_addr_dout1_u),
		.bp_addr_a_uo_1     (o_addr_dout1_u),
		.wr_addr_a_ba_1     (),
		.wr_addr_a_bi_1     (),
		.wr_addr_a_bf_1     (),
		.wr_addr_a_bo_1     (),
		.rd_addr_b_x1       (),
		.rd_addr_b_h1       (),
		.rd_addr_b_c1       (o_addr_fc_1),
		.rd_addr_b_wa_1     (),
		.rd_addr_b_wi_1     (),
		.rd_addr_b_wf_1     (),
		.rd_addr_b_wo_1     (),
		.rd_addr_b_ua_1     (),
		.rd_addr_b_ui_1     (),
		.rd_addr_b_uf_1     (),
		.rd_addr_b_uo_1     (),
		.rd_addr_b_ba_1     (),
		.rd_addr_b_bi_1     (),
		.rd_addr_b_bf_1     (),
		.rd_addr_b_bo_1     (),
		.update             (update),
		.bp                 (bp),
		.acc_x1             (acc_x1),
		.acc_h1             (acc_h1),
		.wr_act_1           (),
		.wr_addr_a_act_1    (),
		.rd_addr_b_a1       (o_addr_aioht_1),
		.rd_addr_b_f1       (o_addr_fc_1),
		.rd_addr_b_i1       (o_addr_aioht_1),
		.rd_addr_b_o1       (o_addr_aioht_1),
		.rst_mac_1          (rst_mac_1),
		.wr_h2              (),
		.wr_c2              (),
		.wr_wa_2            (),
		.wr_wi_2            (),
		.wr_wf_2            (),
		.wr_wo_2            (),
		.wr_ua_2            (),
		.wr_ui_2            (),
		.wr_uf_2            (),
		.wr_uo_2            (),
		.wr_ba_2            (),
		.wr_bi_2            (),
		.wr_bf_2            (),
		.wr_bo_2            (),
		.wr_addr_a_h2       (),
		.wr_addr_a_c2       (),
		.upd_addr_a_wa_2    (),
		.upd_addr_a_wi_2    (),
		.upd_addr_a_wf_2    (),
		.upd_addr_a_wo_2    (),
		.bp_addr_a_wa_2     (o_addr_dx2_w),
		.bp_addr_a_wi_2     (o_addr_dx2_w),
		.bp_addr_a_wf_2     (o_addr_dx2_w),
		.bp_addr_a_wo_2     (o_addr_dx2_w),
		.upd_addr_a_ua_2    (),
		.upd_addr_a_ui_2    (),
		.upd_addr_a_uf_2    (),
		.upd_addr_a_uo_2    (),
		.bp_addr_a_ua_2     (o_addr_dout2_u),
		.bp_addr_a_ui_2     (o_addr_dout2_u),
		.bp_addr_a_uf_2     (o_addr_dout2_u),
		.bp_addr_a_uo_2     (o_addr_dout2_u),
		.wr_addr_a_ba_2     (),
		.wr_addr_a_bi_2     (),
		.wr_addr_a_bf_2     (),
		.wr_addr_a_bo_2     (),
		.rd_addr_b_h2       (o_addr_aioht_2),
		.rd_addr_b_c2       (o_addr_fc_2),
		.rd_addr_b_wa_2     (),
		.rd_addr_b_wi_2     (),
		.rd_addr_b_wf_2     (),
		.rd_addr_b_wo_2     (),
		.rd_addr_b_ua_2     (),
		.rd_addr_b_ui_2     (),
		.rd_addr_b_uf_2     (),
		.rd_addr_b_uo_2     (),
		.rd_addr_b_ba_2     (),
		.rd_addr_b_bi_2     (),
		.rd_addr_b_bf_2     (),
		.rd_addr_b_bo_2     (),
		.acc_x2             (acc_x2),
		.acc_h2             (acc_h2),
		.wr_act_2           (),
		.wr_addr_a_act_2    (),
		.rd_addr_b_a2       (o_addr_aioht_2),
		.rd_addr_b_f2       (o_addr_fc_2),
		.rd_addr_b_i2       (o_addr_aioht_2),
		.rd_addr_b_o2       (o_addr_aioht_2),
		.rst_mac_2          (rst_mac_2),
		.wr_t2              (),
		.rd_dgate           (rd_dgate),
		.wr_addr_a_t2       (),
		.rd_addr_b_t2       (o_addr_aioht_2),
		.wr_dout_2          (wr_dout_2),
		.wr_dstate_2        (wr_dstate_2),
		.wr_addr_a_dout_2   (o_addr_dout_2),
		.wr_addr_a_dstate_2 (wr_addr_a_dstate_2),
		.rd_addr_b_dout_2   (o_addr_dout_2),
		.rd_addr_b_dstate_2 (rd_addr_b_dstate_2),
		.sel_in1_2          (sel_in1_2),
		.sel_in2_2          (sel_in2_2),
		.sel_in3_2          (sel_in3_2),
		.sel_in4_2          (sel_in4_2),
		.sel_in5_2          (sel_in5_2),
		.sel_x1_1_2         (sel_x1_1_2),
		.sel_x1_2_2         (sel_x1_2_2),
		.sel_x2_2_2         (sel_x2_2_2),
		.sel_as_1_2         (sel_as_1_2),
		.sel_as_2_2         (sel_as_2_2),
		.sel_addsub_2       (sel_addsub_2),
		.sel_temp_2         (sel_temp_2),
		.wr_da2             (wr_da2),
		.wr_di2             (wr_di2),
		.wr_df2             (wr_df2),
		.wr_do2             (wr_do2),
		.wr_addr_a_da2      (o_addr_dgates_2),
		.wr_addr_a_di2      (o_addr_dgates_2),
		.wr_addr_a_df2      (o_addr_dgates_2),
		.wr_addr_a_do2      (o_addr_dgates_2),
		.rd_addr_a_da2      (o_addr_dx2_dgate),
		.rd_addr_a_di2      (o_addr_dx2_dgate),
		.rd_addr_a_df2      (o_addr_dx2_dgate),
		.rd_addr_a_do2      (o_addr_dx2_dgate),
		.upd_addr_a_da2     (),
		.upd_addr_a_di2     (),
		.upd_addr_a_df2     (),
		.upd_addr_a_do2     (),
		.bp_addr_b_da2      (o_addr_dout2_dgate),
		.bp_addr_b_di2      (o_addr_dout2_dgate),
		.bp_addr_b_df2      (o_addr_dout2_dgate),
		.bp_addr_b_do2      (o_addr_dout2_dgate),
		.upd_addr_b_da2     (),
		.upd_addr_b_di2     (),
		.upd_addr_b_df2     (),
		.upd_addr_b_do2     (),
		.wr_dx2             (wr_dx2),
		.wr_addr_a_dx2      (o_addr_dx2),
		.rd_addr_b_dx2      (o_addr_dx2),
		.wr_dout_1          (wr_dout_1),
		.wr_dstate_1        (wr_dstate_1),
		.wr_addr_a_dout_1   (o_addr_dout_1),
		.wr_addr_a_dstate_1 (wr_addr_a_dstate_1),
		.rd_addr_b_dout_1   (o_addr_dout_1),
		.rd_addr_b_dstate_1 (rd_addr_b_dstate_1),
		.sel_in1_1          (sel_in1_1),
		.sel_in2_1          (sel_in2_1),
		.sel_in3_1          (sel_in3_1),
		.sel_in4_1          (sel_in4_1),
		.sel_in5_1          (sel_in5_1),
		.sel_x1_1_1         (sel_x1_1_1),
		.sel_x1_2_1         (sel_x1_2_1),
		.sel_x2_2_1         (sel_x2_2_1),
		.sel_as_1_1         (sel_as_1_1),
		.sel_as_2_1         (sel_as_2_1),
		.sel_addsub_1       (sel_addsub_1),
		.sel_temp_1         (sel_temp_1),
		.wr_da1             (wr_da1),
		.wr_di1             (wr_di1),
		.wr_df1             (wr_df1),
		.wr_do1             (wr_do1),
		.wr_addr_a_da1      (o_addr_dgates_1),
		.wr_addr_a_di1      (o_addr_dgates_1),
		.wr_addr_a_df1      (o_addr_dgates_1),
		.wr_addr_a_do1      (o_addr_dgates_1),
		.rd_addr_a_da1      (),
		.rd_addr_a_di1      (),
		.rd_addr_a_df1      (),
		.rd_addr_a_do1      (),
		.upd_addr_a_da1     (),
		.upd_addr_a_di1     (),
		.upd_addr_a_df1     (),
		.upd_addr_a_do1     (),
		.bp_addr_b_da1      (o_addr_dout1_dgate),
		.bp_addr_b_di1      (o_addr_dout1_dgate),
		.bp_addr_b_df1      (o_addr_dout1_dgate),
		.bp_addr_b_do1      (o_addr_dout1_dgate),
		.upd_addr_b_da1     (),
		.upd_addr_b_di1     (),
		.upd_addr_b_df1     (),
		.upd_addr_b_do1     (),
		.rst_cost           (rst_cost),
		.acc_cost           (acc_cost),
		.rst_acc_2          (),
		.rst_acc_1          (),
		.acc_dgate1			(),
		.acc_dgate2			(),
		.o_cost             (o_cost)
	);



fsm_bp #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_fsm_bp (
		.clk          (clk),
		.rst          (rst),
		.en_delta_2   (en_delta_2),
		.en_delta_1   (en_delta_1),
		.en_dx2       (en_dx2),
		.en_dout2     (en_dout2),
		.en_dout1     (en_dout1),
		.en_rw_dout2  (en_rw_dout2),
		.en_rw_dx2    (en_rw_dx2),
		.en_rw_dout1  (en_rw_dout1),
		.update       (update),
		.bp           (bp),
		.rd_dgate     (rd_dgate),
		.acc_x1       (acc_x1),
		.acc_h1       (acc_h1),
		.acc_x2       (acc_x2),
		.acc_h2       (acc_h2),
		.wr_dout_2    (wr_dout_2),
		.wr_dstate_2  (wr_dstate_2),
		.sel_in1_2    (sel_in1_2),
		.sel_in1_1    (sel_in1_1),
		.sel_in2_2    (sel_in2_2),
		.sel_in2_1    (sel_in2_1),
		.sel_in3_2    (sel_in3_2),
		.sel_in3_1    (sel_in3_1),
		.sel_in4_2    (sel_in4_2),
		.sel_in4_1    (sel_in4_1),
		.sel_in5_2    (sel_in5_2),
		.sel_in5_1    (sel_in5_1),
		.sel_x1_1_2   (sel_x1_1_2),
		.sel_x1_1_1   (sel_x1_1_1),
		.sel_x1_2_2   (sel_x1_2_2),
		.sel_x1_2_1   (sel_x1_2_1),
		.sel_x2_2_2   (sel_x2_2_2),
		.sel_x2_2_1   (sel_x2_2_1),
		.sel_as_1_2   (sel_as_1_2),
		.sel_as_1_1   (sel_as_1_1),
		.sel_as_2_2   (sel_as_2_2),
		.sel_as_2_1   (sel_as_2_1),
		.sel_addsub_2 (sel_addsub_2),
		.sel_addsub_1 (sel_addsub_1),
		.sel_temp_2   (sel_temp_2),
		.sel_temp_1   (sel_temp_1),
		.wr_da2       (wr_da2),
		.wr_di2       (wr_di2),
		.wr_df2       (wr_df2),
		.wr_do2       (wr_do2),
		.wr_dx2       (wr_dx2),
		.wr_dout_1    (wr_dout_1),
		.wr_dstate_1  (wr_dstate_1),
		.wr_da1       (wr_da1),
		.wr_di1       (wr_di1),
		.wr_df1       (wr_df1),
		.wr_do1       (wr_do1),
		.rst_cost     (rst_cost),
		.acc_cost     (acc_cost),
		.rst_mac_1    (rst_mac_1),
		.rst_mac_2    (rst_mac_2)
	);


// LAYER 2 DELTA /////////////////////////////

addr_gen_bp_aiohtd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.DELTA_TIME(12)
	) inst_addr_gen_bp_aiohtd2 (
		.clk           (clk),
		.rst           (rst),
		.en            (en_delta_2),
		.o_addr_aioht  (o_addr_aioht_2),
		.o_addr_dgates (o_addr_dgates_2)
	);

addr_gen_bp_aiohtd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELTA_TIME(12)
	) inst_addr_gen_bp_aiohtd1 (
		.clk           (clk),
		.rst           (rst),
		.en            (en_delta_1),
		.o_addr_aioht  (o_addr_aioht_1),
		.o_addr_dgates (o_addr_dgates_1)
	);

addr_gen_bp_fc #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.DELTA_TIME(12),
		.CHG_TIME(5)
	) inst_addr_gen_bp_fc2 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_delta_2),
		.o_addr (o_addr_fc_2)
	);

addr_gen_bp_fc #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELTA_TIME(12),
		.CHG_TIME(5)
	) inst_addr_gen_bp_fc1 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_delta_1),
		.o_addr (o_addr_fc_1)
	);

addr_gen_bp_dstate #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.DELAY(12),
		.DELTA_TIME(12)
	) inst_addr_gen_bp_dstate2 (
		.clk       (clk),
		.rst       (rst),
		.en        (en_delta_2),
		.o_addr_rd (rd_addr_b_dstate_2),
		.o_addr_wr (wr_addr_a_dstate_2)
	);

addr_gen_bp_dstate #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.DELAY(12),
		.DELTA_TIME(12)
	) inst_addr_gen_bp_dstate1 (
		.clk       (clk),
		.rst       (rst),
		.en        (en_delta_1),
		.o_addr_rd (rd_addr_b_dstate_1),
		.o_addr_wr (wr_addr_a_dstate_1)
	);

addr_gen_bp_dxdout #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.DELAY_RD(11),
		.DELAY_WR(9),
		.RD_FIRST(1)
	) inst_addr_gen_rw_dout2 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_rw_dout2),
		.o_addr (o_addr_dout_2)
	);

addr_gen_bp_dxdout #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.DELAY_RD(11),
		.DELAY_WR(9),
		.RD_FIRST(0)
	) inst_addr_gen_rw_dx2 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_rw_dx2),
		.o_addr (o_addr_dx2)
	);

addr_gen_bp_dxdout #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.DELAY_RD(11),
		.DELAY_WR(54),
		.RD_FIRST(1)
	) inst_addr_gen_rw_dout1 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_rw_dout1),
		.o_addr (o_addr_dout_1)
	);

addr_gen_bp_dwu #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.DELAY(2)
	) inst_addr_gen_calc_dx2 (
		.clk      (clk),
		.rst      (rst),
		.en       (en_dx2),
		.o_addr_d (o_addr_dx2_dgate),
		.o_addr_w (o_addr_dx2_w)
	);

addr_gen_bp_dwu #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR2_CELL),
		.DELAY(2)
	) inst_addr_gen_calc_dout2 (
		.clk      (clk),
		.rst      (rst),
		.en       (en_dout2),
		.o_addr_d (o_addr_dout2_dgate),
		.o_addr_w (o_addr_dout2_u)
	);

addr_gen_bp_dwu #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.DELAY(3)
	) inst_addr_gen_calc_dout1 (
		.clk      (clk),
		.rst      (rst),
		.en       (en_dout1),
		.o_addr_d (o_addr_dout1_dgate),
		.o_addr_w (o_addr_dout1_u)
	);

initial
begin
	clk <= 1;
	rst <= 1;
	#100;
	rst <= 0;
end

always
begin
	#50;
	clk = !clk;
end

endmodule