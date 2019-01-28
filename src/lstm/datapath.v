module datapath(clk, rst, rst_2, acc_x_1, acc_h_1, acc_x_2, acc_h_2, wr_h1, wr_h2, wr_c1, wr_c2, wr_x2, 
	            addr_x1, rd_addr_x2, wr_addr_x2, wr_addr_act_1, 
	            wr_act_1, wr_addr_act_2, wr_act_2, wr_addr_w_1, 
	            wr_w_1, rd_addr_w_1, wr_addr_u_1, wr_u_1, rd_addr_u_1, 
	            wr_addr_b_1, wr_b_1, rd_addr_b_1, wr_addr_w_2,wr_w_2, 
	            rd_addr_w_2, wr_addr_b_2, wr_b_2, 
	            rd_addr_b_2, wr_addr_u_2, wr_u_2, rd_addr_u_2,
                rd_addr_h1, rd_addr_h2, rd_addr_c1, rd_addr_c2,
                wr_addr_h1, wr_addr_h2, wr_addr_c1, wr_addr_c2,
                rst_acc, rst_mac_bp, rst_cost,
				sel_a, sel_i, sel_f, sel_o, sel_h, sel_t,
				sel_state, sel_dstate, sel_dout,
				sel_in1, sel_in2, sel_in3, sel_in4, sel_in5,
				sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp,
				acc_mac,acc_da, acc_di, acc_df, acc_do, acc_cost,
				sel_dgate, sel_wght, sel_wghts1, sel_wghts2,
				wr_da1, wr_di1, wr_df1, wr_do1,
				wr_da2, wr_di2, wr_df2, wr_do2,
				rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1,
				rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2,
				wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1,
				wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2,
				wr_dx2, rd_addr_dx2, wr_addr_dx2,
				wr_dout2, rd_addr_dout2, wr_addr_dout2,
				wr_dout1, rd_addr_dout1, wr_addr_dout1,
				wr_dstate2, rd_addr_dstate2, wr_addr_dstate2,
				wr_dstate1, rd_addr_dstate1, wr_addr_dstate1,
				rd_layr2_wa, rd_layr2_wi, rd_layr2_wf, rd_layr2_wo,
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
parameter WIDTH = 32;
parameter FRAC = 24;
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

parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";

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

input [1:0] sel_in1;
input [1:0] sel_in2;
input sel_in3;
input [1:0] sel_in4;
input [2:0] sel_in5;
input [1:0] sel_x1_1;
input sel_x1_2;
input [1:0] sel_x2_2;
input sel_as_1;
input [1:0] sel_as_2;
input sel_addsub;
input [1:0] sel_temp;

input acc_da, acc_di, acc_df, acc_do, acc_cost;
input acc_mac;

input [1:0] sel_dgate;

input sel_wght;
input [1:0] sel_wghts1;
input [2:0] sel_wghts2;

input wr_da1, wr_di1, wr_df1, wr_do1;
input [11:0] /*[8:0]*/ rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
input [11:0] /*[8:0]*/ wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

input wr_da2, wr_di2, wr_df2, wr_do2;
input [11:0] /*[5:0]*/ rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
input [11:0] /*[5:0]*/ wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

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
wire signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
wire signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;
wire signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
wire signed [WIDTH-1:0] i_layr2_t, i_layr2_h, i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state;

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
		.TIMESTEP(),
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
		.addr_b (rd_layr1_state),
		.i_a    (i_mem_c1),
		.o_a    (prev_c1),
		.o_b    (i_layr1_state)
	);


// LAYER 1 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_x1 = data_x1[31] ? {3'b111,data_x1[31:3]} : {3'b000,data_x1[31:3]}; 
assign o_mux_x1 = update ? sh3_x1 : data_x1;

// LAYER 1 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_h1 = o_mem_h1_a[31] ? {3'b111,o_mem_h1_a[31:3]} : {3'b000,o_mem_h1_a[31:3]}; 
assign o_mux_h1 = update ? sh3_h1 : o_mem_h1_a;

// LAYER 1 WEIGHT MULTIPLEXER
assign o_mux_w_a_1 = update ? w_a_1 : d_a_1 ;
assign o_mux_w_i_1 = update ? w_i_1 : d_i_1 ;
assign o_mux_w_f_1 = update ? w_f_1 : d_f_1 ;
assign o_mux_w_o_1 = update ? w_o_1 : d_o_1 ;
assign o_mux_u_a_1 = update ? u_a_1 : d_a_1 ;
assign o_mux_u_i_1 = update ? u_i_1 : d_i_1 ;
assign o_mux_u_f_1 = update ? u_f_1 : d_f_1 ;
assign o_mux_u_o_1 = update ? u_o_1 : d_o_1 ;

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
		.o_mul_1      (dw_a_1), // wa
		.o_mul_2      (dw_i_1), // wi
		.o_mul_3      (dw_f_1), // wf
		.o_mul_4      (dw_o_1), // wo
		.o_mul_5      (du_a_1), // ua
		.o_mul_6      (du_i_1), // ui
		.o_mul_7      (du_f_1), // uf
		.o_mul_8      (du_o_1)  // uo
	);

// W & dW Subtractor
assign new_w_a_1 = w_a_1 - dw_a_1 ;
assign new_w_i_1 = w_i_1 - dw_i_1 ;
assign new_w_f_1 = w_f_1 - dw_f_1 ;
assign new_w_o_1 = w_o_1 - dw_o_1 ;
assign new_u_a_1 = u_a_1 - du_a_1 ;
assign new_u_i_1 = u_i_1 - du_i_1 ;
assign new_u_f_1 = u_f_1 - du_f_1 ;
assign new_u_o_1 = u_o_1 - du_o_1 ;

// dGates Shifter & B Subtractor
assign sh3_da_1 = o_mux_w_a_1[31] ? {3'b111,o_mux_w_a_1[31:3]} : {3'b000,o_mux_w_a_1[31:3]}; 
assign sh3_di_1 = o_mux_w_i_1[31] ? {3'b111,o_mux_w_i_1[31:3]} : {3'b000,o_mux_w_i_1[31:3]}; 
assign sh3_df_1 = o_mux_w_f_1[31] ? {3'b111,o_mux_w_f_1[31:3]} : {3'b000,o_mux_w_f_1[31:3]}; 
assign sh3_do_1 = o_mux_w_o_1[31] ? {3'b111,o_mux_w_o_1[31:3]} : {3'b000,o_mux_w_o_1[31:3]}; 

assign new_b_a_1 = b_a_1 - sh3_da_1;
assign new_b_i_1 = b_i_1 - sh3_di_1;
assign new_b_f_1 = b_f_1 - sh3_df_1;
assign new_b_o_1 = b_o_1 - sh3_do_1;

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
		.addr_b (rd_layr1_a),
		.i_a    (a1),
		.o_a    (o_mem_a1),
		.o_b    (i_layr1_a)
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
		.addr_b (rd_layr1_f),
		.i_a    (f1),
		.o_a    (o_mem_f1),
		.o_b    (i_layr1_f)
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
		.addr_b (rd_layr1_i),
		.i_a    (i1),
		.o_a    (o_mem_i1),
		.o_b    (i_layr1_i)
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
		.addr_b (rd_layr1_o),
		.i_a    (o1),
		.o_a    (o_mem_o1),
		.o_b    (i_layr1_o)
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
		.addr_a (rd_layr2_wa),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (i_layr2_wa),
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
		.addr_a (rd_layr2_wi),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (i_layr2_wi),
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
		.addr_a (rd_layr2_wf),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (i_layr2_wf),
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
		.addr_a (rd_layr2_wo),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (i_layr2_wo),
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
		.addr_a (rd_layr2_ua),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (i_layr2_ua),
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
		.addr_a (rd_layr2_ui),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (i_layr2_ui),
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
		.addr_a (rd_layr2_uf),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (i_layr2_uf),
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
		.addr_a (rd_layr2_uo),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (i_layr2_uo),
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
			.addr_b (rd_layr2_h),
			.i_a    (i_mem_h2),
			.o_a    (o_mem_h2_a),
			.o_b    (i_layr2_h)
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
			.addr_b (rd_layr2_state),
			.i_a    (i_mem_c2),
			.o_a    (prev_c2),
			.o_b    (i_layr2_state)
		);

// LAYER 2 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_x2 = data_x2[31] ? {3'b111,data_x2[31:3]} : {3'b000,data_x2[31:3]}; 
assign o_mux_x2 = update ? sh3_x2 : data_x2;

// LAYER 2 CELL INPUT MULTIPLEXER
// in: shifted x1 with learning rate of 0.125 & x1
assign sh3_h2 = o_mem_h2_a[31] ? {3'b111,o_mem_h2_a[31:3]} : {3'b000,o_mem_h2_a[31:3]}; 
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
assign sh3_da_2 = o_mux_w_a_2[31] ? {3'b111,o_mux_w_a_2[31:3]} : {3'b000,o_mux_w_a_2[31:3]}; 
assign sh3_di_2 = o_mux_w_i_2[31] ? {3'b111,o_mux_w_i_2[31:3]} : {3'b000,o_mux_w_i_2[31:3]}; 
assign sh3_df_2 = o_mux_w_f_2[31] ? {3'b111,o_mux_w_f_2[31:3]} : {3'b000,o_mux_w_f_2[31:3]}; 
assign sh3_do_2 = o_mux_w_o_2[31] ? {3'b111,o_mux_w_o_2[31:3]} : {3'b000,o_mux_w_o_2[31:3]}; 

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
		.addr_b (rd_layr2_a),
 		.i_a    (a2),
		.o_a    (o_mem_a2),
		.o_b    (i_layr2_a)
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
		.addr_b (rd_layr2_f),
		.i_a    (f2),
		.o_a    (o_mem_f2),
		.o_b    (i_layr2_f)
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
		.addr_b (rd_layr2_i),
		.i_a    (i2),
		.o_a    (o_mem_i2),
		.o_b    (i_layr2_i)
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
		.addr_b (rd_layr2_o),
		.i_a    (o2),
		.o_a    (o_mem_o2),
		.o_b    (i_layr2_o)
	);

/////////////////////////////////////////////////////////////////////////
//////////////////////////// BACKPROPAGATION ////////////////////////////
/////////////////////////////////////////////////////////////////////////

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
		.addr_b (rd_layr2_t),
		.i_a    (),
		.o_a    (),
		.o_b    (i_layr2_t)
	);


bp #(
		.WIDTH(WIDTH),
		.FRAC(FRAC),
		.LAYR1_INPUT(LAYR1_INPUT),
		.LAYR1_CELL(LAYR1_CELL),
		.LAYR2_CELL(LAYR2_CELL),
		.LAYR1_dA(LAYR1_dA),
		.LAYR1_dI(LAYR1_dI),
		.LAYR1_dF(LAYR1_dF),
		.LAYR1_dO(LAYR1_dO),
		.LAYR1_dOut(LAYR1_dOut),
		.LAYR2_dA(LAYR2_dA),
		.LAYR2_dI(LAYR2_dI),
		.LAYR2_dF(LAYR2_dF),
		.LAYR2_dO(LAYR2_dO),
		.LAYR2_dX(LAYR2_dX),
		.LAYR2_dOut(LAYR2_dOut)
	) inst_bp (
		.clk           (clk),
		.rst           (rst),
		.rst_acc       (rst_acc),
		.rst_mac       (rst_mac_bp),
		.rst_cost      (rst_cost),
		.i_layr1_a     (i_layr1_a),
		.i_layr1_i     (i_layr1_i),
		.i_layr1_f     (i_layr1_f),
		.i_layr1_o     (i_layr1_o),
		.i_layr1_state (i_layr1_state),
		.i_layr2_a     (i_layr2_a),
		.i_layr2_i     (i_layr2_i),
		.i_layr2_f     (i_layr2_f),
		.i_layr2_o     (i_layr2_o),
		.i_layr2_state (i_layr2_state),
		.i_layr2_h     (i_layr2_h),
		.i_layr2_t     (i_layr2_t),
		.i_layr1_ua    (i_layr1_ua),
		.i_layr1_ui    (i_layr1_ui),
		.i_layr1_uf    (i_layr1_uf),
		.i_layr1_uo    (i_layr1_uo),
		.i_layr2_wa    (i_layr2_wa),
		.i_layr2_wi    (i_layr2_wi),
		.i_layr2_wf    (i_layr2_wf),
		.i_layr2_wo    (i_layr2_wo),
		.i_layr2_ua    (i_layr2_ua),
		.i_layr2_ui    (i_layr2_ui),
		.i_layr2_uf    (i_layr2_uf),
		.i_layr2_uo    (i_layr2_uo),
		.sel_a         (sel_a),
		.sel_i         (sel_i),
		.sel_f         (sel_f),
		.sel_o         (sel_o),
		.sel_h         (sel_h),
		.sel_t         (sel_t),
		.sel_state     (sel_state),
		.sel_dstate    (sel_dstate),
		.sel_dout      (sel_dout),
		.sel_in1       (sel_in1),
		.sel_in2       (sel_in2),
		.sel_in3       (sel_in3),
		.sel_in4       (sel_in4),
		.sel_in5       (sel_in5),
		.sel_x1_1      (sel_x1_1),
		.sel_x1_2      (sel_x1_2),
		.sel_x2_2      (sel_x2_2),
		.sel_as_1      (sel_as_1),
		.sel_as_2      (sel_as_2),
		.sel_addsub    (sel_addsub),
		.sel_temp      (sel_temp),
		.acc_da        (acc_da),
		.acc_di        (acc_di),
		.acc_df        (acc_df),
		.acc_do        (acc_do),
		.acc_cost      (acc_cost),
		.acc_mac       (acc_mac),
		.sel_dgate     (sel_dgate),
		.sel_wght      (sel_wght),
		.sel_wghts1    (sel_wghts1),
		.sel_wghts2    (sel_wghts2),
		// .da1           (da1),
		// .di1           (di1),
		// .df1           (df1),
		// .do1           (do1),
		// .da2           (da2),
		// .di2           (di2),
		// .df2           (df2),
		// .do2           (do2),
		.wr_dx2        (wr_dx2),
		.wr_dout2      (wr_dout2),
		.wr_dout1      (wr_dout1),
		.wr_dstate2	   (wr_dstate2),
		.wr_dstate1	   (wr_dstate1),
		.rd_addr_dx2   (rd_addr_dx2),
		.rd_addr_dout2 (rd_addr_dout2),
		.rd_addr_dout1 (rd_addr_dout1),
		.wr_addr_dx2   (wr_addr_dx2),
		.wr_addr_dout2 (wr_addr_dout2),
		.wr_addr_dout1 (wr_addr_dout1),
		.rd_addr_dstate1 (rd_addr_dstate1),
		.rd_addr_dstate2 (rd_addr_dstate2),
		.wr_addr_dstate1 (wr_addr_dstate1),
		.wr_addr_dstate2 (wr_addr_dstate2),
		.o_dgate (dgate),
		.o_cost  (o_cost)
	);

//////////////////////////////////////////////
// LAYER 2 dA, dI, dF, dO Memory  ///////////
memory_cell #(
        // .ADDR(6),,
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dA)
    ) mem_da2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_da2),
        .addr_a (wr_addr_da2),
        .addr_b (rd_addr_da2),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_a_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dI)
    ) mem_di2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_di2),
        .addr_a (wr_addr_di2),
        .addr_b (rd_addr_di2),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_i_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dF)
    ) mem_df2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_df2),
        .addr_a (wr_addr_df2),
        .addr_b (rd_addr_df2),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_f_2)
    );

memory_cell #(
        // .ADDR(6),
        .WIDTH(WIDTH),
        .NUM(56),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dO)
    ) mem_do2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_do2),
        .addr_a (wr_addr_do2),
        .addr_b (rd_addr_do2),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_o_2)
    );

/////////////////////////////////////////////
// LAYER 1 dA, dI, dF, dO Memory  //////////
memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dA)
    ) mem_da1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_da1),
        .addr_a (wr_addr_da1),
        .addr_b (rd_addr_da1),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_a_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dI)
    ) mem_di1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_di1),
        .addr_a (wr_addr_di1),
        .addr_b (rd_addr_di1),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_i_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dF)
    ) mem_df1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_df1),
        .addr_a (wr_addr_df1),
        .addr_b (rd_addr_df1),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_f_1)
    );

memory_cell #(
        // .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dO)
    ) mem_do1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_do1),
        .addr_a (wr_addr_do1),
        .addr_b (rd_addr_do1),
        .i_a    (dgate),
        .o_a    (),
        .o_b    (d_o_1)
    );

endmodule
