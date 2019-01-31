module datapath(
	clk, rst,
	wr_h1, wr_c1,
	wr_wa_1, wr_wi_1, wr_wf_1, wr_wo_1,
	wr_ua_1, wr_ui_1, wr_uf_1, wr_uo_1,
	wr_ba_1, wr_bi_1, wr_bf_1, wr_bo_1,

	wr_addr_a_h1, wr_addr_a_c1,
	upd_addr_a_wa_1, upd_addr_a_wi_1, upd_addr_a_wf_1, upd_addr_a_wo_1,
	bp_addr_a_wa_1, bp_addr_a_wi_1, bp_addr_a_wf_1, bp_addr_a_wo_1,
	upd_addr_a_ua_1, upd_addr_a_ui_1, upd_addr_a_uf_1, upd_addr_a_uo_1,
	bp_addr_a_ua_1, bp_addr_a_ui_1, bp_addr_a_uf_1, bp_addr_a_uo_1,
	wr_addr_a_ba_1, wr_addr_a_bi_1, wr_addr_a_bf_1, wr_addr_a_bo_1,

	rd_addr_b_x1, rd_addr_b_h1, rd_addr_b_c1,
	rd_addr_b_wa_1, rd_addr_b_wi_1, rd_addr_b_wf_1, rd_addr_b_wo_1,
	rd_addr_b_ua_1, rd_addr_b_ui_1, rd_addr_b_uf_1, rd_addr_b_uo_1,
	rd_addr_b_ba_1, rd_addr_b_bi_1, rd_addr_b_bf_1, rd_addr_b_bo_1,

	update, bp,
	acc_x1, acc_h1,

	wr_act_1, wr_addr_a_act_1,
	rd_addr_b_a1, rd_addr_b_f1, rd_addr_b_i1, rd_addr_b_o1,

	rst_mac_1,
	// --,
	wr_h2, wr_c2,
	wr_wa_2, wr_wi_2, wr_wf_2, wr_wo_2,
	wr_ua_2, wr_ui_2, wr_uf_2, wr_uo_2,
	wr_ba_2, wr_bi_2, wr_bf_2, wr_bo_2,

	wr_addr_a_h2, wr_addr_a_c2,
	upd_addr_a_wa_2, upd_addr_a_wi_2, upd_addr_a_wf_2, upd_addr_a_wo_2,
	bp_addr_a_wa_2, bp_addr_a_wi_2, bp_addr_a_wf_2, bp_addr_a_wo_2,
	upd_addr_a_ua_2, upd_addr_a_ui_2, upd_addr_a_uf_2, upd_addr_a_uo_2,
	bp_addr_a_ua_2, bp_addr_a_ui_2, bp_addr_a_uf_2, bp_addr_a_uo_2,
	wr_addr_a_ba_2, wr_addr_a_bi_2, wr_addr_a_bf_2, wr_addr_a_bo_2,

	rd_addr_b_h2, rd_addr_b_c2,
	rd_addr_b_wa_2, rd_addr_b_wi_2, rd_addr_b_wf_2, rd_addr_b_wo_2,
	rd_addr_b_ua_2, rd_addr_b_ui_2, rd_addr_b_uf_2, rd_addr_b_uo_2,
	rd_addr_b_ba_2, rd_addr_b_bi_2, rd_addr_b_bf_2, rd_addr_b_bo_2,

	acc_x2, acc_h2,

	wr_act_2, wr_addr_a_act_2,
	rd_addr_b_a2, rd_addr_b_f2, rd_addr_b_i2, rd_addr_b_o2,

	rst_mac_2,
	// -- bp
	wr_t2, rd_dgate,
	wr_addr_a_t2, rd_addr_b_t2,

	wr_dout_2, wr_dstate_2,
	wr_addr_a_dout_2, wr_addr_a_dstate_2,
	rd_addr_b_dout_2, rd_addr_b_dstate_2,

	sel_in1_2,
	sel_in2_2,
	sel_in3_2,
	sel_in4_2,
	sel_in5_2,
	sel_x1_1_2,
	sel_x1_2_2,
	sel_x2_2_2,
	sel_as_1_2,
	sel_as_2_2,
	sel_addsub_2,
	sel_temp_2,

	wr_da2, wr_di2, wr_df2, wr_do2,
	wr_addr_a_da2, wr_addr_a_di2, wr_addr_a_df2, wr_addr_a_do2,
	rd_addr_a_da2, rd_addr_a_di2, rd_addr_a_df2, rd_addr_a_do2,
	upd_addr_a_da2, upd_addr_a_di2, upd_addr_a_df2, upd_addr_a_do2, 
	bp_addr_b_da2, bp_addr_b_di2, bp_addr_b_df2, bp_addr_b_do2, 
	upd_addr_b_da2, upd_addr_b_di2, upd_addr_b_df2, upd_addr_b_do2, 

	wr_dx2,
	wr_addr_a_dx2, rd_addr_b_dx2,

	// --
	wr_dout_1, wr_dstate_1,
	wr_addr_a_dout_1, wr_addr_a_dstate_1,
	rd_addr_b_dout_1, rd_addr_b_dstate_1,

	sel_in1_1,
	sel_in2_1,
	sel_in3_1,
	sel_in4_1,
	sel_in5_1,
	sel_x1_1_1,
	sel_x1_2_1,
	sel_x2_2_1,
	sel_as_1_1,
	sel_as_2_1,
	sel_addsub_1,
	sel_temp_1,

	wr_da1, wr_di1, wr_df1, wr_do1,
	wr_addr_a_da1, wr_addr_a_di1, wr_addr_a_df1, wr_addr_a_do1,
	rd_addr_a_da1, rd_addr_a_di1, rd_addr_a_df1, rd_addr_a_do1,
	upd_addr_a_da1, upd_addr_a_di1, upd_addr_a_df1, upd_addr_a_do1, 
	bp_addr_b_da1, bp_addr_b_di1, bp_addr_b_df1, bp_addr_b_do1, 
	upd_addr_b_da1, upd_addr_b_di1, upd_addr_b_df1, upd_addr_b_do1, 
	

	rst_cost, acc_cost,
	
	// --
	rst_acc_1, rst_acc_2,

	// --
	o_cost
	);

// parameters
parameter ADDR_WIDTH = 12;
parameter WIDTH = 24;
parameter FRAC = 20;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 53;
parameter LAYR1_CELL = 53;
parameter LAYR2_CELL = 8;

parameter LAYR1_X = "layer1_x.list";
parameter LAYR1_H = "layer1_h.list";
parameter LAYR1_C = "layer1_c_bp.list";

parameter LAYR2_H = "layer2_h_bp.list";
parameter LAYR2_C = "layer2_c_bp.list";
parameter LAYR2_T = "layer2_t_bp.list";

parameter LAYR1_dOut = "layer1_dOut.list";
parameter LAYR1_dState = "layer1_dState.list";

parameter LAYR2_dOut = "layer2_dOut.list";
parameter LAYR2_dState = "layer2_dState.list";

// common ports
input clk, rst;

// control ports
input wr_h1, wr_c1;
input wr_wa_1, wr_wi_1, wr_wf_1, wr_wo_1;
input wr_ua_1, wr_ui_1, wr_uf_1, wr_uo_1;
input wr_ba_1, wr_bi_1, wr_bf_1, wr_bo_1;

input [11:0] wr_addr_a_h1, wr_addr_a_c1;
input [11:0] upd_addr_a_wa_1, upd_addr_a_wi_1, upd_addr_a_wf_1, upd_addr_a_wo_1;
input [11:0] bp_addr_a_wa_1, bp_addr_a_wi_1, bp_addr_a_wf_1, bp_addr_a_wo_1;
input [11:0] upd_addr_a_ua_1, upd_addr_a_ui_1, upd_addr_a_uf_1, upd_addr_a_uo_1;
input [11:0] bp_addr_a_ua_1, bp_addr_a_ui_1, bp_addr_a_uf_1, bp_addr_a_uo_1;
input [11:0] wr_addr_a_ba_1, wr_addr_a_bi_1, wr_addr_a_bf_1, wr_addr_a_bo_1;

input [11:0] rd_addr_b_x1, rd_addr_b_h1, rd_addr_b_c1;
input [11:0] rd_addr_b_wa_1, rd_addr_b_wi_1, rd_addr_b_wf_1, rd_addr_b_wo_1;
input [11:0] rd_addr_b_ua_1, rd_addr_b_ui_1, rd_addr_b_uf_1, rd_addr_b_uo_1;
input [11:0] rd_addr_b_ba_1, rd_addr_b_bi_1, rd_addr_b_bf_1, rd_addr_b_bo_1;

input update, bp;
input acc_x1, acc_h1;

input wr_act_1;
input [11:0] wr_addr_a_act_1;
input [11:0] rd_addr_b_a1, rd_addr_b_f1, rd_addr_b_i1, rd_addr_b_o1;

input rst_mac_1;

// --
input wr_h2, wr_c2;
input wr_wa_2, wr_wi_2, wr_wf_2, wr_wo_2;
input wr_ua_2, wr_ui_2, wr_uf_2, wr_uo_2;
input wr_ba_2, wr_bi_2, wr_bf_2, wr_bo_2;

input [11:0] wr_addr_a_h2, wr_addr_a_c2;
input [11:0] upd_addr_a_wa_2, upd_addr_a_wi_2, upd_addr_a_wf_2, upd_addr_a_wo_2;
input [11:0] bp_addr_a_wa_2, bp_addr_a_wi_2, bp_addr_a_wf_2, bp_addr_a_wo_2;
input [11:0] upd_addr_a_ua_2, upd_addr_a_ui_2, upd_addr_a_uf_2, upd_addr_a_uo_2;
input [11:0] bp_addr_a_ua_2, bp_addr_a_ui_2, bp_addr_a_uf_2, bp_addr_a_uo_2;
input [11:0] wr_addr_a_ba_2, wr_addr_a_bi_2, wr_addr_a_bf_2, wr_addr_a_bo_2;

input [11:0] rd_addr_b_h2, rd_addr_b_c2;
input [11:0] rd_addr_b_wa_2, rd_addr_b_wi_2, rd_addr_b_wf_2, rd_addr_b_wo_2;
input [11:0] rd_addr_b_ua_2, rd_addr_b_ui_2, rd_addr_b_uf_2, rd_addr_b_uo_2;
input [11:0] rd_addr_b_ba_2, rd_addr_b_bi_2, rd_addr_b_bf_2, rd_addr_b_bo_2;

input acc_x2, acc_h2;

input wr_act_2;
input [11:0] wr_addr_a_act_2;
input [11:0] rd_addr_b_a2, rd_addr_b_f2, rd_addr_b_i2, rd_addr_b_o2;

input rst_mac_2;

// -- bp
input wr_t2, rd_dgate;
input [11:0] wr_addr_a_t2, rd_addr_b_t2;

input wr_dout_2, wr_dstate_2;
input [11:0] wr_addr_a_dout_2, wr_addr_a_dstate_2;
input [11:0] rd_addr_b_dout_2, rd_addr_b_dstate_2;

input [1:0] sel_in1_2;
input [1:0] sel_in2_2;
input sel_in3_2;
input [1:0] sel_in4_2;
input [2:0] sel_in5_2;
input [1:0] sel_x1_1_2;
input sel_x1_2_2;
input [1:0] sel_x2_2_2;
input sel_as_1_2;
input [1:0] sel_as_2_2;
input sel_addsub_2;
input [1:0] sel_temp_2;

input wr_da2, wr_di2, wr_df2, wr_do2;
input [11:0] wr_addr_a_da2, wr_addr_a_di2, wr_addr_a_df2, wr_addr_a_do2;
input [11:0] rd_addr_a_da2, rd_addr_a_di2, rd_addr_a_df2, rd_addr_a_do2;
input [11:0] upd_addr_a_da2, upd_addr_a_di2, upd_addr_a_df2, upd_addr_a_do2;
input [11:0] upd_addr_b_da2, upd_addr_b_di2, upd_addr_b_df2, upd_addr_b_do2;
input [11:0] bp_addr_b_da2, bp_addr_b_di2, bp_addr_b_df2, bp_addr_b_do2;

input wr_dx2;
input [11:0] wr_addr_a_dx2, rd_addr_b_dx2;

//--
input wr_dout_1, wr_dstate_1;
input [11:0] wr_addr_a_dout_1, wr_addr_a_dstate_1;
input [11:0] rd_addr_b_dout_1, rd_addr_b_dstate_1;

input [1:0] sel_in1_1;
input [1:0] sel_in2_1;
input sel_in3_1;
input [1:0] sel_in4_1;
input [2:0] sel_in5_1;
input [1:0] sel_x1_1_1;
input sel_x1_2_1;
input [1:0] sel_x2_2_1;
input sel_as_1_1;
input [1:0] sel_as_2_1;
input sel_addsub_1;
input [1:0] sel_temp_1;

input wr_da1, wr_di1, wr_df1, wr_do1;
input [11:0] wr_addr_a_da1, wr_addr_a_di1, wr_addr_a_df1, wr_addr_a_do1;
input [11:0] rd_addr_a_da1, rd_addr_a_di1, rd_addr_a_df1, rd_addr_a_do1;
input [11:0] upd_addr_a_da1, upd_addr_a_di1, upd_addr_a_df1, upd_addr_a_do1;
input [11:0] upd_addr_b_da1, upd_addr_b_di1, upd_addr_b_df1, upd_addr_b_do1;
input [11:0] bp_addr_b_da1, bp_addr_b_di1, bp_addr_b_df1, bp_addr_b_do1;

input rst_cost, acc_cost;

// -- update weight
input rst_acc_1, rst_acc_2;

// input ports

// output ports
output signed [WIDTH-1:0] o_cost;

// registers

// wires
wire [ADDR_WIDTH-1:0] addr_a_wa_1, addr_a_wi_1, addr_a_wf_1, addr_a_wo_1;
wire [ADDR_WIDTH-1:0] addr_a_ua_1, addr_a_ui_1, addr_a_uf_1, addr_a_uo_1;

wire signed [WIDTH-1:0] new_wa_1, new_wi_1, new_wf_1, new_wo_1;
wire signed [WIDTH-1:0] new_ua_1, new_ui_1, new_uf_1, new_uo_1;
wire signed [WIDTH-1:0] new_ba_1, new_bi_1, new_bf_1, new_bo_1;

wire signed [WIDTH-1:0] o_a_h1, o_a_c1;
wire signed [WIDTH-1:0] o_a_wa_1, o_a_wi_1, o_a_wf_1, o_a_wo_1;
wire signed [WIDTH-1:0] o_a_ua_1, o_a_ui_1, o_a_uf_1, o_a_uo_1;
wire signed [WIDTH-1:0] o_a_ba_1, o_a_bi_1, o_a_bf_1, o_a_bo_1;

wire signed [WIDTH-1:0] o_b_x1, o_b_h1, o_b_c1;
wire signed [WIDTH-1:0] o_b_wa_1, o_b_wi_1, o_b_wf_1, o_b_wo_1;
wire signed [WIDTH-1:0] o_b_ua_1, o_b_ui_1, o_b_uf_1, o_b_uo_1;
wire signed [WIDTH-1:0] o_b_ba_1, o_b_bi_1, o_b_bf_1, o_b_bo_1;

wire signed [WIDTH-1:0] prev_h1, prev_c1;
wire signed [WIDTH-1:0] sh_x1, sh_h1;

wire signed [WIDTH-1:0] mux_bp_x1_1, mux_upd_x1_1, mux_upd_w1_1;
wire signed [WIDTH-1:0] mux_bp_x2_1, mux_upd_x2_1, mux_upd_w2_1;
wire signed [WIDTH-1:0] mux_bp_x3_1, mux_upd_x3_1, mux_upd_w3_1;
wire signed [WIDTH-1:0] mux_bp_x4_1, mux_upd_x4_1, mux_upd_w4_1;
wire signed [WIDTH-1:0] mux_bp_h1_1, mux_upd_h1_1, mux_upd_u1_1;
wire signed [WIDTH-1:0] mux_bp_h2_1, mux_upd_h2_1, mux_upd_u2_1;
wire signed [WIDTH-1:0] mux_bp_h3_1, mux_upd_h3_1, mux_upd_u3_1;
wire signed [WIDTH-1:0] mux_bp_h4_1, mux_upd_h4_1, mux_upd_u4_1;

wire signed [WIDTH-1:0] o_mac_x_1_1, o_mac_x_3_1, o_mac_x_5_1, o_mac_x_7_1;
wire signed [WIDTH-1:0] o_mac_h_2_1, o_mac_h_4_1, o_mac_h_6_1, o_mac_h_8_1;

wire signed [WIDTH-1:0] a1, i1, f1, o1, c1, h1;

wire signed [WIDTH-1:0] o_a_a1, o_a_i1, o_a_f1, o_a_o1;
wire signed [WIDTH-1:0] o_b_a1, o_b_i1, o_b_f1, o_b_o1;

// --
wire [ADDR_WIDTH-1:0] addr_a_wa_2, addr_a_wi_2, addr_a_wf_2, addr_a_wo_2;
wire [ADDR_WIDTH-1:0] addr_a_ua_2, addr_a_ui_2, addr_a_uf_2, addr_a_uo_2;

wire signed [WIDTH-1:0] new_wa_2, new_wi_2, new_wf_2, new_wo_2;
wire signed [WIDTH-1:0] new_ua_2, new_ui_2, new_uf_2, new_uo_2;
wire signed [WIDTH-1:0] new_ba_2, new_bi_2, new_bf_2, new_bo_2;

wire signed [WIDTH-1:0] o_a_h2, o_a_c2;
wire signed [WIDTH-1:0] o_a_wa_2, o_a_wi_2, o_a_wf_2, o_a_wo_2;
wire signed [WIDTH-1:0] o_a_ua_2, o_a_ui_2, o_a_uf_2, o_a_uo_2;
wire signed [WIDTH-1:0] o_a_ba_2, o_a_bi_2, o_a_bf_2, o_a_bo_2;

wire signed [WIDTH-1:0] o_b_x2, o_b_h2, o_b_c2;
wire signed [WIDTH-1:0] o_b_wa_2, o_b_wi_2, o_b_wf_2, o_b_wo_2;
wire signed [WIDTH-1:0] o_b_ua_2, o_b_ui_2, o_b_uf_2, o_b_uo_2;
wire signed [WIDTH-1:0] o_b_ba_2, o_b_bi_2, o_b_bf_2, o_b_bo_2;

wire signed [WIDTH-1:0] prev_h2, prev_c2;
wire signed [WIDTH-1:0] sh_x2, sh_h2;

wire signed [WIDTH-1:0] mux_bp_x1_2, mux_upd_x1_2, mux_upd_w1_2;
wire signed [WIDTH-1:0] mux_bp_x2_2, mux_upd_x2_2, mux_upd_w2_2;
wire signed [WIDTH-1:0] mux_bp_x3_2, mux_upd_x3_2, mux_upd_w3_2;
wire signed [WIDTH-1:0] mux_bp_x4_2, mux_upd_x4_2, mux_upd_w4_2;
wire signed [WIDTH-1:0] mux_bp_h1_2, mux_upd_h1_2, mux_upd_u1_2;
wire signed [WIDTH-1:0] mux_bp_h2_2, mux_upd_h2_2, mux_upd_u2_2;
wire signed [WIDTH-1:0] mux_bp_h3_2, mux_upd_h3_2, mux_upd_u3_2;
wire signed [WIDTH-1:0] mux_bp_h4_2, mux_upd_h4_2, mux_upd_u4_2;

wire signed [WIDTH-1:0] o_mac_x_1_2, o_mac_x_3_2, o_mac_x_5_2, o_mac_x_7_2;
wire signed [WIDTH-1:0] o_mac_h_2_2, o_mac_h_4_2, o_mac_h_6_2, o_mac_h_8_2;

wire signed [WIDTH-1:0] a2, i2, f2, o2, c2, h2;

wire signed [WIDTH-1:0] o_a_a2, o_a_i2, o_a_f2, o_a_o2;
wire signed [WIDTH-1:0] o_b_a2, o_b_i2, o_b_f2, o_b_o2;

//-- bp
wire signed [WIDTH-1:0] o_a_t2, o_b_t2;

wire signed [WIDTH-1:0] dout_2, dstate_2;
wire signed [WIDTH-1:0] o_a_dout_2, o_a_dstate_2;
wire signed [WIDTH-1:0] o_b_dout_2, o_b_dstate_2;

wire signed [WIDTH-1:0] dgate_2;

wire signed [WIDTH-1:0] o_a_da2, o_a_di2, o_a_df2, o_a_do2;
wire signed [WIDTH-1:0] o_b_da2, o_b_di2, o_b_df2, o_b_do2;

wire signed [WIDTH-1:0] dx2, o_a_dx2, o_b_dx2;

wire signed [WIDTH-1:0] o_dx2_adder_1, o_dx2_adder_2;
wire signed [WIDTH-1:0] o_dout_2_adder_1, o_dout_2_adder_2;

wire [11:0] addr_a_da2, addr_a_di2, addr_a_df2, addr_a_do2;
wire [11:0] bp_addr_a_da2, bp_addr_a_di2, bp_addr_a_df2, bp_addr_a_do2;

wire [11:0] addr_b_da2, addr_b_di2, addr_b_df2, addr_b_do2;

wire signed [WIDTH-1:0] o_acc_cost;
//--
wire signed [WIDTH-1:0] dout_1, dstate_1;
wire signed [WIDTH-1:0] o_a_dout_1, o_a_dstate_1;
wire signed [WIDTH-1:0] o_b_dout_1, o_b_dstate_1;

wire signed [WIDTH-1:0] dgate_1;

wire signed [WIDTH-1:0] o_a_da1, o_a_di1, o_a_df1, o_a_do1;
wire signed [WIDTH-1:0] o_b_da1, o_b_di1, o_b_df1, o_b_do1;

wire signed [WIDTH-1:0] o_dout_1_adder_1, o_dout_1_adder_2;

wire [11:0] addr_a_da1, addr_a_di1, addr_a_df1, addr_a_do1;
wire [11:0] bp_addr_a_da1, bp_addr_a_di1, bp_addr_a_df1, bp_addr_a_do1;

wire [11:0] addr_b_da1, addr_b_di1, addr_b_df1, addr_b_do1;

//-- update weight
wire signed [WIDTH-1:0] o_acc_da2, o_acc_di2, o_acc_df2, o_acc_do2;
wire signed [WIDTH-1:0] sh3_da2, sh3_di2, sh3_df2, sh3_do2;
wire signed [WIDTH-1:0] o_acc_da1, o_acc_di1, o_acc_df1, o_acc_do1;
wire signed [WIDTH-1:0] sh3_da1, sh3_di1, sh3_df1, sh3_do1;


//////////////////////////////////////////////
// FEED FORWARD /////////////////////////////
////////////////////////////////////////////


// LAYER 1 //////////////////////////////////

// Input Memory
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_INPUT),
			.TIMESTEP(TIMESTEP),
			.FILENAME(LAYR1_X)
		) inst_memory_cell_x1(
			.clk    (clk),			
			.wr_a   (),
			.addr_a (),
			.addr_b (rd_addr_b_x1),
			.i_a    (),
			.o_a    (),
			.o_b    (o_b_x1)
);

// LAYER 1 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_wa.list")
	) inst_memory_cell_wa_1 (
		.clk    (clk),		
		.wr_a   (wr_wa_1),
		.addr_a (addr_a_wa_1),
		.addr_b (rd_addr_b_wa_1),
		.i_a    (new_wa_1),
		.o_a    (o_a_wa_1),
		.o_b    (o_b_wa_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_wi.list")
	) inst_memory_cell_wi_1 (
		.clk    (clk),		
		.wr_a   (wr_wi_1),
		.addr_a (addr_a_wi_1),
		.addr_b (rd_addr_b_wi_1),
		.i_a    (new_wi_1),
		.o_a    (o_a_wi_1),
		.o_b    (o_b_wi_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_wf.list")
	) inst_memory_cell_wf_1 (
		.clk    (clk),		
		.wr_a   (wr_wf_1),
		.addr_a (addr_a_wf_1),
		.addr_b (rd_addr_b_wf_1),
		.i_a    (new_wf_1),
		.o_a    (o_a_wf_1),
		.o_b    (o_b_wf_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_wo.list")
	) inst_memory_cell_wo_1 (
		.clk    (clk),		
		.wr_a   (wr_wo_1),
		.addr_a (addr_a_wo_1),
		.addr_b (rd_addr_b_wo_1),
		.i_a    (new_wo_1),
		.o_a    (o_a_wo_1),
		.o_b    (o_b_wo_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_ua.list")
	) inst_memory_cell_ua_1 (
		.clk    (clk),		
		.wr_a   (wr_ua_1),
		.addr_a (addr_a_ua_1),
		.addr_b (rd_addr_b_ua_1),
		.i_a    (new_ua_1),
		.o_a    (o_a_ua_1),
		.o_b    (o_b_ua_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_ui.list")
	) inst_memory_cell_ui_1 (
		.clk    (clk),		
		.wr_a   (wr_ui_1),
		.addr_a (addr_a_ui_1),
		.addr_b (rd_addr_b_ui_1),
		.i_a    (new_ui_1),
		.o_a    (o_a_ui_1),
		.o_b    (o_b_ui_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_uf.list")
	) inst_memory_cell_uf_1 (
		.clk    (clk),		
		.wr_a   (wr_uf_1),
		.addr_a (addr_a_uf_1),
		.addr_b (rd_addr_b_uf_1),
		.i_a    (new_uf_1),
		.o_a    (o_a_uf_1),
		.o_b    (o_b_uf_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_uo.list")
	) inst_memory_cell_uo_1 (
		.clk    (clk),		
		.wr_a   (wr_uo_1),
		.addr_a (addr_a_uo_1),
		.addr_b (rd_addr_b_uo_1),
		.i_a    (new_uo_1),
		.o_a    (o_a_uo_1),
		.o_b    (o_b_uo_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_ba.list")
	) inst_memory_cell_ba_1 (
		.clk    (clk),		
		.wr_a   (wr_ba_1),
		.addr_a (wr_addr_a_ba_1),
		.addr_b (rd_addr_b_ba_1),
		.i_a    (new_ba_1),
		.o_a    (o_a_ba_1),
		.o_b    (o_b_ba_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_bi.list")
	) inst_memory_cell_bi_1 (
		.clk    (clk),		
		.wr_a   (wr_bi_1),
		.addr_a (wr_addr_a_bi_1),
		.addr_b (rd_addr_b_bi_1),
		.i_a    (new_bi_1),
		.o_a    (o_a_bi_1),
		.o_b    (o_b_bi_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_bf.list")
	) inst_memory_cell_bf_1 (
		.clk    (clk),		
		.wr_a   (wr_bf_1),
		.addr_a (wr_addr_a_bf_1),
		.addr_b (rd_addr_b_bf_1),
		.i_a    (new_bf_1),
		.o_a    (o_a_bf_1),
		.o_b    (o_b_bf_1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_bo.list")
	) inst_memory_cell_bo_1 (
		.clk    (clk),		
		.wr_a   (wr_bo_1),
		.addr_a (wr_addr_a_bo_1),
		.addr_b (rd_addr_b_bo_1),
		.i_a    (new_bo_1),
		.o_a    (o_a_bo_1),
		.o_b    (o_b_bo_1)
	);
assign addr_a_wa_1 = update ? upd_addr_a_wa_1 : bp_addr_a_wa_1 ;
assign addr_a_wi_1 = update ? upd_addr_a_wi_1 : bp_addr_a_wi_1 ;
assign addr_a_wf_1 = update ? upd_addr_a_wf_1 : bp_addr_a_wf_1 ;
assign addr_a_wo_1 = update ? upd_addr_a_wo_1 : bp_addr_a_wo_1 ;
assign addr_a_ua_1 = update ? upd_addr_a_ua_1 : bp_addr_a_ua_1 ;
assign addr_a_ui_1 = update ? upd_addr_a_ui_1 : bp_addr_a_ui_1 ;
assign addr_a_uf_1 = update ? upd_addr_a_uf_1 : bp_addr_a_uf_1 ;
assign addr_a_uo_1 = update ? upd_addr_a_uo_1 : bp_addr_a_uo_1 ;

// LAYER 1 Output Memory
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME(LAYR1_H)
		) inst_memory_cell_h1 (
			.clk    (clk),			
			.wr_a   (wr_h1),
			.addr_a (wr_addr_a_h1),
			.addr_b (rd_addr_b_h1),
			.i_a    (h1),
			.o_a    (o_a_h1),
			.o_b    (o_b_h1)
);

// LAYER 1 State Memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP+1),
		.FILENAME(LAYR1_C)
	) inst_mem_c (
		.clk    (clk),		
		.wr_a   (wr_c1),
		.addr_a (wr_addr_a_c1),
		.addr_b (rd_addr_b_c1),
		.i_a    (c1),
		.o_a    (o_a_c1),
		.o_b    (o_b_c1)
	);

assign prev_h1 = o_a_h1;
assign prev_c1 = o_a_c1;

assign sh_x1 = o_b_x1[WIDTH-1] ? {3'b111,o_b_x1[WIDTH-1:3]} : {3'b000,o_b_x1[WIDTH-1:3]};
assign sh_h1 = o_a_h1[WIDTH-1] ? {3'b111,o_a_h1[WIDTH-1:3]} : {3'b000,o_a_h1[WIDTH-1:3]};

// LAYER 1 Multiplexers
assign mux_bp_x1_1 = bp ? o_a_da1 : o_b_x1 ;
assign mux_upd_x1_1 = update ? sh_x1 : mux_bp_x1_1;
assign mux_upd_w1_1 = update ? o_a_da1 : o_a_wa_1;

assign mux_bp_x2_1 = bp ? o_a_di1 : o_b_x1 ;
assign mux_upd_x2_1 = update ? sh_x1 : mux_bp_x2_1;
assign mux_upd_w2_1 = update ? o_a_di1 : o_a_wi_1;

assign mux_bp_x3_1 = bp ? o_a_df1 : o_b_x1 ;
assign mux_upd_x3_1 = update ? sh_x1 : mux_bp_x3_1;
assign mux_upd_w3_1 = update ? o_a_df1 : o_a_wf_1;

assign mux_bp_x4_1 = bp ? o_a_do1 : o_b_x1 ;
assign mux_upd_x4_1 = update ? sh_x1 : mux_bp_x4_1;
assign mux_upd_w4_1 = update ? o_a_do1 : o_a_wo_1;

assign mux_bp_h1_1 = bp ? o_b_da1 : prev_h1 ;
assign mux_upd_h1_1 = update ? sh_h1 : mux_bp_h1_1;
assign mux_upd_u1_1 = update ? o_b_da1 : o_a_ua_1;

assign mux_bp_h2_1 = bp ? o_b_di1 : prev_h1 ;
assign mux_upd_h2_1 = update ? sh_h1 : mux_bp_h2_1;
assign mux_upd_u2_1 = update ? o_b_di1 : o_a_ui_1;

assign mux_bp_h3_1 = bp ? o_b_df1 : prev_h1 ;
assign mux_upd_h3_1 = update ? sh_h1 : mux_bp_h3_1;
assign mux_upd_u3_1 = update ? o_b_df1 : o_a_uf_1;

assign mux_bp_h4_1 = bp ? o_b_do1 : prev_h1 ;
assign mux_upd_h4_1 = update ? sh_h1 : mux_bp_h4_1;
assign mux_upd_u4_1 = update ? o_b_do1 : o_a_uo_1;

// LAYER 1 Core
// ex: mac1, x1*w1, h1*u1, x2*w2, so on ...
lstm_core #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_core_1 (
		.clk          (clk),
		.rst          (rst_mac_1),
		.acc_x        (acc_x1),
		.acc_h        (acc_h1),
		.i_x1         (mux_upd_x1_1),
		.i_w1         (mux_upd_w1_1),
		.i_h1         (mux_upd_h1_1),
		.i_u1         (mux_upd_u1_1),
		.i_x2         (mux_upd_x2_1),
		.i_w2         (mux_upd_w2_1),
		.i_h2         (mux_upd_h2_1),
		.i_u2         (mux_upd_u2_1),
		.i_x3         (mux_upd_x3_1),
		.i_w3         (mux_upd_w3_1),
		.i_h3         (mux_upd_h3_1),
		.i_u3         (mux_upd_u3_1),
		.i_x4         (mux_upd_x4_1),
		.i_w4         (mux_upd_w4_1),
		.i_h4         (mux_upd_h4_1),
		.i_u4         (mux_upd_u4_1),
		.i_prev_state (prev_c1),
		.i_b_a        (o_b_ba_1),
		.i_b_i        (o_b_bi_1),
		.i_b_f        (o_b_bf_1),
		.i_b_o        (o_b_bo_1),
		.o_mac_1      (o_mac_x_1_1),
		.o_mac_2      (o_mac_h_2_1),
		.o_mac_3      (o_mac_x_3_1),
		.o_mac_4      (o_mac_h_4_1),
		.o_mac_5      (o_mac_x_5_1),
		.o_mac_6      (o_mac_h_6_1),
		.o_mac_7      (o_mac_x_7_1),
		.o_mac_8      (o_mac_h_8_1),
		.o_a          (a1),
		.o_i          (i1),
		.o_f          (f1),
		.o_o          (o1),
		.o_c          (c1),
		.o_h          (h1)
	);

// LAYER 1 Activation Memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer1_a_bp.list")
	) inst_memory_cell_a1 (
		.clk    (clk),		
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_a_act_1),
		.addr_b (rd_addr_b_a1),
		.i_a    (a1),
		.o_a    (o_a_a1),
		.o_b    (o_b_a1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP+1),
		.FILENAME("layer1_f_bp.list")
	) inst_memory_cell_f1 (
		.clk    (clk),		
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_a_act_1),
		.addr_b (rd_addr_b_f1),
		.i_a    (f1),
		.o_a    (o_a_f1),
		.o_b    (o_b_f1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer1_i_bp.list")
	) inst_memory_cell_i1 (
		.clk    (clk),		
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_a_act_1),
		.addr_b (rd_addr_b_i1),
		.i_a    (i1),
		.o_a    (o_a_i1),
		.o_b    (o_b_i1)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer1_o_bp.list")
	) inst_memory_cell_o1 (
		.clk    (clk),		
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_a_act_1),
		.addr_b (rd_addr_b_o1),
		.i_a    (o1),
		.o_a    (o_a_o1),
		.o_b    (o_b_o1)
	);

// LAYER 2 //////////////////////////////////

// LAYER 2 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_wa.list")
	) inst_memory_cell_wa_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_wa_2),
		.addr_b (rd_addr_b_wa_2),
		.i_a    (new_wa_2),
		.o_a    (o_a_wa_2),
		.o_b    (o_b_wa_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_wi.list")
	) inst_memory_cell_wi_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_wi_2),
		.addr_b (rd_addr_b_wi_2),
		.i_a    (new_wi_2),
		.o_a    (o_a_wi_2),
		.o_b    (o_b_wi_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_wf.list")
	) inst_memory_cell_wf_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_wf_2),
		.addr_b (rd_addr_b_wf_2),
		.i_a    (new_wf_2),
		.o_a    (o_a_wf_2),
		.o_b    (o_b_wf_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_wo.list")
	) inst_memory_cell_wo_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_wo_2),
		.addr_b (rd_addr_b_wo_2),
		.i_a    (new_wo_2),
		.o_a    (o_a_wo_2),
		.o_b    (o_b_wo_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_ua.list")
	) inst_memory_cell_ua_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_ua_2),
		.addr_b (rd_addr_b_ua_2),
		.i_a    (new_ua_2),
		.o_a    (o_a_ua_2),
		.o_b    (o_b_ua_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_ui.list")
	) inst_memory_cell_ui_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_ui_2),
		.addr_b (rd_addr_b_ui_2),
		.i_a    (new_ui_2),
		.o_a    (o_a_ui_2),
		.o_b    (o_b_ui_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_uf.list")
	) inst_memory_cell_uf_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_uf_2),
		.addr_b (rd_addr_b_uf_2),
		.i_a    (new_uf_2),
		.o_a    (o_a_uf_2),
		.o_b    (o_b_uf_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_uo.list")
	) inst_memory_cell_uo_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (addr_a_uo_2),
		.addr_b (rd_addr_b_uo_2),
		.i_a    (new_uo_2),
		.o_a    (o_a_uo_2),
		.o_b    (o_b_uo_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_ba.list")
	) inst_memory_cell_ba_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (wr_addr_a_ba_2),
		.addr_b (rd_addr_b_ba_2),
		.i_a    (new_ba_2),
		.o_a    (o_a_ba_2),
		.o_b    (o_b_ba_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_bi.list")
	) inst_memory_cell_bi_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (wr_addr_a_bi_2),
		.addr_b (rd_addr_b_bi_2),
		.i_a    (new_bi_2),
		.o_a    (o_a_bi_2),
		.o_b    (o_b_bi_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_bf.list")
	) inst_memory_cell_bf_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (wr_addr_a_bf_2),
		.addr_b (rd_addr_b_bf_2),
		.i_a    (new_bf_2),
		.o_a    (o_a_bf_2),
		.o_b    (o_b_bf_2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_bo.list")
	) inst_memory_cell_bo_2 (
		.clk    (clk),		
		.wr_a   (),
		.addr_a (wr_addr_a_bo_2),
		.addr_b (rd_addr_b_bo_2),
		.i_a    (new_bo_2),
		.o_a    (o_a_bo_2),
		.o_b    (o_b_bo_2)
	);

assign addr_a_wa_2 = update ? upd_addr_a_wa_2 : bp_addr_a_wa_2 ;
assign addr_a_wi_2 = update ? upd_addr_a_wi_2 : bp_addr_a_wi_2 ;
assign addr_a_wf_2 = update ? upd_addr_a_wf_2 : bp_addr_a_wf_2 ;
assign addr_a_wo_2 = update ? upd_addr_a_wo_2 : bp_addr_a_wo_2 ;
assign addr_a_ua_2 = update ? upd_addr_a_ua_2 : bp_addr_a_ua_2 ;
assign addr_a_ui_2 = update ? upd_addr_a_ui_2 : bp_addr_a_ui_2 ;
assign addr_a_uf_2 = update ? upd_addr_a_uf_2 : bp_addr_a_uf_2 ;
assign addr_a_uo_2 = update ? upd_addr_a_uo_2 : bp_addr_a_uo_2 ;

// LAYER 2 Output Memory
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR2_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME(LAYR2_H)
		) inst_memory_cell_h2 (
			.clk    (clk),			
			.wr_a   (wr_h2),
			.addr_a (wr_addr_a_h2),
			.addr_b (rd_addr_b_h2),
			.i_a    (h2),
			.o_a    (o_a_h2),
			.o_b    (o_b_h2)
);

// LAYER 2 State Memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP+1),
		.FILENAME(LAYR2_C)
	) inst_memory_cell_c2 (
		.clk    (clk),		
		.wr_a   (wr_c2),
		.addr_a (wr_addr_a_c2),
		.addr_b (rd_addr_b_c2),
		.i_a    (c2),
		.o_a    (o_a_c2),
		.o_b    (o_b_c2)
	);

assign prev_h2 = o_a_h2;
assign prev_c2 = o_a_c2;

assign sh_x2 = o_a_h1[WIDTH-1] ? {3'b111,o_a_h1[WIDTH-1:3]} : {3'b000,o_a_h1[WIDTH-1:3]};
assign sh_h2 = o_a_h2[WIDTH-1] ? {3'b111,o_a_h2[WIDTH-1:3]} : {3'b000,o_a_h2[WIDTH-1:3]};

// LAYER 1 Multiplexers
assign mux_bp_x1_2 = bp ? o_a_da2 : o_a_h1 ;
assign mux_upd_x1_2 = update ? sh_x2 : mux_bp_x1_2;
assign mux_upd_w1_2 = update ? o_b_da2 : o_a_wa_2;

assign mux_bp_x2_2 = bp ? o_a_di2 : o_a_h1 ;
assign mux_upd_x2_2 = update ? sh_x2 : mux_bp_x2_2;
assign mux_upd_w2_2 = update ? o_b_di2 : o_a_wi_2;

assign mux_bp_x3_2 = bp ? o_a_df2 : o_a_h1 ;
assign mux_upd_x3_2 = update ? sh_x2 : mux_bp_x3_2;
assign mux_upd_w3_2 = update ? o_b_df2 : o_a_wf_2;

assign mux_bp_x4_2 = bp ? o_a_do2 : o_a_h1 ;
assign mux_upd_x4_2 = update ? sh_x2 : mux_bp_x4_2;
assign mux_upd_w4_2 = update ? o_b_do2 : o_a_wo_2;

assign mux_bp_h1_2 = bp ? o_a_da2 : prev_h2 ;
assign mux_upd_h1_2 = update ? sh_h2 : mux_bp_h1_2;
assign mux_upd_u1_2 = update ? o_b_da2 : o_a_ua_2;

assign mux_bp_h2_2 = bp ? o_a_di2 : prev_h2 ;
assign mux_upd_h2_2 = update ? sh_h2 : mux_bp_h2_2;
assign mux_upd_u2_2 = update ? o_b_di2 : o_a_ui_2;

assign mux_bp_h3_2 = bp ? o_a_df2 : prev_h2 ;
assign mux_upd_h3_2 = update ? sh_h2 : mux_bp_h3_2;
assign mux_upd_u3_2 = update ? o_b_df2 : o_a_uf_2;

assign mux_bp_h4_2 = bp ? o_a_do2 : prev_h2 ;
assign mux_upd_h4_2 = update ? sh_h2 : mux_bp_h4_2;
assign mux_upd_u4_2 = update ? o_b_do2 : o_a_uo_2;

// LAYER 2 Core
// ex: mac1, x1*w1, h1*u1, x2*w2, so on ...
lstm_core #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_core_2 (
		.clk          (clk),
		.rst          (rst_mac_2),
		.acc_x        (acc_x2),
		.acc_h        (acc_h2),
		.i_x1         (mux_upd_x1_2),
		.i_w1         (mux_upd_w1_2),
		.i_h1         (mux_upd_h1_2),
		.i_u1         (mux_upd_u1_2),
		.i_x2         (mux_upd_x2_2),
		.i_w2         (mux_upd_w2_2),
		.i_h2         (mux_upd_h2_2),
		.i_u2         (mux_upd_u2_2),
		.i_x3         (mux_upd_x3_2),
		.i_w3         (mux_upd_w3_2),
		.i_h3         (mux_upd_h3_2),
		.i_u3         (mux_upd_u3_2),
		.i_x4         (mux_upd_x4_2),
		.i_w4         (mux_upd_w4_2),
		.i_h4         (mux_upd_h4_2),
		.i_u4         (mux_upd_u4_2),
		.i_prev_state (prev_c2),
		.i_b_a        (o_b_ba_2),
		.i_b_i        (o_b_bi_2),
		.i_b_f        (o_b_bf_2),
		.i_b_o        (o_b_bo_2),
		.o_mac_1      (o_mac_x_1_2),
		.o_mac_2      (o_mac_h_2_2),
		.o_mac_3      (o_mac_x_3_2),
		.o_mac_4      (o_mac_h_4_2),
		.o_mac_5      (o_mac_x_5_2),
		.o_mac_6      (o_mac_h_6_2),
		.o_mac_7      (o_mac_x_7_2),
		.o_mac_8      (o_mac_h_8_2),
		.o_a          (a2),
		.o_i          (i2),
		.o_f          (f2),
		.o_o          (o2),
		.o_c          (c2),
		.o_h          (h2)
	);

// LAYER 2 Activation Memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer2_a_bp.list")
	) inst_memory_cell_a2 (
		.clk    (clk),		
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_a_act_2),
		.addr_b (rd_addr_b_a2),
		.i_a    (a2),
		.o_a    (o_a_a2),
		.o_b    (o_b_a2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP+1),
		.FILENAME("layer2_f_bp.list")
	) inst_memory_cell_f2 (
		.clk    (clk),		
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_a_act_2),
		.addr_b (rd_addr_b_f2),
		.i_a    (f2),
		.o_a    (o_a_f2),
		.o_b    (o_b_f2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer2_i_bp.list")
	) inst_memory_cell_i2 (
		.clk    (clk),		
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_a_act_2),
		.addr_b (rd_addr_b_i2),
		.i_a    (i2),
		.o_a    (o_a_i2),
		.o_b    (o_b_i2)
	);
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer2_o_bp.list")
	) inst_memory_cell_o2 (
		.clk    (clk),		
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_a_act_2),
		.addr_b (rd_addr_b_o2),
		.i_a    (o2),
		.o_a    (o_a_o2),
		.o_b    (o_b_o2)
	);

//////////////////////////////////////////////
// BACKPROPAGATION //////////////////////////
////////////////////////////////////////////

// Label Memory
memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(7),
        .FILENAME(LAYR2_T)
    ) inst_memory_cell_t (
        .clk    (clk),        
        .wr_a   (wr_t2),
        .addr_a (wr_addr_a_t2),
        .addr_b (rd_addr_b_t2),
        .i_a    (),
        .o_a    (o_a_t2),
        .o_b    (o_b_t2)
    );

// LAYER 2 //////////////////////////////////

// LAYER 2 Delta Out Memory
memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dOut)
    ) inst_memory_cell_dout_2 (
        .clk    (clk),        
        .wr_a   (wr_dout_2),
        .addr_a (wr_addr_a_dout_2),
        .addr_b (rd_addr_b_dout_2),
        .i_a    (dout_2),
        .o_a    (o_a_dout_2),
        .o_b    (o_b_dout_2)
    );

// LAYER 2 Delta State Memory
memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(2),
        .FILENAME(LAYR2_dState)
    ) mem_dstate_2 (
        .clk    (clk),        
        .wr_a   (wr_dstate_2),
        .addr_a (wr_addr_a_dstate_2),
        .addr_b (rd_addr_b_dstate_2),
        .i_a    (dstate_2),
        .o_a    (o_a_dstate_2),
        .o_b    (o_b_dstate_2)
    );

// LAYER 2 Delta Core
delta #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_delta_2 (
		.clk        (clk),
		.rst        (rst),
		.sel_in1    (sel_in1_2),
		.sel_in2    (sel_in2_2),
		.sel_in3    (sel_in3_2),
		.sel_in4    (sel_in4_2),
		.sel_in5    (sel_in5_2),
		.sel_x1_1   (sel_x1_1_2),
		.sel_x1_2   (sel_x1_2_2),
		.sel_x2_2   (sel_x2_2_2),
		.sel_as_1   (sel_as_1_2),
		.sel_as_2   (sel_as_2_2),
		.sel_addsub (sel_addsub_2),
		.sel_temp   (sel_temp_2),
		.at         (o_b_a2),
		.it         (o_b_i2),
		.ft         (o_b_f2),
		.ot         (o_b_o2),
		.h          (o_b_h2),
		.t          (o_b_t2),
		.state      (o_b_c2),
		.d_out      (o_b_dout_2),
		.d_state    (o_b_dstate_2),
		.o_dgate    (dgate_2),
		.o_d_state  (dstate_2)
	);

// LAYER 2 Delta Gates Memory
assign bp_addr_a_da2 = rd_dgate ? rd_addr_a_da2 : wr_addr_a_da2;
assign addr_a_da2 = update ? upd_addr_a_da2 : bp_addr_a_da2;
assign addr_b_da2 = update ? upd_addr_b_da2 : bp_addr_b_da2;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer2_dA.list")
    ) inst_memory_cell_da2 (
        .clk    (clk),        
        .wr_a   (wr_da2),
        .addr_a (addr_a_da2),
        .addr_b (addr_b_da2),
        .i_a    (dgate_2),
        .o_a    (o_a_da2),
        .o_b    (o_b_da2)
    );
assign bp_addr_a_di2 = rd_dgate ? rd_addr_a_di2 : wr_addr_a_di2;
assign addr_a_di2 = update ? upd_addr_a_di2 : bp_addr_a_di2;
assign addr_b_di2 = update ? upd_addr_b_di2 : bp_addr_b_di2;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer2_dI.list")
    ) inst_memory_cell_di2 (
        .clk    (clk),        
        .wr_a   (wr_di2),
        .addr_a (addr_a_di2),
        .addr_b (addr_b_di2),
        .i_a    (dgate_2),
        .o_a    (o_a_di2),
        .o_b    (o_b_di2)
    );
assign bp_addr_a_df2 = rd_dgate ? rd_addr_a_df2 : wr_addr_a_df2;
assign addr_a_df2 = update ? upd_addr_a_df2 : bp_addr_a_df2;
assign addr_b_df2 = update ? upd_addr_b_df2 : bp_addr_b_df2;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer2_dF.list")
    ) inst_memory_cell_df2 (
        .clk    (clk),        
        .wr_a   (wr_df2),
        .addr_a (addr_a_df2),
        .addr_b (addr_b_df2),
        .i_a    (dgate_2),
        .o_a    (o_a_df2),
        .o_b    (o_b_df2)
    );
assign bp_addr_a_do2 = rd_dgate ? rd_addr_a_do2 : wr_addr_a_do2;
assign addr_a_do2 = update ? upd_addr_a_do2 : bp_addr_a_do2;
assign addr_b_do2 = update ? upd_addr_b_do2 : bp_addr_b_do2;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer2_dO.list")
    ) inst_memory_cell_do2 (
        .clk    (clk),        
        .wr_a   (wr_do2),
        .addr_a (addr_a_do2),
        .addr_b (addr_b_do2),
        .i_a    (dgate_2),
        .o_a    (o_a_do2),
        .o_b    (o_b_do2)
    );

// LAYER 2 Delta X Memory
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(2),
        .FILENAME("layer2_dX.list")
    ) inst_memory_cell_dx2 (
        .clk    (clk),        
        .wr_a   (wr_dx2),
        .addr_a (wr_addr_a_dx2),
        .addr_b (rd_addr_b_dx2),
        .i_a    (dx2),
        .o_a    (o_a_dx2),
        .o_b    (o_b_dx2)
    );

// LAYER 2 Calculate Delta X
adder_2in #(.WIDTH(WIDTH)) dx2_adder_1 (.i_a(o_mac_x_1_2), .i_b(o_mac_x_3_2), .o(o_dx2_adder_1));
adder_2in #(.WIDTH(WIDTH)) dx2_adder_2 (.i_a(o_mac_x_5_2), .i_b(o_mac_x_7_2), .o(o_dx2_adder_2));
adder_2in #(.WIDTH(WIDTH)) dx2_adder_3 (.i_a(o_dx2_adder_1), .i_b(o_dx2_adder_2), .o(dx2));

// LAYER 2 Calculate Delta Out
adder_2in #(.WIDTH(WIDTH)) dout_2_adder_1 (.i_a(o_mac_h_2_2), .i_b(o_mac_h_4_2), .o(o_dout_2_adder_1));
adder_2in #(.WIDTH(WIDTH)) dout_2_adder_2 (.i_a(o_mac_h_6_2), .i_b(o_mac_h_8_2), .o(o_dout_2_adder_2));
adder_2in #(.WIDTH(WIDTH)) dout_2_adder_3 (.i_a(o_dout_2_adder_1), .i_b(o_dout_2_adder_2), .o(dout_2));

// ACCUMULATOR for Cost function
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_cost (.clk(clk), .rst(rst_cost), .acc(acc_cost), .i(dgate_2), .o(o_acc_cost));
assign o_cost = o_acc_cost >> 4;

// LAYER 1 //////////////////////////////////

// LAYER 1 Delta Out Memory
memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dOut)
    ) inst_memory_cell_dout_1 (
        .clk    (clk),        
        .wr_a   (wr_dout_1),
        .addr_a (wr_addr_a_dout_1),
        .addr_b (rd_addr_b_dout_1),
        .i_a    (dout_1),
        .o_a    (o_a_dout_1),
        .o_b    (o_b_dout_1)
    );

// LAYER 1 delta State Memory
memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(2),
        .FILENAME(LAYR1_dState)
    ) mem_dstate_1 (
        .clk    (clk),        
        .wr_a   (wr_dstate_1),
        .addr_a (wr_addr_a_dstate_1),
        .addr_b (rd_addr_b_dstate_1),
        .i_a    (dstate_1),
        .o_a    (o_a_dstate_1),
        .o_b    (o_b_dstate_1)
    );

// LAYER 1 Delta Core
delta #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_delta_1 (
		.clk        (clk),
		.rst        (rst),
		.sel_in1    (sel_in1_1),
		.sel_in2    (sel_in2_1),
		.sel_in3    (sel_in3_1),
		.sel_in4    (sel_in4_1),
		.sel_in5    (sel_in5_1),
		.sel_x1_1   (sel_x1_1_1),
		.sel_x1_2   (sel_x1_2_1),
		.sel_x2_2   (sel_x2_2_1),
		.sel_as_1   (sel_as_1_1),
		.sel_as_2   (sel_as_2_1),
		.sel_addsub (sel_addsub_1),
		.sel_temp   (sel_temp_1),
		.at         (o_b_a1),
		.it         (o_b_i1),
		.ft         (o_b_f1),
		.ot         (o_b_o1),
		.h          (o_b_dx2),
		.t          ({WIDTH{1'b0}}),
		.state      (o_b_c1),
		.d_out      (o_b_dout_1),
		.d_state    (o_b_dstate_1),
		.o_dgate    (dgate_1),
		.o_d_state  (dstate_1)
	);

// LAYER 1 Delta Gates Memory
assign bp_addr_a_da1 = rd_dgate ? rd_addr_a_da1 : wr_addr_a_da1;
assign addr_a_da1 = update ? upd_addr_a_da1 : bp_addr_a_da1;
assign addr_b_da1 = update ? upd_addr_b_da1 : bp_addr_b_da1;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer1_dA.list")
    ) inst_memory_cell_da1 (
        .clk    (clk),        
        .wr_a   (wr_da1),
        .addr_a (addr_a_da1),
        .addr_b (addr_b_da1),
        .i_a    (dgate_1),
        .o_a    (o_a_da1),
        .o_b    (o_b_da1)
    );
assign bp_addr_a_di1 = rd_dgate ? rd_addr_a_da1 : wr_addr_a_da1;
assign addr_a_di1 = update ? upd_addr_a_di1 : bp_addr_a_di1;
assign addr_b_di1 = update ? upd_addr_b_di1 : bp_addr_b_di1;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer1_dI.list")
    ) inst_memory_cell_di1 (
        .clk    (clk),        
        .wr_a   (wr_di1),
        .addr_a (addr_a_di1),
        .addr_b (addr_b_di1),
        .i_a    (dgate_1),
        .o_a    (o_a_di1),
        .o_b    (o_b_di1)
    );
assign bp_addr_a_df1 = rd_dgate ? rd_addr_a_da1 : wr_addr_a_da1;
assign addr_a_df1 = update ? upd_addr_a_df1 : bp_addr_a_df1;
assign addr_b_df1 = update ? upd_addr_b_df1 : bp_addr_b_df1;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer1_dF.list")
    ) inst_memory_cell_df1 (
        .clk    (clk),        
        .wr_a   (wr_df1),
        .addr_a (addr_a_df1),
        .addr_b (addr_b_df1),
        .i_a    (dgate_1),
        .o_a    (o_a_df1),
        .o_b    (o_b_df1)
    );
assign bp_addr_a_do1 = rd_dgate ? rd_addr_a_da1 : wr_addr_a_da1;
assign addr_a_do1 = update ? upd_addr_a_do1 : bp_addr_a_do1;
assign addr_b_do1 = update ? upd_addr_b_do1 : bp_addr_b_do1;
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME("layer1_dO.list")
    ) inst_memory_cell_do1 (
        .clk    (clk),        
        .wr_a   (wr_do1),
        .addr_a (addr_a_do1),
        .addr_b (addr_b_do1),
        .i_a    (dgate_1),
        .o_a    (o_a_do1),
        .o_b    (o_b_do1)
    );

// LAYER 2 Calculate Delta Out
adder_2in #(.WIDTH(WIDTH)) dout_1_adder_1 (.i_a(o_mac_h_2_1), .i_b(o_mac_h_4_1), .o(o_dout_1_adder_1));
adder_2in #(.WIDTH(WIDTH)) dout_1_adder_2 (.i_a(o_mac_h_6_1), .i_b(o_mac_h_8_1), .o(o_dout_1_adder_2));
adder_2in #(.WIDTH(WIDTH)) dout_1_adder_3 (.i_a(o_dout_1_adder_1), .i_b(o_dout_1_adder_2), .o(dout_1));

//////////////////////////////////////////////
// UPDATE WEIGHT ////////////////////////////
////////////////////////////////////////////


// LAYER 2 //////////////////////////////////

// LAYER 2 Update W
assign new_wa_2 = o_b_wa_2 - o_mac_x_1_2;
assign new_wi_2 = o_b_wi_2 - o_mac_x_3_2;
assign new_wf_2 = o_b_wf_2 - o_mac_x_5_2;
assign new_wo_2 = o_b_wo_2 - o_mac_x_7_2;

// LAYER 2 Update U
assign new_ua_2 = o_b_ua_2 - o_mac_h_2_2;
assign new_ui_2 = o_b_ui_2 - o_mac_h_4_2;
assign new_uf_2 = o_b_uf_2 - o_mac_h_6_2;
assign new_uo_2 = o_b_uo_2 - o_mac_h_8_2;

// LAYER 2 Update B
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_da2 (.clk(clk), .rst(rst_acc_2), .acc(acc_dgate2), .i(mux_upd_w1_2), .o(o_acc_da2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_di2 (.clk(clk), .rst(rst_acc_2), .acc(acc_dgate2), .i(mux_upd_w2_2), .o(o_acc_di2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_df2 (.clk(clk), .rst(rst_acc_2), .acc(acc_dgate2), .i(mux_upd_w3_2), .o(o_acc_df2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_do2 (.clk(clk), .rst(rst_acc_2), .acc(acc_dgate2), .i(mux_upd_w4_2), .o(o_acc_do2));

assign sh3_da2 = o_acc_da2[WIDTH-1] ? {3'b111,o_acc_da2[WIDTH-1:3]} : {3'b000,o_acc_da2[WIDTH-1:3]}; 
assign sh3_di2 = o_acc_di2[WIDTH-1] ? {3'b111,o_acc_di2[WIDTH-1:3]} : {3'b000,o_acc_di2[WIDTH-1:3]}; 
assign sh3_df2 = o_acc_df2[WIDTH-1] ? {3'b111,o_acc_df2[WIDTH-1:3]} : {3'b000,o_acc_df2[WIDTH-1:3]}; 
assign sh3_do2 = o_acc_do2[WIDTH-1] ? {3'b111,o_acc_do2[WIDTH-1:3]} : {3'b000,o_acc_do2[WIDTH-1:3]}; 

assign new_ba_2 = o_b_ba_2 - sh3_da2;
assign new_bi_2 = o_b_bi_2 - sh3_di2;
assign new_bf_2 = o_b_bf_2 - sh3_df2;
assign new_bo_2 = o_b_bo_2 - sh3_do2;


// LAYER 1 //////////////////////////////////

// LAYER 1 Update W
assign new_wa_1 = o_b_wa_1 - o_mac_x_1_1;
assign new_wi_1 = o_b_wi_1 - o_mac_x_3_1;
assign new_wf_1 = o_b_wf_1 - o_mac_x_5_1;
assign new_wo_1 = o_b_wo_1 - o_mac_x_7_1;

// LAYER 1 Update U
assign new_ua_1 = o_b_ua_1 - o_mac_h_2_1;
assign new_ui_1 = o_b_ui_1 - o_mac_h_4_1;
assign new_uf_1 = o_b_uf_1 - o_mac_h_6_1;
assign new_uo_1 = o_b_uo_1 - o_mac_h_8_1;

// LAYER 1 Update B
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_da1 (.clk(clk), .rst(rst_acc_1), .acc(acc_dgate1), .i(mux_upd_w1_1), .o(o_acc_da1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_di1 (.clk(clk), .rst(rst_acc_1), .acc(acc_dgate1), .i(mux_upd_w2_1), .o(o_acc_di1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_df1 (.clk(clk), .rst(rst_acc_1), .acc(acc_dgate1), .i(mux_upd_w3_1), .o(o_acc_df1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_do1 (.clk(clk), .rst(rst_acc_1), .acc(acc_dgate1), .i(mux_upd_w4_1), .o(o_acc_do1));

assign sh3_da1 = o_acc_da1[WIDTH-1] ? {3'b111,o_acc_da1[WIDTH-1:3]} : {3'b000,o_acc_da1[WIDTH-1:3]}; 
assign sh3_di1 = o_acc_di1[WIDTH-1] ? {3'b111,o_acc_di1[WIDTH-1:3]} : {3'b000,o_acc_di1[WIDTH-1:3]}; 
assign sh3_df1 = o_acc_df1[WIDTH-1] ? {3'b111,o_acc_df1[WIDTH-1:3]} : {3'b000,o_acc_df1[WIDTH-1:3]}; 
assign sh3_do1 = o_acc_do1[WIDTH-1] ? {3'b111,o_acc_do1[WIDTH-1:3]} : {3'b000,o_acc_do1[WIDTH-1:3]}; 

assign new_ba_1 = o_b_ba_1 - sh3_da1;
assign new_bi_1 = o_b_bi_1 - sh3_di1;
assign new_bf_1 = o_b_bf_1 - sh3_df1;
assign new_bo_1 = o_b_bo_1 - sh3_do1;



endmodule