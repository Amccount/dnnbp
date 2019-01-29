module datapath(clk, rst, rst_2, acc_x_1, acc_h_1, acc_x_2, acc_h_2, wr_h1, wr_h2, wr_c1, wr_c2, wr_x2, 
	            addr_x1, rd_addr_x2, wr_addr_x2, wr_addr_act_1, 
	            wr_act_1, wr_addr_act_2, wr_act_2, wr_addr_w_1, 
	            wr_w_1, rd_addr_w_1, wr_addr_u_1, wr_u_1, rd_addr_u_1, 
	            wr_addr_b_1, wr_b_1, rd_addr_b_1, wr_addr_w_2,wr_w_2, 
	            rd_addr_w_2, wr_addr_b_2, wr_b_2, 
	            rd_addr_b_2, wr_addr_u_2, wr_u_2, rd_addr_u_2,
                rd_addr_h1, rd_addr_h2, rd_addr_c1, rd_addr_c2,
                wr_addr_h1, wr_addr_h2, wr_addr_c1, wr_addr_c2,
                rd_addr_a1, rd_addr_f1, rd_addr_i1, rd_addr_o1,
                rst_acc, rst_mac_bp, rst_cost,
				sel_a, sel_i, sel_f, sel_o, sel_h, sel_t,
				sel_state, sel_dstate, sel_dout,
				
				sel_in1_1, sel_in2_1, sel_in3_1, sel_in4_1, sel_in5_1,
				sel_in1_2, sel_in2_2, sel_in3_2, sel_in4_2, sel_in5_2,
				sel_x1_1_1, sel_x1_2_1, sel_x2_2_1, sel_as_1_1, sel_as_2_1, sel_addsub_1, sel_temp_1,
				sel_x1_1_2, sel_x1_2_2, sel_x2_2_2, sel_as_1_2, sel_as_2_2, sel_addsub_2, sel_temp_2,
				
				acc_cost,
				wr_da_1, wr_di_1, wr_df_1, wr_do_1,
				wr_da_2, wr_di_2, wr_df2, wr_do_2,
				rd_addr_da_1, rd_addr_di_1, rd_addr_df_1, rd_addr_do_1,
				rd_addr_da_2, rd_addr_di_2, rd_addr_df_2, rd_addr_do_2,
				wr_addr_da_1, wr_addr_di_1, wr_addr_df_1, wr_addr_do_1,
				wr_addr_da_2, wr_addr_di_2, wr_addr_df_2, wr_addr_do_2,
				wr_dx2, rd_addr_dx2, wr_addr_dx2,
				wr_dout2, rd_addr_dout2, wr_addr_dout2,
				wr_dout1, rd_addr_dout1, wr_addr_dout1,
				wr_dstate2, rd_addr_dstate2, wr_addr_dstate2,
				wr_dstate1, rd_addr_dstate1, wr_addr_dstate1,
				
				rd_addr_wa_2, rd_addr_wi_2, rd_addr_wf_2, rd_addr_wo_2,
				rd_layr2_ua, rd_layr2_ui, rd_layr2_uf, rd_layr2_uo,
				rd_layr1_ua, rd_layr1_ui, rd_layr1_uf, rd_layr1_uo,
				rd_layr1_a, rd_layr1_i, rd_layr1_f, rd_layr1_o, rd_layr1_state,
				rd_layr2_a, rd_layr2_i, rd_layr2_f, rd_layr2_o, rd_layr2_state,
				rd_layr2_t, rd_layr2_h,
				update,
				o_cost,
				dgate, h2
				);

// parameters
parameter WIDTH = 24;
parameter FRAC = 20;
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

parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";
parameter LAYR2_dState = "layer2_dState.list";

// common ports
input clk, rst, rst_2;

input acc_x_1, acc_h_1, acc_x_2, acc_h_2;
// control ports
input [11:0] addr_x1;
input [11:0] rd_addr_x2, wr_addr_x2;

input wr_h1;
input [11:0] rd_addr_h1;
input [11:0] wr_addr_h1;
input wr_c1;
input [11:0] rd_addr_c1;
input [11:0] wr_addr_c1;

input [11:0] wr_addr_act_1;
input wr_act_1;

input [11:0] wr_addr_act_2;
input wr_act_2;

input wr_w_1;
input [11:0] wr_addr_w_1;
input [11:0] rd_addr_w_1;

input wr_b_1;
input [11:0] wr_addr_b_1;
input [11:0] rd_addr_b_1;

input wr_u_1;
input [11:0] wr_addr_u_1;
input [11:0] rd_addr_u_1;

input wr_w_2;
input [11:0] wr_addr_w_2;
input [11:0] rd_addr_w_2;

input wr_b_2;
input [11:0] wr_addr_b_2;
input [11:0] rd_addr_b_2;

input wr_u_2;
input [11:0] wr_addr_u_2;
input [11:0] rd_addr_u_2;

input wr_x2;
input wr_h2;
input [11:0] rd_addr_h2;
input [11:0] wr_addr_h2;

input wr_c2;
input [11:0] rd_addr_c2;
input [11:0] wr_addr_c2;

input rst_acc, rst_mac_bp, rst_cost;
input sel_a, sel_i, sel_f, sel_o, sel_h, sel_t;
input sel_state, sel_dstate, sel_dout;

input [1:0] sel_in1_1, sel_in1_2;
input [1:0] sel_in2_1, sel_in2_2;
input sel_in3_1, sel_in3_2;
input [1:0] sel_in4_1, sel_in4_2;
input [2:0] sel_in5_1, sel_in5_2;
input [1:0] sel_x1_1_1, sel_x1_1_2;
input sel_x1_2_1, sel_x1_2_2;
input [1:0] sel_x2_2_1, sel_x2_2_2;
input sel_as_1_1, sel_as_1_2;
input [1:0] sel_as_2_1, sel_as_2_2;
input sel_addsub_1, sel_addsub_2;
input [1:0] sel_temp_1, sel_temp_2;

input acc_cost;

input wr_da_1, wr_di_1, wr_df_1, wr_do_1;
input [11:0] /*[8:0]*/ rd_addr_da_1, rd_addr_di_1, rd_addr_df_1, rd_addr_do_1;
input [11:0] /*[8:0]*/ wr_addr_da_1, wr_addr_di_1, wr_addr_df_1, wr_addr_do_1;

input wr_da_2, wr_di_2, wr_df2, wr_do_2;
input [11:0] /*[5:0]*/ rd_addr_da_2, rd_addr_di_2, rd_addr_df_2, rd_addr_do_2;
input [11:0] /*[5:0]*/ wr_addr_da_2, wr_addr_di_2, wr_addr_df_2, wr_addr_do_2;

input wr_dx2, wr_dout2, wr_dout1;
input [11:0] /*[8:0]*/ rd_addr_dx2, wr_addr_dx2;
input [11:0] /*[3:0]*/ rd_addr_dout2, wr_addr_dout2;
input [11:0] /*[6:0]*/ rd_addr_dout1, wr_addr_dout1;

input wr_dstate1, wr_dstate2;
input [11:0] /*[3:0]*/ rd_addr_dstate2, wr_addr_dstate2;
input [11:0] /*[6:0]*/ rd_addr_dstate1, wr_addr_dstate1;

input [11:0] /*[8:0]*/ rd_layr2_wa, rd_layr2_wi, rd_layr2_wf, rd_layr2_wo;
input [11:0] /*[5:0]*/ rd_layr2_ua, rd_layr2_ui, rd_layr2_uf, rd_layr2_uo;

input [11:0] /*[5:0]*/ rd_layr1_ua, rd_layr1_ui, rd_layr1_uf, rd_layr1_uo;

input [11:0] /*[8:0]*/ rd_layr1_a, rd_layr1_i, rd_layr1_f, rd_layr1_o, rd_layr1_state;
input [11:0] /*[5:0]*/ rd_layr2_t, rd_layr2_h, rd_layr2_a, rd_layr2_i, rd_layr2_f, rd_layr2_o, rd_layr2_state;

input update;

output [WIDTH-1:0] o_cost;
output [WIDTH-1:0] dgate, h2; 

// registers
reg signed [WIDTH-1:0] reg_c1, reg_c2;
reg signed [WIDTH-1:0] reg_h1, reg_h2;


// wires
wire signed [WIDTH-1:0] data_x1;

wire signed [WIDTH-1:0] prev_c1, prev_c2;
wire signed [WIDTH-1:0] i_mem_h1, i_mem_x2, i_mem_h2;
wire signed [WIDTH-1:0] i_mem_c1, i_mem_c2;
wire signed [WIDTH-1:0] o_mem_c1, o_mem_c2;
wire signed [WIDTH-1:0] o_mem_h1_a, o_mem_h1_b, o_mem_x2;
wire signed [WIDTH-1:0] o_mem_h2_a, o_mem_h2_b;
wire signed [WIDTH-1:0] o_mem_a1, o_mem_a2;
wire signed [WIDTH-1:0] o_mem_i1, o_mem_i2;
wire signed [WIDTH-1:0] o_mem_f1, o_mem_f2;
wire signed [WIDTH-1:0] o_mem_o1, o_mem_o2;

wire signed [WIDTH-1:0] data_x2;

wire signed [WIDTH-1:0] w_a_1;
wire signed [WIDTH-1:0] w_i_1;
wire signed [WIDTH-1:0] w_f_1;
wire signed [WIDTH-1:0] w_o_1;
wire signed [WIDTH-1:0] u_a_1;
wire signed [WIDTH-1:0] u_i_1;
wire signed [WIDTH-1:0] u_f_1;
wire signed [WIDTH-1:0] u_o_1;
wire signed [WIDTH-1:0] b_a_1;
wire signed [WIDTH-1:0] b_i_1;
wire signed [WIDTH-1:0] b_f_1;
wire signed [WIDTH-1:0] b_o_1;
wire signed [WIDTH-1:0] w_a_2;
wire signed [WIDTH-1:0] w_i_2;
wire signed [WIDTH-1:0] w_f_2;
wire signed [WIDTH-1:0] w_o_2;
wire signed [WIDTH-1:0] u_a_2;
wire signed [WIDTH-1:0] u_i_2;
wire signed [WIDTH-1:0] u_f_2;
wire signed [WIDTH-1:0] u_o_2;
wire signed [WIDTH-1:0] b_a_2;
wire signed [WIDTH-1:0] b_i_2;
wire signed [WIDTH-1:0] b_f_2;
wire signed [WIDTH-1:0] b_o_2;
wire signed [WIDTH-1:0] c1, c2;
wire signed [WIDTH-1:0] h1, h2;
wire signed [WIDTH-1:0] a1, a2;
wire signed [WIDTH-1:0] i1, i2;
wire signed [WIDTH-1:0] f1, f2;
wire signed [WIDTH-1:0] o1, o2;

wire signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;
wire signed [WIDTH-1:0] w_2a, w_2i, w_2f, w_2o;
wire signed [WIDTH-1:0] u_2a, u_2i, u_2f, u_2o;
wire signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
wire signed [WIDTH-1:0] t_2, h_2, a_2, i_2, f_2, o_2, s_2tate;

wire signed [WIDTH-1:0] dgate;
wire signed [WIDTH-1:0] d_a_1, d_i_1, d_f_1, d_o_1;
wire signed [WIDTH-1:0] d_a_2, d_i_2, d_f_2, d_o_2;

wire signed [WIDTH-1:0] sh3_x1, sh3_h1;
wire signed [WIDTH-1:0] o_mux_x1, o_mux_h1;
wire signed [WIDTH-1:0] sh3_da_1, sh3_di_1, sh3_df_1, sh3_do_1;
wire signed [WIDTH-1:0] o_mux_w_a_1, o_mux_w_i_1, o_mux_w_f_1, o_mux_w_o_1;
wire signed [WIDTH-1:0] o_mux_u_a_1, o_mux_u_i_1, o_mux_u_f_1, o_mux_u_o_1;
wire signed [WIDTH-1:0] o_mux_b_a_1, o_mux_b_i_1, o_mux_b_f_1, o_mux_b_o_1;
wire signed [WIDTH-1:0] new_w_a_1, new_w_i_1, new_w_f_1, new_w_o_1;
wire signed [WIDTH-1:0] new_u_a_1, new_u_i_1, new_u_f_1, new_u_o_1;
wire signed [WIDTH-1:0] new_b_a_1, new_b_i_1, new_b_f_1, new_b_o_1;
wire signed [WIDTH-1:0] dw_a_1, dw_i_1, dw_f_1, dw_o_1;
wire signed [WIDTH-1:0] du_a_1, du_i_1, du_f_1, du_o_1;

wire signed [WIDTH-1:0] sh3_x2, sh3_h2;
wire signed [WIDTH-1:0] o_mux_x2, o_mux_h2;
wire signed [WIDTH-1:0] sh3_da_2, sh3_di_2, sh3_df_2, sh3_do_2;
wire signed [WIDTH-1:0] o_mux_w_a_2, o_mux_w_i_2, o_mux_w_f_2, o_mux_w_o_2;
wire signed [WIDTH-1:0] o_mux_u_a_2, o_mux_u_i_2, o_mux_u_f_2, o_mux_u_o_2;
wire signed [WIDTH-1:0] o_mux_b_a_2, o_mux_b_i_2, o_mux_b_f_2, o_mux_b_o_2;
wire signed [WIDTH-1:0] new_w_a_2, new_w_i_2, new_w_f_2, new_w_o_2;
wire signed [WIDTH-1:0] new_u_a_2, new_u_i_2, new_u_f_2, new_u_o_2;
wire signed [WIDTH-1:0] new_b_a_2, new_b_i_2, new_b_f_2, new_b_o_2;
wire signed [WIDTH-1:0] dw_a_2, dw_i_2, dw_f_2, dw_o_2;
wire signed [WIDTH-1:0] du_a_2, du_i_2, du_f_2, du_o_2;


// Input Memory
// out: data (53*WIDTH)
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_INPUT),
			.TIMESTEP(TIMESTEP),
			.FILENAME(LAYR1_X)
		) mem_x1(
			.clk    (clk),
			.rst    (rst),
			.wr_a   (),
			.addr_a (),
			.addr_b (addr_x1),
			.i_a    (),
			.o_a    (),
			.o_b    (data_x1)
);

// LAYER 1 Output Memory
// in: i (WIDTH)
// out: o (53*WIDTH)
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME(LAYR1_H)
		) inst_memory_h1 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_h1),
			.addr_a (wr_addr_h1),
			.addr_b (rd_addr_h1),
			.i_a    (i_mem_h1),
			.o_a    (o_mem_h1_a),
			.o_b    (o_mem_h1_b)
);

//LAYER 1 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_a.list")
	) inst_memory_cell_w_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (new_w_a_1),
		.o_a    (),
		.o_b    (w_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_i.list")
	) inst_memory_cell_w_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (new_w_i_1),
		.o_a    (),
		.o_b    (w_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_f.list")
	) inst_memory_cell_w_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (new_w_f_1),
		.o_a    (),
		.o_b    (w_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_o.list")
	) inst_memory_cell_w_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (new_w_o_1),
		.o_a    (),
		.o_b    (w_o_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_a.list")
	) inst_memory_cell_u_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_layr1_ua),
		.addr_b (rd_addr_u_1),
		.i_a    (new_u_a_1),
		.o_a    (i_layr1_ua),
		.o_b    (u_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_i.list")
	) inst_memory_cell_u_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_layr1_ui),
		.addr_b (rd_addr_u_1),
		.i_a    (new_u_i_1),
		.o_a    (i_layr1_ui),
		.o_b    (u_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_f.list")
	) inst_memory_cell_u_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_layr1_uf),
		.addr_b (rd_addr_u_1),
		.i_a    (new_u_f_1),
		.o_a    (i_layr1_uf),
		.o_b    (u_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_o.list")
	) inst_memory_cell_u_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_layr1_uo),
		.addr_b (rd_addr_u_1),
		.i_a    (new_u_o_1),
		.o_a    (i_layr1_uo),
		.o_b    (u_o_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_a.list")
	) inst_memory_cell_b_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (new_b_a_1),
		.o_a    (),
		.o_b    (b_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_i.list")
	) inst_memory_cell_b_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (new_b_i_1),
		.o_a    (),
		.o_b    (b_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_f.list")
	) inst_memory_cell_b_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (new_b_f_1),
		.o_a    (),
		.o_b    (b_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_o.list")
	) inst_memory_cell_b_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (new_b_o_1),
		.o_a    (),
		.o_b    (b_o_1)
	);

// LAYER 1 State Memory
// in: i (WIDTH)
// out: o (WIDTH)
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP+1),
		.FILENAME("layer1_c.list")
	) inst_mem_c (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_c1),
		.addr_a (wr_addr_c1),
		.addr_b (rd_addr_c1),
		.i_a    (i_mem_c1),
		.o_a    (prev_c1),
		.o_b    (c1)
	);


// LAYER 1 CELL INPUT MULTIPLEXER

// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_x1 = data_x1[31] ? {3'b111,data_x1[31:3]} : {3'b000,data_x1[31:3]}; 
assign o_mux_x1 = update ?  sh3_x1 : data_x1;


// LAYER 1 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_h1 = o_mem_h1_a[23] ? {3'b111,o_mem_h1_a[23:3]} : {3'b000,o_mem_h1_a[23:3]}; 
assign o_mux_h1 = update ? sh3_h1 : o_mem_h1_a;

// LAYER 1 WEIGHT MULTIPLEXER
assign o_mux_w_a_1 = update ? d_a_1 : w_a_1  ;
assign o_mux_w_i_1 = update ? d_i_1 : w_i_1  ;
assign o_mux_w_f_1 = update ? d_f_1 : w_f_1  ;
assign o_mux_w_o_1 = update ? d_o_1 : w_o_1  ;
assign o_mux_u_a_1 = update ? d_a_1 : u_a_1  ;
assign o_mux_u_i_1 = update ? d_i_1 : u_i_1  ;
assign o_mux_u_f_1 = update ? d_f_1 : u_f_1  ;
assign o_mux_u_o_1 = update ? d_o_1 : u_o_1  ;

// LAYER 1 LSTM CELL
// in: conc_x (106*WIDTH), prev_c (WIDTH) 
// out: o_a, o_i, o_f, o_o, o_c, o_h (WIDTH)
lstm_cell #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_cell (
		.clk          (clk),
		.rst          (rst),
		.acc_x        (acc_x_1),
		.acc_h        (acc_h_1),
		.i_x          (o_mux_x1),
		.i_h          (o_mux_h1),
		.i_prev_state (prev_c1),
		.i_w_a        (o_mux_w_a_1),
		.i_w_i        (o_mux_w_i_1),
		.i_w_f        (o_mux_w_f_1),
		.i_w_o        (o_mux_w_o_1),
		.i_u_a        (o_mux_u_a_1),
		.i_u_i        (o_mux_u_i_1),
		.i_u_f        (o_mux_u_f_1),
		.i_u_o        (o_mux_u_o_1),
		.i_b_a        (b_a_1),
		.i_b_i        (b_i_1),
		.i_b_f        (b_f_1),
		.i_b_o        (b_o_1),
		.o_a          (a1),
		.o_i          (i1),
		.o_f          (f1),
		.o_o          (o1),
		.o_c          (c1),
		.o_h          (h1),
		.o_mul_1      (/*dw_a_1*/), // wa
		.o_mul_2      (/*dw_i_1*/), // wi
		.o_mul_3      (/*dw_f_1*/), // wf
		.o_mul_4      (/*dw_o_1*/), // wo
		.o_mul_5      (/*du_a_1*/), // ua
		.o_mul_6      (/*du_i_1*/), // ui
		.o_mul_7      (/*du_f_1*/), // uf
		.o_mul_8      (/*du_o_1*/)  // uo
	);

// // W & dW Subtractor
// assign new_w_a_1 = w_a_1 - dw_a_1 ;
// assign new_w_i_1 = w_i_1 - dw_i_1 ;
// assign new_w_f_1 = w_f_1 - dw_f_1 ;
// assign new_w_o_1 = w_o_1 - dw_o_1 ;
// assign new_u_a_1 = u_a_1 - du_a_1 ;
// assign new_u_i_1 = u_i_1 - du_i_1 ;
// assign new_u_f_1 = u_f_1 - du_f_1 ;
// assign new_u_o_1 = u_o_1 - du_o_1 ;

// // dGates Shifter & B Subtractor
// assign sh3_da_1 = o_mux_w_a_1[23] ? {3'b111,o_mux_w_a_1[23:3]} : {3'b000,o_mux_w_a_1[23:3]}; 
// assign sh3_di_1 = o_mux_w_i_1[23] ? {3'b111,o_mux_w_i_1[23:3]} : {3'b000,o_mux_w_i_1[23:3]}; 
// assign sh3_df_1 = o_mux_w_f_1[23] ? {3'b111,o_mux_w_f_1[23:3]} : {3'b000,o_mux_w_f_1[23:3]}; 
// assign sh3_do_1 = o_mux_w_o_1[23] ? {3'b111,o_mux_w_o_1[23:3]} : {3'b000,o_mux_w_o_1[23:3]}; 

// assign new_b_a_1 = b_a_1 - sh3_da_1;
// assign new_b_i_1 = b_i_1 - sh3_di_1;
// assign new_b_f_1 = b_f_1 - sh3_df_1;
// assign new_b_o_1 = b_o_1 - sh3_do_1;

// Write a1 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_a1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (rd_addr_a1),
		.i_a    (a1),
		.o_a    (o_mem_a1),
		.o_b    (a_1)
	);

// Write f1 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_f1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (rd_addr_f1),
		.i_a    (f1),
		.o_a    (o_mem_f1),
		.o_b    (f_1)
	);

// Write i1 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_i1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (rd_addr_i1),
		.i_a    (i1),
		.o_a    (o_mem_i1),
		.o_b    (i_1)
	);

// Write o1 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_o1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (rd_addr_o1),
		.i_a    (o1),
		.o_a    (o_mem_o1),
		.o_b    (o_1)
	);

// LAYER 1 Output Pipeline Register
// in: clk, h (WIDTH)
// out: h (WIDTH)

assign i_mem_h1 = h1; // Loop to write LAYER 1 Output Memory
assign i_mem_c1 = c1; // Loop to write LAYER 1 State Memory


/////////////////////////////////////////////////////////////////////////
//////////////////////////////// LAYER 2 ////////////////////////////////
/////////////////////////////////////////////////////////////////////////

// Write LAYER 2 Input Memory
assign data_x2 = o_mem_h1_a; 

//LAYER 2 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_a.list")
	) inst_memory_cell_w_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_wa_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (w_a_2_1),
		.o_b    (w_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_i.list")
	) inst_memory_cell_w_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_wa_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (w_i_2_1),
		.o_b    (w_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_f.list")
	) inst_memory_cell_w_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_wa_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (w_f_2_1),
		.o_b    (w_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_o.list")
	) inst_memory_cell_w_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_wa_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (w_o_2_1),
		.o_b    (w_o_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_a.list")
	) inst_memory_cell_u_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_ua_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (u_a_2_1),
		.o_b    (u_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_i.list")
	) inst_memory_cell_u_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_ui_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (u_i_2_1),
		.o_b    (u_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_f.list")
	) inst_memory_cell_u_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_uf_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (u_f_2_1),
		.o_b    (u_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_o.list")
	) inst_memory_cell_u_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (rd_addr_uo_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (u_o_2_1),
		.o_b    (u_o_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_a.list")
	) inst_memory_cell_b_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_i.list")
	) inst_memory_cell_b_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_f.list")
	) inst_memory_cell_b_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_o.list")
	) inst_memory_cell_b_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_o_2)
	);

// LAYER 2 Output Memory
// in: clk, rst, wr, rd_addr, wr_addr, i (WIDTH)
// out: o (8*WIDTH)
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR2_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME("layer2_h.list")
		) inst_memory_h2 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_h2),
			.addr_a (wr_addr_h2),
			.addr_b (rd_addr_h2),
			.i_a    (i_mem_h2),
			.o_a    (o_mem_h2_a),
			.o_b    (h_2)
);

// LAYER 2 State Memory
// in: i (WIDTH)
// out: o (WIDTH)
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR2_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME("layer2_c.list")
		) inst_mem_c2 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_c2),
			.addr_a (wr_addr_c2),
			.addr_b (rd_addr_state2),
			.i_a    (i_mem_c2),
			.o_a    (prev_c2),
			.o_b    (state2)
		);

// LAYER 2 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_x2 = data_x2[23] ? {3'b111,data_x2[23:3]} : {3'b000,data_x2[23:3]}; 
assign o_mux_x2 = update ? sh3_x2 : data_x2;

// LAYER 2 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_h2 = o_mem_h2_a[23] ? {3'b111,o_mem_h2_a[23:3]} : {3'b000,o_mem_h2_a[23:3]}; 
assign o_mux_h2 = update ? sh3_h2 : o_mem_h2_a;

// LAYER 2 WEIGHT MULTIPLEXER
assign o_mux_w_a_2 = update ? w_a_2 : d_a_2 ;
assign o_mux_w_i_2 = update ? w_i_2 : d_i_2 ;
assign o_mux_w_f_2 = update ? w_f_2 : d_f_2 ;
assign o_mux_w_o_2 = update ? w_o_2 : d_o_2 ;
assign o_mux_u_a_2 = update ? u_a_2 : d_a_2 ;
assign o_mux_u_i_2 = update ? u_i_2 : d_i_2 ;
assign o_mux_u_f_2 = update ? u_f_2 : d_f_2 ;
assign o_mux_u_o_2 = update ? u_o_2 : d_o_2 ;


// LAYER 2 LSTM CELL
lstm_cell #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_cell_2 (
		.clk          (clk),
		.rst          (rst_2),
		.acc_x        (acc_x_2),
		.acc_h        (acc_h_2),
		.i_x          (o_mux_x2),
		.i_h          (o_mux_h2),
		.i_prev_state (prev_c2),
		.i_w_a        (o_mux_w_a_2),
		.i_w_i        (o_mux_w_i_2),
		.i_w_f        (o_mux_w_f_2),
		.i_w_o        (o_mux_w_o_2),
		.i_u_a        (o_mux_u_a_2),
		.i_u_i        (o_mux_u_i_2),
		.i_u_f        (o_mux_u_f_2),
		.i_u_o        (o_mux_u_o_2),
		.i_b_a        (b_a_2),
		.i_b_i        (b_i_2),
		.i_b_f        (b_f_2),
		.i_b_o        (b_o_2),
		.o_a          (a2),
		.o_i          (i2),
		.o_f          (f2),
		.o_o          (o2),
		.o_c          (c2),
		.o_h          (h2),
		.o_mul_1      (dw_a_2),
		.o_mul_2      (dw_i_2),
		.o_mul_3      (dw_f_2),
		.o_mul_4      (dw_o_2),
		.o_mul_5      (du_a_2),
		.o_mul_6      (du_i_2),
		.o_mul_7      (du_f_2),
		.o_mul_8      (du_o_2)
	);

assign i_mem_h2 = h2; // Loop to write LAYER 2 Output Memory
assign i_mem_c2 = c2; // Loop to write LAYER 2 State Memory

// W & dW Subtractor
assign new_w_a_2 = w_a_2 - dw_a_2 ;
assign new_w_i_2 = w_i_2 - dw_i_2 ;
assign new_w_f_2 = w_f_2 - dw_f_2 ;
assign new_w_o_2 = w_o_2 - dw_o_2 ;
assign new_u_a_2 = u_a_2 - du_a_2 ;
assign new_u_i_2 = u_i_2 - du_i_2 ;
assign new_u_f_2 = u_f_2 - du_f_2 ;
assign new_u_o_2 = u_o_2 - du_o_2 ;

// dGates Shifter & B Subtractor
assign sh3_da_2 = o_mux_w_a_2[23] ? {3'b111,o_mux_w_a_2[23:3]} : {3'b000,o_mux_w_a_2[23:3]}; 
assign sh3_di_2 = o_mux_w_i_2[23] ? {3'b111,o_mux_w_i_2[23:3]} : {3'b000,o_mux_w_i_2[23:3]}; 
assign sh3_df_2 = o_mux_w_f_2[23] ? {3'b111,o_mux_w_f_2[23:3]} : {3'b000,o_mux_w_f_2[23:3]}; 
assign sh3_do_2 = o_mux_w_o_2[23] ? {3'b111,o_mux_w_o_2[23:3]} : {3'b000,o_mux_w_o_2[23:3]}; 

assign new_b_a_2 = b_a_2 - sh3_da_2;
assign new_b_i_2 = b_i_2 - sh3_di_2;
assign new_b_f_2 = b_f_2 - sh3_df_2;
assign new_b_o_2 = b_o_2 - sh3_do_2;

// Write a2 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_a1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (rd_addr_a2),
 		.i_a    (a2),
		.o_a    (o_mem_a2),
		.o_b    (a_2)
	);

// Write f2 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_f1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (rd_addr_f),
		.i_a    (f2),
		.o_a    (o_mem_f2),
		.o_b    (f_2)
	);

// Write i2 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_i1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (rd_addr_i2),
		.i_a    (i2),
		.o_a    (o_mem_i2),
		.o_b    (i_2)
	);

// Write o2 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_o1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (rd_addr_o),
		.i_a    (o2),
		.o_a    (o_mem_o2),
		.o_b    (o_2)
	);

// label memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME("layer2_t.list")
	) mem_t2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (),
		.addr_b (rd_addr_t),
		.i_a    (),
		.o_a    (),
		.o_b    (t_2)
	);

/////////////////////////////////////////////////////////////////////////
//////////////////////////// BACKPROPAGATION ////////////////////////////
/////////////////////////////////////////////////////////////////////////

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
		.at         (at_2),
		.it         (it_2),
		.ft         (ft_2),
		.ot         (ot_2),
		.h          (h_2),
		.t          (t_2),
		.state      (state_2),
		.d_state    (reg_d_state_2),
		.d_out      (d_out_2),
		.o_dgate    (o_dgate_2),
		.o_d_state  (o_d_state_2)
	);

// ACCUMULATOR for Cost function
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_cost (.clk(clk), .rst(rst_cost), .acc(acc_cost), .i(o_dgate_2), .o(o_acc_cost));
assign o_cost = o_acc_cost >> 1;

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
		.at         (at_1),
		.it         (it_1),
		.ft         (ft_1),
		.ot         (ot_1),
		.h          (h_1),
		.t          (t_1),
		.state      (state_1),
		.d_state    (d_state_1),
		.d_out      (d_out_1),
		.o_dgate    (o_dgate_1),
		.o_d_state  (o_d_state_1)
	);

//////////////////////////////////////////////
// LAYER 2 dA, dI, dF, dO Memory  ///////////
memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dA)
    ) mem_da_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_da_2),
        .addr_a (wr_addr_da_2),
        .addr_b (rd_addr_da_2),
        .i_a    (o_dgate_2),
        .o_a    (),
        .o_b    (d_a_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dI)
    ) mem_di_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_di_2),
        .addr_a (wr_addr_di_2),
        .addr_b (rd_addr_di_2),
        .i_a    (o_dgate_2),
        .o_a    (),
        .o_b    (d_i_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dF)
    ) mem_df_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_df_2),
        .addr_a (wr_addr_df_2),
        .addr_b (rd_addr_df_2),
        .i_a    (o_dgate_2),
        .o_a    (),
        .o_b    (d_f_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dO)
    ) mem_do_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_do_2),
        .addr_a (wr_addr_do_2),
        .addr_b (rd_addr_do_2),
        .i_a    (o_dgate_2),
        .o_a    (),
        .o_b    (d_o_2)
    );

//////////////////////////////////////////////
// LAYER 2 dState, dX, dOut Memory  /////////
memory_cell #(
        // .ADDR(4),
        .WIDTH(WIDTH),
        .NUM(16),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dState)
    ) mem_dstate_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dstate_2),
        .addr_a (wr_addr_dstate_2),
        .addr_b (rd_addr_dstate_2),
        .i_a    (o_d_state_2),
        .o_a    (),
        .o_b    (reg_d_state_2)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dX)
    ) mem_dx_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dx_2),
        .addr_a (wr_addr_dx_2),
        .addr_b (rd_addr_dx_2),
        .i_a    (i_dx_2),
        .o_a    (),
        .o_b    (dx2)
    );

memory_cell #(
        // .ADDR(4),
        .WIDTH(WIDTH),
        .NUM(LAYR2_CELL),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dOut)
    ) mem_dout_2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dout_2),
        .addr_a (wr_addr_dout_2),
        .addr_b (rd_addr_dout_2),
        .i_a    (i_dout_2),
        .o_a    (),
        .o_b    (dout2)
    );

/////////////////////////////////////////////
// LAYER 1 dA, dI, dF, dO Memory  //////////
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dA)
    ) mem_da_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_da_1),
        .addr_a (wr_addr_da_1),
        .addr_b (rd_addr_da_1),
        .i_a    (dgate_1),
        .o_a    (),
        .o_b    (d_a_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dI)
    ) mem_di_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_di_1),
        .addr_a (wr_addr_di_1),
        .addr_b (rd_addr_di_1),
        .i_a    (dgate_1),
        .o_a    (),
        .o_b    (d_i_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dF)
    ) mem_df_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_df_1),
        .addr_a (wr_addr_df_1),
        .addr_b (rd_addr_df_1),
        .i_a    (dgate_1),
        .o_a    (),
        .o_b    (d_f_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dO)
    ) mem_do_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_do_1),
        .addr_a (wr_addr_do_1),
        .addr_b (rd_addr_do_1),
        .i_a    (dgate_1),
        .o_a    (),
        .o_b    (d_o_1)
    );


////////////////////////////////////////////
// LAYER 1 dState, dOut Memory ////////////

memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(106),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dState)
    ) mem_dstate_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dstate_1),
        .addr_a (wr_addr_dstate_1),
        .addr_b (rd_addr_dstate_1),
        .i_a    (o_d_state_1),
        .o_a    (),
        .o_b    (reg_d_state_1)
    );

memory_cell #(
        // .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(LAYR1_CELL),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dOut)
    ) mem_dout_1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dout_1),
        .addr_a (wr_addr_dout_1),
        .addr_b (rd_addr_dout_1),
        .i_a    (i_dout_1),
        .o_a    (),
        .o_b    (reg_d_dout_1)
    );

endmodule
