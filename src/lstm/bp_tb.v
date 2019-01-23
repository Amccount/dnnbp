////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation Testbench module
// File Name        : bp_tb.v
// Version          : 2.0
// Description      : a testbench to test LSTM Backpropagation Module
//
////////////////////////////////////////////////////////////////////////////////

module bp_tb();


// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

parameter LAYR1_INPUT = 53;
parameter LAYR1_CELL = 53;
parameter LAYR2_CELL = 8;

// This holds d gates
parameter LAYR1_dA = "layer1_dA.list";
parameter LAYR1_dI = "layer1_dI.list";
parameter LAYR1_dF = "layer1_dF.list";
parameter LAYR1_dO = "layer1_dO.list";
parameter LAYR1_dOut = "layer1_dOut.list";

// This holds d gates
parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";

// common ports
reg clk, rst, rst_acc1, rst_acc2;

// input ports
reg signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
reg signed [WIDTH-1:0] i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t;

reg signed [WIDTH-1:0] i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo;
reg signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;
reg signed [WIDTH-1:0] i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo;
reg signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
reg signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;
reg signed [WIDTH-1:0] i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo;

// control ports
reg [1:0] sel_layr1_in1, sel_layr2_in1;
reg [1:0] sel_layr1_in2, sel_layr2_in2;
reg sel_layr1_in3, sel_layr2_in3;
reg [1:0] sel_layr1_in4, sel_layr2_in4;
reg [2:0] sel_layr1_in5, sel_layr2_in5;
reg [1:0] sel_layr1_x1_1, sel_layr2_x1_1;
reg sel_layr1_x1_2, sel_layr2_x1_2;
reg [1:0] sel_layr1_x2_2, sel_layr2_x2_2;
reg sel_layr1_as_1, sel_layr2_as_1;
reg [1:0] sel_layr1_as_2, sel_layr2_as_2;
reg sel_layr1_addsub, sel_layr2_addsub;
reg [1:0] sel_layr1_temp, sel_layr2_temp;

reg acc_da1, acc_di1, acc_df1, acc_do1;
reg acc_da2, acc_di2, acc_df2, acc_do2;
reg acc_mac1, acc_mac2;

reg load_d_state1, load_d_state2;

reg [1:0] sel_dgate1, sel_dgate2;
reg [2:0] sel_wghts1, sel_wghts2;

reg wr_da1, wr_di1, wr_df1, wr_do1;
reg [8:0] rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
reg [8:0] wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

reg wr_da2, wr_di2, wr_df2, wr_do2;
reg [5:0] rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
reg [5:0] wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

reg wr_dx2, wr_dout2, wr_dout1;
reg [8:0] rd_addr_dx2, wr_addr_dx2;
reg [3:0] rd_addr_dout2, wr_addr_dout2;
reg [6:0] rd_addr_dout1, wr_addr_dout1;

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
		.clk              (clk),
		.rst              (rst),
		.rst_acc1		  (rst_acc1),
		.rst_acc2		  (rst_acc2),
		.i_layr1_a        (i_layr1_a),
		.i_layr1_i        (i_layr1_i),
		.i_layr1_f        (i_layr1_f),
		.i_layr1_o        (i_layr1_o),
		.i_layr1_state    (i_layr1_state),
		.i_layr2_a        (i_layr2_a),
		.i_layr2_i        (i_layr2_i),
		.i_layr2_f        (i_layr2_f),
		.i_layr2_o        (i_layr2_o),
		.i_layr2_state    (i_layr2_state),
		.i_layr2_h        (i_layr2_h),
		.i_layr2_t        (i_layr2_t),
		.i_layr1_wa       (i_layr1_wa),
		.i_layr1_wi       (i_layr1_wi),
		.i_layr1_wf       (i_layr1_wf),
		.i_layr1_wo       (i_layr1_wo),
		.i_layr1_ua       (i_layr1_ua),
		.i_layr1_ui       (i_layr1_ui),
		.i_layr1_uf       (i_layr1_uf),
		.i_layr1_uo       (i_layr1_uo),
		.i_layr1_ba       (i_layr1_ba),
		.i_layr1_bi       (i_layr1_bi),
		.i_layr1_bf       (i_layr1_bf),
		.i_layr1_bo       (i_layr1_bo),
		.i_layr2_wa       (i_layr2_wa),
		.i_layr2_wi       (i_layr2_wi),
		.i_layr2_wf       (i_layr2_wf),
		.i_layr2_wo       (i_layr2_wo),
		.i_layr2_ua       (i_layr2_ua),
		.i_layr2_ui       (i_layr2_ui),
		.i_layr2_uf       (i_layr2_uf),
		.i_layr2_uo       (i_layr2_uo),
		.i_layr2_ba       (i_layr2_ba),
		.i_layr2_bi       (i_layr2_bi),
		.i_layr2_bf       (i_layr2_bf),
		.i_layr2_bo       (i_layr2_bo),
		.sel_layr1_in1    (sel_layr1_in1),
		.sel_layr1_in2    (sel_layr1_in2),
		.sel_layr1_in3    (sel_layr1_in3),
		.sel_layr1_in4    (sel_layr1_in4),
		.sel_layr1_in5    (sel_layr1_in5),
		.sel_layr2_in1    (sel_layr2_in1),
		.sel_layr2_in2    (sel_layr2_in2),
		.sel_layr2_in3    (sel_layr2_in3),
		.sel_layr2_in4    (sel_layr2_in4),
		.sel_layr2_in5    (sel_layr2_in5),
		.sel_layr1_x1_1   (sel_layr1_x1_1),
		.sel_layr1_x1_2   (sel_layr1_x1_2),
		.sel_layr1_x2_2   (sel_layr1_x2_2),
		.sel_layr1_as_1   (sel_layr1_as_1),
		.sel_layr1_as_2   (sel_layr1_as_2),
		.sel_layr2_x1_1   (sel_layr2_x1_1),
		.sel_layr2_x1_2   (sel_layr2_x1_2),
		.sel_layr2_x2_2   (sel_layr2_x2_2),
		.sel_layr2_as_1   (sel_layr2_as_1),
		.sel_layr2_as_2   (sel_layr2_as_2),
		.sel_layr1_addsub (sel_layr1_addsub),
		.sel_layr2_addsub (sel_layr2_addsub),
		.sel_layr1_temp   (sel_layr1_temp),
		.sel_layr2_temp   (sel_layr2_temp),
		.acc_da1          (acc_da1),
		.acc_di1          (acc_di1),
		.acc_df1          (acc_df1),
		.acc_do1          (acc_do1),
		.acc_da2          (acc_da2),
		.acc_di2          (acc_di2),
		.acc_df2          (acc_df2),
		.acc_do2          (acc_do2),
		.acc_mac1         (acc_mac1),
		.acc_mac2         (acc_mac2),
		.wr_da1           (wr_da1),
		.wr_di1           (wr_di1),
		.wr_df1           (wr_df1),
		.wr_do1           (wr_do1),
		.wr_da2           (wr_da2),
		.wr_di2           (wr_di2),
		.wr_df2           (wr_df2),
		.wr_do2           (wr_do2),
		.wr_dx2           (wr_dx2),
		.wr_dout2         (wr_dout2),
		.wr_dout1         (wr_dout1),
		.rd_addr_da1      (rd_addr_da1),
		.rd_addr_di1      (rd_addr_di1),
		.rd_addr_df1      (rd_addr_df1),
		.rd_addr_do1      (rd_addr_do1),
		.wr_addr_da1      (wr_addr_da1),
		.wr_addr_di1      (wr_addr_di1),
		.wr_addr_df1      (wr_addr_df1),
		.wr_addr_do1      (wr_addr_do1),
		.rd_addr_da2      (rd_addr_da2),
		.rd_addr_di2      (rd_addr_di2),
		.rd_addr_df2      (rd_addr_df2),
		.rd_addr_do2      (rd_addr_do2),
		.wr_addr_da2      (wr_addr_da2),
		.wr_addr_di2      (wr_addr_di2),
		.wr_addr_df2      (wr_addr_df2),
		.wr_addr_do2      (wr_addr_do2),
		.rd_addr_dx2      (rd_addr_dx2),
		.rd_addr_dout2    (rd_addr_dout2),
		.rd_addr_dout1    (rd_addr_dout1),
		.wr_addr_dx2      (wr_addr_dx2),
		.wr_addr_dout2    (wr_addr_dout2),
		.wr_addr_dout1    (wr_addr_dout1),
		.load_d_state1    (load_d_state1),
		.load_d_state2    (load_d_state2),
		.sel_dgate1       (sel_dgate1),
		.sel_dgate2       (sel_dgate2),
		.sel_wghts1       (sel_wghts1),
		.sel_wghts2       (sel_wghts2)
	);


initial
begin
	// CLOCK 0
	clk = 1;
	rst <= 1;
	rst_acc1 <= 1;
	rst_acc2 <= 1;
	#100;

	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h1;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h0;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00000000;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 1
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h0;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h0;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00000000;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 2
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h2;
	sel_layr2_in2 <= 2'h3;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h1;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h3;
	sel_layr2_addsub <= 1'h1;
	sel_layr2_temp   <= 2'h0;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00000000;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 3
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h2;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h4;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h0;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00000000;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 4
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h0;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h1;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h2;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 5
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h1;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h1;
	sel_layr2_as_1 <= 1'h1;
	sel_layr2_as_2 <= 2'h2;
	sel_layr2_addsub <= 1'h1;
	sel_layr2_temp   <= 2'h1;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	// CLOCK 6
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h1;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h2;
	sel_layr2_x1_1 <= 2'h2;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h1;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h0184816f;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b1;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b1;

	#100;
	// $display("dot <= %h \n", o_dgate);

	// CLOCK 7
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h1;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h3;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h1;
	sel_layr2_x2_2 <= 2'h2;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h00c924f2;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;
	
	// CLOCK 8
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h3;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h2;
	sel_layr2_in5 <= 3'h3;	
	sel_layr2_x1_1 <= 2'h2;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h1;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h00c924f2;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b1;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b1;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;
	// $display("dat <= %h \n", o_dgate);

	// CLOCK 9
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h0;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h1;
	sel_layr2_x2_2 <= 2'h0;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h00c924f2;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b1;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b1;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;
	// $display("dit <= %h \n", o_dgate);


	// CLOCK 10
	rst <= 0;
	rst_acc1 <= 0;
	rst_acc2 <= 0;
	sel_layr2_in1 <= 2'h0;
	sel_layr2_in2 <= 2'h0;
	sel_layr2_in3 <= 1'h0;
	sel_layr2_in4 <= 2'h0;
	sel_layr2_in5 <= 3'h0;
	sel_layr2_x1_1 <= 2'h0;
	sel_layr2_x1_2 <= 1'h0;
	sel_layr2_x2_2 <= 2'h1;
	sel_layr2_as_1 <= 1'h0;
	sel_layr2_as_2 <= 2'h0;
	sel_layr2_addsub <= 1'h0;
	sel_layr2_temp   <= 2'h2;
	i_layr2_a <= 32'h00d98c7e;
	i_layr2_i <= 32'h00fb2e9c;
	i_layr2_f <= 32'h00decbfb;
	i_layr2_o <= 32'h00d99503;
	i_layr2_h <= 32'h00c59fd3;
	i_layr2_t <= 32'h01400000;
	i_layr2_state <= 32'h00c924f2;
	// d_state <= 32'h00000000;
	// d_out   <= 32'h00000000;
	rd_addr_dout2 <= 32'h00000000;
	rd_addr_dx2 <= 32'h00000000;
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;

	#100;

	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b1;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b1;
	acc_do2 <= 1'b0;

	#100;
	// $display("dft = %h \n", o_dgate);

	////////////////// END DELTA ///////////////////////////
	
	// cuman supaya gak di masukin ke df lagi
	wr_da2 <= 1'b0;
	wr_di2 <= 1'b0;
	wr_df2 <= 1'b0;
	wr_do2 <= 1'b0;
	wr_addr_da2 <= 32'h00000000;
	wr_addr_di2 <= 32'h00000000;
	wr_addr_df2 <= 32'h00000000;
	wr_addr_do2 <= 32'h00000000;
	acc_da2 <= 1'b0;
	acc_di2 <= 1'b0;
	acc_df2 <= 1'b0;
	acc_do2 <= 1'b0;
	
	#100;



end

always 
begin
	#50;
	clk = !clk;
end


endmodule