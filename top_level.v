module top_level(clk, /*rst, */rst_fsm, o_cost);

// parameters
parameter WIDTH = 24;
parameter FRAC = 16;
parameter ADDR_WIDTH = 12;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 53;
parameter LAYR1_CELL = 53;
parameter LAYR2_CELL = 8;

parameter LAYR1_X = "layer1_x.list";
parameter LAYR1_H = "layer1_h.list";
parameter LAYR1_C = "layer1_c.list";
parameter LAYR2_X = "layer2_x.list";
parameter LAYR2_H = "layer2_h.list";
parameter LAYR2_C = "layer2_c.list";
parameter LAYR1_dA = "layer1_dA.list";
parameter LAYR1_dI = "layer1_dI.list";
parameter LAYR1_dF = "layer1_dF.list";
parameter LAYR1_dO = "layer1_dO.list";
parameter LAYR1_dOut = "layer1_dOut.list";
parameter LAYR1_dState = "layer1_dState.list";

// This holds d gates
parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";
parameter LAYR2_dState = "layer2_dState.list";
parameter LAYR2_T = "layer2_t_bp.list";

// States

// common ports
input clk, /*rst,*/ rst_fsm;

// input ports

// control ports

// output ports
output signed [WIDTH-1:0] o_cost;

// registers

// wires
// forwards
wire signed [11:0] wr_addr_h1;
wire signed [11:0] wr_addr_c1;
wire signed [11:0] rd_addr_w_1;
wire signed [11:0] rd_addr_u_1;
wire signed [11:0] rd_addr_b_1;

wire signed [11:0] wr_addr_h2;
wire signed [11:0] wr_addr_c2;
wire signed [11:0] rd_addr_w_2;
wire signed [11:0] rd_addr_u_2;
wire signed [11:0] rd_addr_b_2;


wire signed [11:0] wr_addr_act_1;
wire signed [11:0] wr_addr_act_2;
wire signed [11:0] wr_addr_w_1;
wire signed [11:0] wr_addr_b_1;
wire signed [11:0] wr_addr_u_1;
wire signed [11:0] wr_addr_w_2;
wire signed [11:0] wr_addr_b_2;
wire signed [11:0] wr_addr_u_2;
wire signed [11:0] rd_addr_h2;
wire signed [11:0] rd_addr_c2;
wire signed [11:0] rd_addr_h1;
wire signed [11:0] rd_addr_c1;
wire signed [11:0] addr_wu_1;


// backpropagation
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
wire [ADDR_WIDTH-1:0] wr_addr_a_h_1;
wire [ADDR_WIDTH-1:0] wr_addr_a_h_2;


wire [ADDR_WIDTH-1:0] rd_addr_b_a1;
wire [ADDR_WIDTH-1:0] rd_addr_b_f1;
wire [ADDR_WIDTH-1:0] rd_addr_b_i1;
wire [ADDR_WIDTH-1:0] rd_addr_b_o1;

wire [ADDR_WIDTH-1:0] upd_addr_a_h_1;
wire [ADDR_WIDTH-1:0] upd_addr_a_h_2;
wire [ADDR_WIDTH-1:0] upd_addr_b_x1;

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

// updateweights
// Layer 1 addresses
wire [ADDR_WIDTH-1:0] wr_addr_a_d1;
wire [ADDR_WIDTH-1:0] rd_addr_b_d1;
wire [ADDR_WIDTH-1:0] wr_addr_a_w1;
wire [ADDR_WIDTH-1:0] wr_addr_a_u1;
wire [ADDR_WIDTH-1:0] wr_addr_a_b1;
wire [ADDR_WIDTH-1:0] rd_addr_b_x1;
wire [ADDR_WIDTH-1:0] rd_addr_b_h1;
wire [ADDR_WIDTH-1:0] wr_addr_a_h1;


// Layer 2 addresses
wire [ADDR_WIDTH-1:0] wr_addr_a_d2;
wire [ADDR_WIDTH-1:0] rd_addr_b_d2;
wire [ADDR_WIDTH-1:0] wr_addr_a_w2;
wire [ADDR_WIDTH-1:0] wr_addr_a_u2;
wire [ADDR_WIDTH-1:0] wr_addr_a_b2;
wire [ADDR_WIDTH-1:0] rd_addr_b_x2;
wire [ADDR_WIDTH-1:0] rd_addr_b_h2;
wire [ADDR_WIDTH-1:0] wr_addr_a_h2;

//
wire en_x1, en_x2, en_h1, en_h2;
wire en_w1, en_w2, en_u1, en_u2;
wire en_b1, en_b2;

// wire rst;
wire wr_h1;
wire wr_c1;
wire wr_wa_1;

wire wr_ua_1;

wire wr_ba_1;
wire rd_addr_a_x1;
wire wr_act_1;
wire rst_mac_1;
wire wr_h2;
wire wr_c2;
wire wr_wa_2;
wire wr_ua_2;
wire wr_ba_2;
wire wr_act_2;
wire rst_mac_2;
wire rd_dgate;
wire acc_dgate2;
wire acc_dgate1;
wire rst_acc_1;
wire rst_acc_2;

wire en_1;
wire en_2;
wire en_delta_1;
wire en_rw_dout1;
wire en_rw_dx2;

wire rst_bp;
wire rst_upd;

datapath #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.WIDTH(WIDTH),
		.FRAC(FRAC),
		.TIMESTEP(TIMESTEP),
		.LAYR1_INPUT(LAYR1_INPUT),
		.LAYR1_CELL(LAYR1_CELL),
		.LAYR2_CELL(LAYR2_CELL),
		.LAYR1_X(LAYR1_X),
		.LAYR1_H(LAYR1_H),
		.LAYR1_C(LAYR1_C),
		.LAYR2_H(LAYR2_H),
		.LAYR2_C(LAYR2_C),
		.LAYR2_T(LAYR2_T),
		.LAYR1_dOut(LAYR1_dOut),
		.LAYR1_dState(LAYR1_dState),
		.LAYR2_dOut(LAYR2_dOut),
		.LAYR2_dState(LAYR2_dState)
	) inst_datapath (
		.clk                (clk),
		.rst                (rst_bp),
		.wr_h1              (wr_h1),
		.wr_c1              (wr_c1),
		.wr_wa_1            (wr_w1),
		.wr_wi_1            (wr_w1),
		.wr_wf_1            (wr_w1),
		.wr_wo_1            (wr_w1),
		.wr_ua_1            (wr_u1),
		.wr_ui_1            (wr_u1),
		.wr_uf_1            (wr_u1),
		.wr_uo_1            (wr_u1),
		.wr_ba_1            (wr_b1),
		.wr_bi_1            (wr_b1),
		.wr_bf_1            (wr_b1),
		.wr_bo_1            (wr_b1),
		.wr_addr_a_h1       (wr_addr_a_h1),
		.upd_addr_a_h_1		(upd_addr_a_h_1),
		.wr_addr_a_c1       (wr_addr_c1),
		.upd_addr_a_wa_1    (wr_addr_a_w1),
		.upd_addr_a_wi_1    (wr_addr_a_w1),
		.upd_addr_a_wf_1    (wr_addr_a_w1),
		.upd_addr_a_wo_1    (wr_addr_a_w1),
		.bp_addr_a_wa_1     (),
		.bp_addr_a_wi_1     (),
		.bp_addr_a_wf_1     (),
		.bp_addr_a_wo_1     (),
		.upd_addr_a_ua_1    (wr_addr_a_u1),
		.upd_addr_a_ui_1    (wr_addr_a_u1),
		.upd_addr_a_uf_1    (wr_addr_a_u1),
		.upd_addr_a_uo_1    (wr_addr_a_u1),
		.bp_addr_a_ua_1     (o_addr_dout1_u),
		.bp_addr_a_ui_1     (o_addr_dout1_u),
		.bp_addr_a_uf_1     (o_addr_dout1_u),
		.bp_addr_a_uo_1     (o_addr_dout1_u),
		.wr_addr_a_ba_1     (wr_addr_a_b1),
		.wr_addr_a_bi_1     (wr_addr_a_b1),
		.wr_addr_a_bf_1     (wr_addr_a_b1),
		.wr_addr_a_bo_1     (wr_addr_a_b1),
		.rd_addr_a_x1       (),
		.upd_addr_b_x1		(upd_addr_b_x1),
		.rd_addr_b_x1       (rd_addr_b_x1),
		.rd_addr_b_h1       (rd_addr_b_h1),
		.rd_addr_b_c1       (o_addr_fc_1),
		.rd_addr_b_wa_1     (addr_wu_1),
		.rd_addr_b_wi_1     (addr_wu_1),
		.rd_addr_b_wf_1     (addr_wu_1),
		.rd_addr_b_wo_1     (addr_wu_1),
		.rd_addr_b_ua_1     (addr_wu_1),
		.rd_addr_b_ui_1     (addr_wu_1),
		.rd_addr_b_uf_1     (addr_wu_1),
		.rd_addr_b_uo_1     (addr_wu_1),
		.rd_addr_b_ba_1     (rd_addr_b_1),
		.rd_addr_b_bi_1     (rd_addr_b_1),
		.rd_addr_b_bf_1     (rd_addr_b_1),
		.rd_addr_b_bo_1     (rd_addr_b_1),
		.update             (update),
		.bp                 (bp),
		.acc_x1             (acc_x1),
		.acc_h1             (acc_h1),
		.wr_act_1           (wr_act_1),
		.wr_addr_a_act_1    (wr_addr_act_1),
		.rd_addr_b_a1       (o_addr_aioht_1),
		.rd_addr_b_f1       (o_addr_fc_1),
		.rd_addr_b_i1       (o_addr_aioht_1),
		.rd_addr_b_o1       (o_addr_aioht_1),
		.rst_mac_1          (rst_mac_1),
		.wr_h2              (wr_h2),
		.wr_c2              (wr_c2),
		.wr_wa_2            (wr_w2),
		.wr_wi_2            (wr_w2),
		.wr_wf_2            (wr_w2),
		.wr_wo_2            (wr_w2),
		.wr_ua_2            (wr_u2),
		.wr_ui_2            (wr_u2),
		.wr_uf_2            (wr_u2),
		.wr_uo_2            (wr_u2),
		.wr_ba_2            (wr_b2),
		.wr_bi_2            (wr_b2),
		.wr_bf_2            (wr_b2),
		.wr_bo_2            (wr_b2),
		.wr_addr_a_h2       (wr_addr_a_h2),
		.wr_addr_a_c2       (wr_addr_c2),
		.upd_addr_a_wa_2    (wr_addr_a_w2),
		.upd_addr_a_wi_2    (wr_addr_a_w2),
		.upd_addr_a_wf_2    (wr_addr_a_w2),
		.upd_addr_a_wo_2    (wr_addr_a_w2),
		.upd_addr_a_h_2		(upd_addr_a_h_2),
		.bp_addr_a_wa_2     (o_addr_dx2_w),
		.bp_addr_a_wi_2     (o_addr_dx2_w),
		.bp_addr_a_wf_2     (o_addr_dx2_w),
		.bp_addr_a_wo_2     (o_addr_dx2_w),
		.upd_addr_a_ua_2    (wr_addr_a_u2),
		.upd_addr_a_ui_2    (wr_addr_a_u2),
		.upd_addr_a_uf_2    (wr_addr_a_u2),
		.upd_addr_a_uo_2    (wr_addr_a_u2),
		.bp_addr_a_ua_2     (o_addr_dout2_u),
		.bp_addr_a_ui_2     (o_addr_dout2_u),
		.bp_addr_a_uf_2     (o_addr_dout2_u),
		.bp_addr_a_uo_2     (o_addr_dout2_u),
		.wr_addr_a_ba_2     (wr_addr_a_b2),
		.wr_addr_a_bi_2     (wr_addr_a_b2),
		.wr_addr_a_bf_2     (wr_addr_a_b2),
		.wr_addr_a_bo_2     (wr_addr_a_b2),
		.rd_addr_b_h2       (o_addr_aioht_2),
		.rd_addr_b_c2       (o_addr_fc_2),
		.rd_addr_b_wa_2     (wr_addr_a_w2),
		.rd_addr_b_wi_2     (wr_addr_a_w2),
		.rd_addr_b_wf_2     (wr_addr_a_w2),
		.rd_addr_b_wo_2     (wr_addr_a_w2),
		.rd_addr_b_ua_2     (wr_addr_a_u2),
		.rd_addr_b_ui_2     (wr_addr_a_u2),
		.rd_addr_b_uf_2     (wr_addr_a_u2),
		.rd_addr_b_uo_2     (wr_addr_a_u2),
		.rd_addr_b_ba_2     (rd_addr_b_2),
		.rd_addr_b_bi_2     (rd_addr_b_2),
		.rd_addr_b_bf_2     (rd_addr_b_2),
		.rd_addr_b_bo_2     (rd_addr_b_2),
		.acc_x2             (acc_x2),
		.acc_h2             (acc_h2),
		.wr_act_2           (wr_act_2),
		.wr_addr_a_act_2    (wr_addr_act_2),
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
		.upd_addr_a_da2     (wr_addr_a_d2),
		.upd_addr_a_di2     (wr_addr_a_d2),
		.upd_addr_a_df2     (wr_addr_a_d2),
		.upd_addr_a_do2     (wr_addr_a_d2),
		.bp_addr_b_da2      (o_addr_dout2_dgate),
		.bp_addr_b_di2      (o_addr_dout2_dgate),
		.bp_addr_b_df2      (o_addr_dout2_dgate),
		.bp_addr_b_do2      (o_addr_dout2_dgate),
		.upd_addr_b_da2     (rd_addr_b_d2),
		.upd_addr_b_di2     (rd_addr_b_d2),
		.upd_addr_b_df2     (rd_addr_b_d2),
		.upd_addr_b_do2     (rd_addr_b_d2),
		.acc_dgate2			(acc_dgate2),
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
		.upd_addr_a_da1     (wr_addr_a_d1),
		.upd_addr_a_di1     (wr_addr_a_d1),
		.upd_addr_a_df1     (wr_addr_a_d1),
		.upd_addr_a_do1     (wr_addr_a_d1),
		.bp_addr_b_da1      (o_addr_dout1_dgate),
		.bp_addr_b_di1      (o_addr_dout1_dgate),
		.bp_addr_b_df1      (o_addr_dout1_dgate),
		.bp_addr_b_do1      (o_addr_dout1_dgate),
		.upd_addr_b_da1     (rd_addr_b_d1),
		.upd_addr_b_di1     (rd_addr_b_d1),
		.upd_addr_b_df1     (rd_addr_b_d1),
		.upd_addr_b_do1     (rd_addr_b_d1),
		.acc_dgate1			(acc_dgate1),
		.rst_cost           (rst_cost),
		.acc_cost           (acc_cost),
		.rst_acc_1          (rst_acc_1),
		.rst_acc_2          (rst_acc_2),
		.o_cost             (o_cost)
	);


	fsm #(
			.WIDTH(WIDTH),
			.FRAC(FRAC),
			.LAYR2_CELL(LAYR2_CELL),
			.LAYR1_CELL(LAYR1_CELL),
			.ADDR_WIDTH(ADDR_WIDTH),
			.TIMESTEP(TIMESTEP),
			.LAYR1_INPUT(LAYR1_INPUT),
			.LAYR1_X(LAYR1_X),
			.LAYR1_H(LAYR1_H),
			.LAYR1_C(LAYR1_C),
			.LAYR2_X(LAYR2_X),
			.LAYR2_H(LAYR2_H),
			.LAYR2_C(LAYR2_C),
			.LAYR1_dA(LAYR1_dA),
			.LAYR1_dI(LAYR1_dI),
			.LAYR1_dF(LAYR1_dF),
			.LAYR1_dO(LAYR1_dO),
			.LAYR1_dOut(LAYR1_dOut),
			.LAYR1_dState(LAYR1_dState),
			.LAYR2_dA(LAYR2_dA),
			.LAYR2_dI(LAYR2_dI),
			.LAYR2_dF(LAYR2_dF),
			.LAYR2_dO(LAYR2_dO),
			.LAYR2_dX(LAYR2_dX),
			.LAYR2_dOut(LAYR2_dOut),
			.LAYR2_dState(LAYR2_dState),
			.LAYR2_T(LAYR2_T)
		) inst_fsm (
			.clk          (clk),
			.rst 		  (rst_fsm),
			.en_1         (en_1),
			.en_2         (en_2),
			.acc_x1       (acc_x1),
			.acc_h1       (acc_h1),
			.acc_x2       (acc_x2),
			.acc_h2       (acc_h2),
			.wr_h1        (wr_h1),
			.wr_h2        (wr_h2),
			.wr_c1        (wr_c1),
			.wr_c2        (wr_c2),
			.wr_act_1     (wr_act_1),
			.wr_act_2     (wr_act_2),
			.en_delta_2   (en_delta_2),
			.en_delta_1   (en_delta_1),
			.en_dx2       (en_dx2),
			.en_dout2     (en_dout2),
			.en_dout1     (en_dout1),
			.en_rw_dout2  (en_rw_dout2),
			.en_rw_dout1  (en_rw_dout1),
			.en_rw_dx2    (en_rw_dx2),
			.update       (update),
			.bp           (bp),
			.rd_dgate     (rd_dgate),
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
			.rst_mac_2    (rst_mac_2),
			.rst_2        (rst_2),
			.wr_w1        (wr_w1),
			.wr_u1        (wr_u1),
			.wr_b1        (wr_b1),
			.wr_w2        (wr_w2),
			.wr_u2        (wr_u2),
			.wr_b2        (wr_b2),
			.en_x1        (en_x1),
			.en_x2        (en_x2),
			.en_h1        (en_h1),
			.en_h2        (en_h2),
			.en_w1        (en_w1),
			.en_w2        (en_w2),
			.en_u1        (en_u1),
			.en_u2        (en_u2),
			.en_b1        (en_b1),
			.en_b2        (en_b2),
			.acc_dgate1   (acc_dgate1),
			.acc_dgate2   (acc_dgate2),
			.rst_acc_1    (rst_acc_1),
			.rst_acc_2    (rst_acc_2),
			.rst_bp		  (rst_bp),
			.rst_upd	  (rst_upd)
		);


// FORWARD
	// ADDR GENERATOR LAYER 1
	addr_gen_fwd_x #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.NUM_CELL(53),
			.NUM_INPUT(53),
			.TIMESTEP(7),
			.DELAY(4)
		) inst_addr_gen_fwd_x (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_1),
			.o_addr (rd_addr_b_x1)
		);

	addr_gen_c #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.TIMESTEP(7),
			.NUM_CELL(53),
			.NUM_INPUT(53),
			.DELAY(3)
		) inst_addr_gen_c1h1 (
			.clk      (clk),
			.rst      (rst_fsm),
			.en       (en_1),
			.o_addr_h (wr_addr_a_h1),
			.o_addr_c (wr_addr_c1)
		);


	addr_gen_fwd_aifo #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.NUM_CELL(53),
			.NUM_INPUT(53),
			.TIMESTEP(7),
			.DELAY(4)
		) inst_addr_gen_fwd_aifo (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_1),
			.o_addr (wr_addr_act_1)
	);


	addr_gen_b #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.STOP(53),
			.PRESCALER(53),
			.PAUSE_LEN(4)
		) inst_addr_gen_b_1 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_1),
			.o_addr (rd_addr_b_1)
	);


	addr_gen_wu #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.STOP(2809),
			.PAUSE_STR(53),
			.PAUSE_LEN(4)
		) inst_addr_gen_wu_1 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_1),
			.o_addr (addr_wu_1)
	);

	//ADDR GENERATOR LAYER 2

	addr_gen_c #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.TIMESTEP(7),
			.NUM_CELL(8),
			.NUM_INPUT(53),
			.DELAY(48)
		) inst_addr_gen_c2h2 (
			.clk      (clk),
			.rst      (rst_fsm),
			.en       (en_2),
			.o_addr_h (wr_addr_a_h2),
			.o_addr_c (wr_addr_c2)
		);
	
	addr_gen_fwd_aifo #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.NUM_CELL(8),
			.NUM_INPUT(53),
			.TIMESTEP(TIMESTEP),
			.DELAY(4)
		) inst_addr_gen_fwd_aifo_2 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_2),
			.o_addr (wr_addr_act_2)
	);


	addr_gen_b #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.STOP(7),
			.PRESCALER(53),
			.PAUSE_LEN(3)
		) inst_addr_gen_b_2 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_2),
			.o_addr (rd_addr_b_2)
	);


	addr_gen_wu #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.STOP(423),
			.PAUSE_STR(53),
			.PAUSE_LEN(4)
		) inst_addr_gen_w_2 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_2),
			.o_addr (rd_addr_w_2)
	);



	addr_gen_wu #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.STOP(63),
			.PAUSE_STR(8),
			.PAUSE_LEN(49)
		) inst_addr_gen_u_2 (
			.clk    (clk),
			.rst    (rst_fsm),
			.en     (en_2),
			.o_addr (rd_addr_u_2)
	);


// BACKPROPAGATION
// LAYER 2 DELTA /////////////////////////////
addr_gen_bp_aiohtd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.DELTA_TIME(12)
	) inst_addr_gen_bp_aiohtd2 (
		.clk           (clk),
		.rst           (rst_bp),
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
		.rst           (rst_bp),
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
		.rst    (rst_bp),
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
		.rst    (rst_bp),
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
		.rst       (rst_bp),
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
		.rst       (rst_bp),
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
		.rst    (rst_bp),
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
		.rst    (rst_bp),
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
		.rst    (rst_bp),
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
		.rst      (rst_bp),
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
		.rst      (rst_bp),
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
		.rst      (rst_bp),
		.en       (en_dout1),
		.o_addr_d (o_addr_dout1_dgate),
		.o_addr_w (o_addr_dout1_u)
	);

// UPDT WEIGHT
// Address generator dgates . X = dW
// Layer 1
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.DELAY(3)
	) inst_upd_xhd_x1 (
		.clk      (clk),
		.rst      (rst_upd),
		.en       (en_x1),
		.o_addr_d (wr_addr_a_d1),
		.o_addr_x (upd_addr_b_x1)
	);
// Layer 2
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.DELAY(3)
	) inst_upd_xhd_x2 (
		.clk      (clk),
		.rst      (rst_upd),
		.en       (en_x2),
		.o_addr_d (wr_addr_a_d2),
		.o_addr_x (rd_addr_b_h1)
	);

// Address generator dgates . H = dU
// Layer 1
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.DELAY(3)
	) inst_upd_xhd_h1 (
		.clk      (clk),
		.rst      (rst_upd),
		.en       (en_h1),
		.o_addr_d (rd_addr_b_d1),
		.o_addr_x (upd_addr_a_h_1)
	);
// Layer 2
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR2_CELL),
		.DELAY(3)
	) inst_upd_xhd_h2 (
		.clk      (clk),
		.rst      (rst_upd),
		.en       (en_h2),
		.o_addr_d (rd_addr_b_d2),
		.o_addr_x (upd_addr_a_h_2)
	);

// Address generator write update W
// Layer 1
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.TIMESTEP(TIMESTEP),
		.DELAY(10)
	) inst_upd_wub_w1 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_w1),
		.o_addr (wr_addr_a_w1)
	);

// Layer 2
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(10)
	) inst_upd_wub_w2 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_w2),
		.o_addr (wr_addr_a_w2)
	);

// Address generator write update U
// Layer 1
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.TIMESTEP(TIMESTEP),
		.DELAY(10)
	) inst_upd_wub_u1 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_u1),
		.o_addr (wr_addr_a_u1)
	);


// Layer 2

addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(10)
	) inst_upd_wub_u2 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_u2),
		.o_addr (wr_addr_a_u2)
	);

// Address generator write update B
// Layer 1
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.TIMESTEP(TIMESTEP),
		.DELAY(540)
	) inst_upd_wub_b1 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_b1),
		.o_addr (wr_addr_a_b1)
	);

// Layer 2
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(540)
	) inst_upd_wub_b2 (
		.clk    (clk),
		.rst    (rst_upd),
		.en     (en_b2),
		.o_addr (wr_addr_a_b2)
	);
endmodule