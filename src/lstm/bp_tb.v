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
parameter TIMESTEP = 7;

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
reg clk, rst, rst_acc, rst_mac, rst_cost;

// input ports
// reg signed [WIDTH-1:0] /*i_layr1_a, i_layr1_i,*/ i_layr1_f, /*i_layr1_o,*/ i_layr1_state;
// reg signed [WIDTH-1:0] /*i_layr2_a, i_layr2_i,*/ i_layr2_f, /*i_layr2_o,*/ i_layr2_state/*, i_layr2_h, i_layr2_t*/;

// control ports
reg sel_a;
reg sel_i;
reg sel_f;
reg sel_o;
reg sel_h;
reg sel_t;
reg sel_state;
reg sel_dstate;
reg sel_dout;

reg [1:0] sel_in1;
reg [1:0] sel_in2;
reg sel_in3;
reg [1:0] sel_in4;
reg [2:0] sel_in5;
reg [1:0] sel_x1_1;
reg sel_x1_2;
reg [1:0] sel_x2_2;
reg sel_as_1;
reg [1:0] sel_as_2;
reg sel_addsub;
reg [1:0] sel_temp;

reg acc_da, acc_di, acc_df, acc_do, acc_cost;
reg acc_mac;

reg [1:0] sel_dgate;

reg sel_wght;
reg [1:0] sel_wghts1;
reg [2:0] sel_wghts2;

reg wr_da1, wr_di1, wr_df1, wr_do1;
reg [11:0] /*[8:0]*/ rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
reg [11:0] /*[8:0]*/ wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

reg wr_da2, wr_di2, wr_df2, wr_do2;
reg [11:0] /*[5:0]*/ rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
reg [11:0] /*[5:0]*/ wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

reg wr_dx2, wr_dout2, wr_dout1;
reg [11:0] /*[8:0]*/ rd_addr_dx2, wr_addr_dx2;
reg [11:0] /*[3:0]*/ rd_addr_dout2, wr_addr_dout2;
reg [11:0] /*[6:0]*/ rd_addr_dout1, wr_addr_dout1;

reg wr_dstate1, wr_dstate2;
reg [11:0] /*[3:0]*/ rd_addr_dstate2, wr_addr_dstate2;
reg [11:0] /*[6:0]*/ rd_addr_dstate1, wr_addr_dstate1;

reg [11:0] /*[8:0]*/ rd_layr2_wa, rd_layr2_wi, rd_layr2_wf, rd_layr2_wo;
reg [11:0] /*[5:0]*/ rd_layr2_ua, rd_layr2_ui, rd_layr2_uf, rd_layr2_uo;

reg [11:0] /*[5:0]*/ rd_layr1_ua, rd_layr1_ui, rd_layr1_uf, rd_layr1_uo;

reg [11:0] /*[8:0]*/ rd_layr1_a, rd_layr1_i, rd_layr1_f, rd_layr1_o, rd_layr1_state;
reg [11:0] /*[5:0]*/ rd_layr2_t, rd_layr2_h, rd_layr2_a, rd_layr2_i, rd_layr2_f, rd_layr2_o, rd_layr2_state;


// wires
wire signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;

wire signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
wire signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;

wire signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
wire signed [WIDTH-1:0] i_layr2_t, i_layr2_h, i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state;

wire signed [WIDTH-1:0] dgate, o_cost;

wire signed [WIDTH-1:0] da1, di1, df1, do1;
wire signed [WIDTH-1:0] da2, di2, df2, do2;

/////////////////////
reg [2:0] tstep;
/////////////////////

///////////////////////////////////////////
////// LAYER 2 FORWARD MEMORY  ///////////
memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer2_t_bp.list")
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

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP+1),
	.FILENAME("layer2_h_bp.list")
) mem_h2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_h),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_h)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP+1),
	.FILENAME("layer2_c_bp.list")
) mem_c2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_state),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_state)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer2_a_bp.list")
) mem_a2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_a),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_a)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer2_i_bp.list")
) mem_i2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_i),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_i)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP+1),
	.FILENAME("layer2_f_bp.list")
) mem_f2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_f),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_f)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(LAYR2_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer2_o_bp.list")
) mem_o2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_o),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_o)
);
///////////////////////////////////////////
////// LAYER 2 W & U MEMORY  /////////////
memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(53*8),
	.TIMESTEP(1),
	.FILENAME("layer2_wa.list")
) mem_wa2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_wa),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_wa)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(53*8),
	.TIMESTEP(1),
	.FILENAME("layer2_wi.list")
) mem_wi2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_wi),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_wi)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(53*8),
	.TIMESTEP(1),
	.FILENAME("layer2_wf.list")
) mem_wf2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_wf),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_wf)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(53*8),
	.TIMESTEP(1),
	.FILENAME("layer2_wo.list")
) mem_wo2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_wo),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_wo)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer2_ua.list")
) mem_ua2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_ua),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_ua)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer2_ui.list")
) mem_ui2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_ui),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_ui)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer2_uf.list")
) mem_uf2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_uf),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_uf)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer2_uo.list")
) mem_uo2 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr2_uo),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr2_uo)
);
///////////////////////////////////////////
//////////////////////////////////////////
////// LAYER 1 FORWARD MEMORY  //////////
memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(LAYR1_CELL),
	.TIMESTEP(TIMESTEP+1),
	.FILENAME("layer1_c_bp.list")
) mem_c1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_state),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_state)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(LAYR1_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer1_a_bp.list")
) mem_a1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_a),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_a)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(LAYR1_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer1_i_bp.list")
) mem_i1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_i),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_i)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(LAYR1_CELL),
	.TIMESTEP(TIMESTEP+1),
	.FILENAME("layer1_f_bp.list")
) mem_f1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_f),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_f)
);

memory_cell #(
	// .ADDR(9),
	.WIDTH(WIDTH),
	.NUM(LAYR1_CELL),
	.TIMESTEP(TIMESTEP),
	.FILENAME("layer1_o_bp.list")
) mem_o1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_o),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_o)
);
/////////////////////////////////////////
////// LAYER 1 W & U MEMORY  ///////////
memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer1_ua.list")
) mem_ua1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_ua),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_ua)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer1_ui.list")
) mem_ui1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_ui),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_ui)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer1_uf.list")
) mem_uf1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_uf),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_uf)
);

memory_cell #(
	// .ADDR(6),
	.WIDTH(WIDTH),
	.NUM(8*8),
	.TIMESTEP(1),
	.FILENAME("layer1_uo.list")
) mem_uo1 (
	.clk    (clk),
	.rst    (rst),
	.wr_a   (),
	.addr_a (),
	.addr_b (rd_layr1_uo),
	.i_a    (),
	.o_a    (),
	.o_b    (i_layr1_uo)
);
///////////////////////////////////////////////

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
		.rst_mac       (rst_mac),
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
		// .i_layr1_wa    (i_layr1_wa),
		// .i_layr1_wi    (i_layr1_wi),
		// .i_layr1_wf    (i_layr1_wf),
		// .i_layr1_wo    (i_layr1_wo),
		.i_layr1_ua    (i_layr1_ua),
		.i_layr1_ui    (i_layr1_ui),
		.i_layr1_uf    (i_layr1_uf),
		.i_layr1_uo    (i_layr1_uo),
		// .i_layr1_ba    (i_layr1_ba),
		// .i_layr1_bi    (i_layr1_bi),
		// .i_layr1_bf    (i_layr1_bf),
		// .i_layr1_bo    (i_layr1_bo),
		.i_layr2_wa    (i_layr2_wa),
		.i_layr2_wi    (i_layr2_wi),
		.i_layr2_wf    (i_layr2_wf),
		.i_layr2_wo    (i_layr2_wo),
		.i_layr2_ua    (i_layr2_ua),
		.i_layr2_ui    (i_layr2_ui),
		.i_layr2_uf    (i_layr2_uf),
		.i_layr2_uo    (i_layr2_uo),
		// .i_layr2_ba    (i_layr2_ba),
		// .i_layr2_bi    (i_layr2_bi),
		// .i_layr2_bf    (i_layr2_bf),
		// .i_layr2_bo    (i_layr2_bo),
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
		// .wr_da1        (wr_da1),
		// .wr_di1        (wr_di1),
		// .wr_df1        (wr_df1),
		// .wr_do1        (wr_do1),
		// .wr_da2        (wr_da2),
		// .wr_di2        (wr_di2),
		// .wr_df2        (wr_df2),
		// .wr_do2        (wr_do2),
		.wr_dx2        (wr_dx2),
		.wr_dout2      (wr_dout2),
		.wr_dout1      (wr_dout1),
		.wr_dstate2	   (wr_dstate2),
		.wr_dstate1	   (wr_dstate1),
		// .rd_addr_da1   (rd_addr_da1),
		// .rd_addr_di1   (rd_addr_di1),
		// .rd_addr_df1   (rd_addr_df1),
		// .rd_addr_do1   (rd_addr_do1),
		// .wr_addr_da1   (wr_addr_da1),
		// .wr_addr_di1   (wr_addr_di1),
		// .wr_addr_df1   (wr_addr_df1),
		// .wr_addr_do1   (wr_addr_do1),
		// .rd_addr_da2   (rd_addr_da2),
		// .rd_addr_di2   (rd_addr_di2),
		// .rd_addr_df2   (rd_addr_df2),
		// .rd_addr_do2   (rd_addr_do2),
		// .wr_addr_da2   (wr_addr_da2),
		// .wr_addr_di2   (wr_addr_di2),
		// .wr_addr_df2   (wr_addr_df2),
		// .wr_addr_do2   (wr_addr_do2),
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
        // .ADDR(6),
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
        .o_b    (da2)
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
        .o_b    (di2)
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
        .o_b    (df2)
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
        .o_b    (do2)
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
        .o_b    (da1)
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
        .o_b    (di1)
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
        .o_b    (df1)
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
        .o_b    (do1)
    );

/////////////////////////////////////////////
initial
begin
	////////////////// RESET //////////////////////////////
	// CLOCK 0
	clk = 1;
	rst <= 1;
	rst_acc <= 1;
	rst_cost <= 1;

	sel_dgate <= 2'b00;
	sel_wghts2 <= 3'b000;
	sel_wghts1 <= 2'b00;
	sel_wght <= 1'b0;
	acc_mac <= 1'b0;

	rd_layr2_wa <= 9'd0;
	rd_layr2_wi <= 9'd0;
	rd_layr2_wf <= 9'd0;
	rd_layr2_wo <= 9'd0;
	rd_layr2_ua <= 6'd0;
	rd_layr2_ui <= 6'd0;
	rd_layr2_uf <= 6'd0;
	rd_layr2_uo <= 6'd0;

	rd_layr1_ua <= 6'd0;
	rd_layr1_ui <= 6'd0;
	rd_layr1_uf <= 6'd0;
	rd_layr1_uo <= 6'd0;

	rd_addr_dstate2 <= 4'd0;
	rd_addr_dout2 <= 4'd0;

	rd_addr_dx2 <= 9'd0;
	rd_addr_dout1 <= 7'd0;
	
	rd_addr_dstate1 <= 7'd0;

	wr_dx2 <= 1'b0;
	wr_addr_dx2 <= 9'd0;
	wr_addr_dout2 <= 4'd0;
	wr_addr_dout1 <= 7'd0;

	wr_addr_da2 <= 6'd48;
	wr_addr_di2 <= 6'd48;
	wr_addr_df2 <= 6'd48;
	wr_addr_do2 <= 6'd48;
	wr_addr_dstate2 <= 4'd8;

	wr_addr_da1 <= 9'd318;
	wr_addr_di1 <= 9'd318;
	wr_addr_df1 <= 9'd318;
	wr_addr_do1 <= 9'd318;
	wr_addr_dstate1 <= 7'd53;

	tstep <= 3'd0;

	rd_layr2_t <= 6'd48;	
	rd_layr2_h <= 6'd48;	
	rd_layr2_a <= 6'd48;	
	rd_layr2_i <= 6'd48;
	rd_layr2_o <= 6'd48;

	rd_layr2_f <= 6'd56;
	rd_layr2_state <= 6'd56;

	rd_layr1_a <= 9'd318;
	rd_layr1_i <= 9'd318;
	rd_layr1_o <= 9'd318;

	rd_layr1_f <= 9'd371;
	rd_layr1_state <= 9'd371;		
	#100;

	repeat(7)
	begin
		/////////////// START LAYER 2 DELTA ///////////////////
		////////////// 1 ST  CELL ////////////////////////////
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h1;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr2_a <= 32'h00d98c7e; 
		// i_layr2_i <= 32'h00fb2e9c; 
		// i_layr2_f <= 32'h00000000; 
		// i_layr2_o <= 32'h00d99503; 
		// i_layr2_h <= 32'h00c59fd3; 
		// i_layr2_t <= 32'h01400000; 
		// i_layr2_state <= 32'h0184816f; 
		
		// rd_addr_dout2 <= 4'd0;
		// rd_addr_dstate2 <= 4'd0;
		// rd_addr_dx2 <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		// CLOCK 1
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00000000;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		// CLOCK 2
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h2;
		sel_in2 <= 2'h3;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h1;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h3;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h3;
		sel_addsub <= 1'h1;
		sel_temp   <= 2'h0;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00000000;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		// CLOCK 3
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h2;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h4;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00000000;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b1;

		// rd_layr2_f <= rd_layr2_f - 6'd8;
		#100;

		// CLOCK 4
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h1;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h2;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		// CLOCK 5
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h1;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h1;
		sel_as_2 <= 2'h2;
		sel_addsub <= 1'h1;
		sel_temp   <= 2'h1;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		// CLOCK 6
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h1;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h2;
		sel_x1_1 <= 2'h2;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h1;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b1;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b1;
		acc_cost <= 1'b0;

		rd_layr2_state <= rd_layr2_state - 6'd8;
		rd_layr2_f <= rd_layr2_f - 6'd8;
		#100;
		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h1;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h3;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h1;
		sel_x2_2 <= 2'h2;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;
		
		// CLOCK 8
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h3;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h3;	
		sel_x1_1 <= 2'h2;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b1;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b1;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;
		// $display("dat <= %h \n", o_dgate);

		// CLOCK 9
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h1;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b1;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b1;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;
		// $display("dit <= %h \n", o_dgate);


		// CLOCK 10
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 0;
		sel_i <= 0;
		sel_f <= 0;
		sel_o <= 0;
		sel_h <= 0;
		sel_t <= 0;
		sel_state <= 0;
		sel_dstate <= 0;
		sel_dout <= 0;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr2_a <= 32'h00d98c7e;
		// i_layr2_i <= 32'h00fb2e9c;
		// i_layr2_f <= 32'h00decbfb;
		// i_layr2_o <= 32'h00d99503;
		// i_layr2_h <= 32'h00c59fd3;
		// i_layr2_t <= 32'h01400000;
		// i_layr2_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b0;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;
		#100;

		wr_da2 <= 1'b0;
		wr_di2 <= 1'b0;
		wr_df2 <= 1'b1;
		wr_do2 <= 1'b0;
		wr_dstate2 <= 1'b1;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b1;
		acc_do <= 1'b0;
		acc_cost <= 1'b0;

		rd_layr2_t <= rd_layr2_t + 6'd1;
		rd_layr2_h <= rd_layr2_h + 6'd1;
		rd_layr2_a <= rd_layr2_a + 6'd1;
		rd_layr2_i <= rd_layr2_i + 6'd1;
		rd_layr2_o <= rd_layr2_o + 6'd1;

		rd_layr2_f <= rd_layr2_f + 6'd9;
		rd_layr2_state <= rd_layr2_state + 6'd9;
		#100;
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL ///////////////////////
		repeat(8-1)
		begin
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h1;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr2_a <= 32'h00d98c7e; 
			// i_layr2_i <= 32'h00fb2e9c; 
			// i_layr2_f <= 32'h00000000; 
			// i_layr2_o <= 32'h00d99503; 
			// i_layr2_h <= 32'h00c59fd3; 
			// i_layr2_t <= 32'h01400000; 
			// i_layr2_state <= 32'h0184816f; 
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			rd_addr_dout2 <= rd_addr_dout2 + 4'd1;
			rd_addr_dstate2 <= rd_addr_dstate2 + 4'd1;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			wr_addr_da2 <= wr_addr_da2 + 6'd1;
			wr_addr_di2 <= wr_addr_di2 + 6'd1;
			wr_addr_df2 <= wr_addr_df2 + 6'd1;
			wr_addr_do2 <= wr_addr_do2 + 6'd1;
			wr_addr_dstate2 <= wr_addr_dstate2 + 4'd1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			acc_mac <= 1'b0;
			#100;

			// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00000000;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;

			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h2;
			sel_in2 <= 2'h3;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h1;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h3;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h3;
			sel_addsub <= 1'h1;
			sel_temp   <= 2'h0;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00000000;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;

			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h2;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h4;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00000000;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b1;

			// rd_layr2_f <= rd_layr2_f - 6'd8;
			#100;

			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h1;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h2;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;

			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h1;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h1;
			sel_as_2 <= 2'h2;
			sel_addsub <= 1'h1;
			sel_temp   <= 2'h1;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;

			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h1;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h2;
			sel_x1_1 <= 2'h2;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h1;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b1;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b1;
			acc_cost <= 1'b0;
			
			rd_layr2_f <= rd_layr2_f - 6'd8;
			rd_layr2_state <= rd_layr2_state - 6'd8;
			#100;
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h1;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h3;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h1;
			sel_x2_2 <= 2'h2;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;
			
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h3;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h3;	
			sel_x1_1 <= 2'h2;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b1;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b1;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;
			// $display("dat <= %h \n", o_dgate);

			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h1;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b1;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b1;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;
			#100;
			// $display("dit <= %h \n", o_dgate);


			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 0;
			sel_i <= 0;
			sel_f <= 0;
			sel_o <= 0;
			sel_h <= 0;
			sel_t <= 0;
			sel_state <= 0;
			sel_dstate <= 0;
			sel_dout <= 0;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr2_a <= 32'h00d98c7e;
			// i_layr2_i <= 32'h00fb2e9c;
			// i_layr2_f <= 32'h00decbfb;
			// i_layr2_o <= 32'h00d99503;
			// i_layr2_h <= 32'h00c59fd3;
			// i_layr2_t <= 32'h01400000;
			// i_layr2_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;

			rst_mac <= 1'b1;
			#100;

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;
			acc_cost <= 1'b0;

			rst_mac <= 1'b0;
			acc_mac <= 1'b1;

			rd_layr2_t <= rd_layr2_t + 6'd1;
			rd_layr2_h <= rd_layr2_h + 6'd1;
			rd_layr2_a <= rd_layr2_a + 6'd1;
			rd_layr2_i <= rd_layr2_i + 6'd1;
			rd_layr2_o <= rd_layr2_o + 6'd1;

			rd_layr2_f <= rd_layr2_f + 6'd9;
			rd_layr2_state <= rd_layr2_state + 6'd9;
			#100;

		end 
		////////////////// END LAYER 2 DELTA ///////////////////////////

		///////////////// START  CALCULATE dX2 /////////////////////////
		repeat(53-1)
		begin
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;

			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b001;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;
			
			#100;

			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

			rd_layr2_wa <= rd_layr2_wa + 9'd1;
			rd_layr2_wi <= rd_layr2_wi + 9'd1;
			rd_layr2_wf <= rd_layr2_wf + 9'd1;
			rd_layr2_wo <= rd_layr2_wo + 9'd1;
			#100;	

			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
			#100;
		end

		// Last Repeat to change mux on last cycle
		sel_dgate <= 2'b01;
		sel_wghts2 <= 3'b001;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		rst_mac = 1'b0;
		wr_dx2 <= 1'b0;	
		#100;

		sel_dgate <= 2'b10;
		sel_wghts2 <= 3'b010;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b0;
		#100;

		sel_dgate <= 2'b11;
		sel_wghts2 <= 3'b011;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b0;
		#100;
		
		sel_dgate <= 2'b00;
		sel_wghts2 <= 3'b000;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b1;

		rd_layr2_wa <= rd_layr2_wa + 9'd1;
		rd_layr2_wi <= rd_layr2_wi + 9'd1;
		rd_layr2_wf <= rd_layr2_wf + 9'd1;
		rd_layr2_wo <= rd_layr2_wo + 9'd1;	
		#100;	

		rst_mac = 1'b1;
		wr_dx2 <= 1'b0;
		wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
		sel_wghts2 <= 3'b100;
		#100;
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		repeat(8)
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b101;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;		
			#100;

			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

			rd_layr2_ua <= rd_layr2_ua + 6'd1;
			rd_layr2_ui <= rd_layr2_ui + 6'd1;
			rd_layr2_uf <= rd_layr2_uf + 6'd1;
			rd_layr2_uo <= rd_layr2_uo + 6'd1;
			#100;	
		
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
			wr_addr_dout2 <= wr_addr_dout2 + 4'd1;
			#100;
		end

		///////////////// START  CALCULATE LAYER 1 DELTA /////////////////////////
		//////////////// 1 ST CELL //////////////////////////////////////////////
		rst <= 0;
		rst_acc <= 1;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h1;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr1_a <= 32'h00d98c7e; 
		// i_layr1_i <= 32'h00fb2e9c; 
		// i_layr1_f <= 32'h00000000; 
		// i_layr1_o <= 32'h00d99503; 
		// i_layr1_state <= 32'h0184816f; 
		
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;

		sel_wght <= 1'b1;
		#100;

		// CLOCK 1
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00000000;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;

		// CLOCK 2
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h2;
		sel_in2 <= 2'h3;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h1;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h3;
		sel_addsub <= 1'h1;
		sel_temp   <= 2'h0;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00000000;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;

		// CLOCK 3
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h2;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h4;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h0;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00000000;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;

		// rd_layr1_f <= rd_layr1_f - 9'd53;
		#100;

		// CLOCK 4
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h1;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h2;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;

		// CLOCK 5
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h1;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h1;
		sel_as_2 <= 2'h2;
		sel_addsub <= 1'h1;
		sel_temp   <= 2'h1;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;

		// CLOCK 6
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h1;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h2;
		sel_x1_1 <= 2'h2;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h1;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h0184816f;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b1;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b1;

		rd_layr1_f <= rd_layr1_f - 9'd53;
		rd_layr1_state <= rd_layr1_state - 9'd53;
		#100;
		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h1;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h3;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h1;
		sel_x2_2 <= 2'h2;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;
		
		// CLOCK 8
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h3;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h2;
		sel_in5 <= 3'h3;	
		sel_x1_1 <= 2'h2;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b1;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b1;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;
		// $display("dat <= %h \n", o_dgate);

		// CLOCK 9
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h1;
		sel_x2_2 <= 2'h0;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b1;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b1;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;
		// $display("dit <= %h \n", o_dgate);


		// CLOCK 10
		rst <= 0;
		rst_acc <= 0;
		rst_cost <= 0;
		sel_a <= 1;
		sel_i <= 1;
		sel_f <= 1;
		sel_o <= 1;
		sel_h <= 1;
		sel_t <= 1;
		sel_state <= 1;
		sel_dstate <= 1;
		sel_dout <= 1;
		sel_in1 <= 2'h0;
		sel_in2 <= 2'h0;
		sel_in3 <= 1'h0;
		sel_in4 <= 2'h0;
		sel_in5 <= 3'h0;
		sel_x1_1 <= 2'h0;
		sel_x1_2 <= 1'h0;
		sel_x2_2 <= 2'h1;
		sel_as_1 <= 1'h0;
		sel_as_2 <= 2'h0;
		sel_addsub <= 1'h0;
		sel_temp   <= 2'h2;
		// i_layr1_a <= 32'h00d98c7e;
		// i_layr1_i <= 32'h00fb2e9c;
		// i_layr1_f <= 32'h00decbfb;
		// i_layr1_o <= 32'h00d99503;
		// i_layr1_h <= 32'h00c59fd3;
		// i_layr1_t <= 32'h01400000;
		// i_layr1_state <= 32'h00c924f2;
		// d_state <= 32'h00000000;
		// d_out   <= 32'h00000000;
		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b0;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b0;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b0;
		acc_do <= 1'b0;
		#100;

		wr_da1 <= 1'b0;
		wr_di1 <= 1'b0;
		wr_df1 <= 1'b1;
		wr_do1 <= 1'b0;
		wr_dstate1 <= 1'b1;
		acc_da <= 1'b0;
		acc_di <= 1'b0;
		acc_df <= 1'b1;
		acc_do <= 1'b0;
		rd_addr_dx2 <= rd_addr_dx2 + 9'd1;

		rd_layr1_a <= rd_layr1_a + 9'd1;
		rd_layr1_i <= rd_layr1_i + 9'd1;
		rd_layr1_o <= rd_layr1_o + 9'd1;
		
		rd_layr1_f <= rd_layr1_f + 9'd54;
		rd_layr1_state <= rd_layr1_state + 9'd54;
		#100;
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL //////////////////////
		repeat(53-1)
		begin
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h1;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr1_a <= 32'h00d98c7e; 
			// i_layr1_i <= 32'h00fb2e9c; 
			// i_layr1_f <= 32'h00000000; 
			// i_layr1_o <= 32'h00d99503; 
			// i_layr1_h <= 32'h00c59fd3; 
			// i_layr1_t <= 32'h01400000; 
			// i_layr1_state <= 32'h0184816f; 
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			rd_addr_dout1 <= rd_addr_dout1 + 7'd1;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			wr_addr_da1 <= wr_addr_da1 + 9'd1;
			wr_addr_di1 <= wr_addr_di1 + 9'd1;
			wr_addr_df1 <= wr_addr_df1 + 9'd1;
			wr_addr_do1 <= wr_addr_do1 + 9'd1;
			wr_addr_dstate1 <= wr_addr_dstate1 + 7'd1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
			#100;

			// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00000000;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;

			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h2;
			sel_in2 <= 2'h3;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h1;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h3;
			sel_addsub <= 1'h1;
			sel_temp   <= 2'h0;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00000000;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;

			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h2;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h4;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h0;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00000000;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;

			// rd_layr1_f <= rd_layr1_f - 9'd53;
			#100;

			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h1;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h2;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;

			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h1;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h1;
			sel_as_2 <= 2'h2;
			sel_addsub <= 1'h1;
			sel_temp   <= 2'h1;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;

			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h1;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h2;
			sel_x1_1 <= 2'h2;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h1;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h0184816f;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b1;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b1;

			rd_layr1_f <= rd_layr1_f - 9'd53;
			rd_layr1_state <= rd_layr1_state - 9'd53;
			#100;
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h1;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h3;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h1;
			sel_x2_2 <= 2'h2;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;
			
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h3;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h2;
			sel_in5 <= 3'h3;	
			sel_x1_1 <= 2'h2;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b1;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b1;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;
			// $display("dat <= %h \n", o_dgate);

			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h1;
			sel_x2_2 <= 2'h0;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b1;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b1;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			#100;
			// $display("dit <= %h \n", o_dgate);


			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
			rst_cost <= 0;
			sel_a <= 1;
			sel_i <= 1;
			sel_f <= 1;
			sel_o <= 1;
			sel_h <= 1;
			sel_t <= 1;
			sel_state <= 1;
			sel_dstate <= 1;
			sel_dout <= 1;
			sel_in1 <= 2'h0;
			sel_in2 <= 2'h0;
			sel_in3 <= 1'h0;
			sel_in4 <= 2'h0;
			sel_in5 <= 3'h0;
			sel_x1_1 <= 2'h0;
			sel_x1_2 <= 1'h0;
			sel_x2_2 <= 2'h1;
			sel_as_1 <= 1'h0;
			sel_as_2 <= 2'h0;
			sel_addsub <= 1'h0;
			sel_temp   <= 2'h2;
			// i_layr1_a <= 32'h00d98c7e;
			// i_layr1_i <= 32'h00fb2e9c;
			// i_layr1_f <= 32'h00decbfb;
			// i_layr1_o <= 32'h00d99503;
			// i_layr1_h <= 32'h00c59fd3;
			// i_layr1_t <= 32'h01400000;
			// i_layr1_state <= 32'h00c924f2;
			// d_state <= 32'h00000000;
			// d_out   <= 32'h00000000;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;

			rst_mac <= 1'b1;
			#100;

			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

			rst_mac <= 1'b0;
			acc_mac <= 1'b1;
			rd_addr_dx2 <= rd_addr_dx2 + 9'd1;

			rd_layr1_a <= rd_layr1_a + 9'd1;
			rd_layr1_i <= rd_layr1_i + 9'd1;
			rd_layr1_o <= rd_layr1_o + 9'd1;
			
			rd_layr1_f <= rd_layr1_f + 9'd54;
			rd_layr1_state <= rd_layr1_state + 9'd54;
			#100;

		end 
		////////////////// END LAYER 1 DELTA ///////////////////////////

		///////////////// START  CALCULATE dOut2 /////////////////////////
		repeat(53)
		begin
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;

			sel_dgate <= 2'b01;
			sel_wghts1 <= 2'b01;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dout1 <= 1'b0;
			wr_df1 <= 1'b0;		
			#100;

			sel_dgate <= 2'b10;
			sel_wghts1 <= 2'b10;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;

			rd_layr1_ua <= rd_layr1_ua + 6'd1;
			rd_layr1_ui <= rd_layr1_ui + 6'd1;
			rd_layr1_uf <= rd_layr1_uf + 6'd1;
			rd_layr1_uo <= rd_layr1_uo + 6'd1;
			#100;	
		
			rst_mac = 1'b1;
			wr_dout1 <= 1'b0;	
			wr_addr_dout1 <= wr_addr_dout1 + 4'd1;
			#100;
		end

		//// CONDITIONING FOR NEXT TIME STEP
		rst <= 1;
		rst_acc <= 1;
		rst_cost <= 1;

		sel_dgate <= 2'b00;
		sel_wghts2 <= 3'b000;
		sel_wghts1 <= 2'b00;
		sel_wght <= 1'b0;
		acc_mac <= 1'b0;

		rd_layr2_wa <= 9'd0;
		rd_layr2_wi <= 9'd0;
		rd_layr2_wf <= 9'd0;
		rd_layr2_wo <= 9'd0;
		rd_layr2_ua <= 6'd0;
		rd_layr2_ui <= 6'd0;
		rd_layr2_uf <= 6'd0;
		rd_layr2_uo <= 6'd0;

		rd_layr1_ua <= 6'd0;
		rd_layr1_ui <= 6'd0;
		rd_layr1_uf <= 6'd0;
		rd_layr1_uo <= 6'd0;

		if (tstep[0] == 1'b1) 
		begin
			rd_addr_dstate2 <= 4'd0;
			rd_addr_dstate1 <= 7'd0;

			wr_addr_dstate2 <= 4'd8;
			wr_addr_dstate1 <= 7'd53;
		end
		else 
		begin
			rd_addr_dstate2 <= 4'd8;
			rd_addr_dstate1 <= 7'd53;

			wr_addr_dstate2 <= 4'd0;
			wr_addr_dstate1 <= 7'd0;
		end

		wr_dx2 <= 1'b0;

		rd_addr_dx2 <= 9'd0;
		rd_addr_dout2 <= 4'd0;
		rd_addr_dout1 <= 7'd0;

		wr_addr_dx2 <= 9'd0;
		wr_addr_dout2 <= 4'd0;
		wr_addr_dout1 <= 7'd0;

		wr_addr_da2 <= wr_addr_da2 - 6'd15;
		wr_addr_di2 <= wr_addr_di2 - 6'd15;
		wr_addr_df2 <= wr_addr_df2 - 6'd15;
		wr_addr_do2 <= wr_addr_do2 - 6'd15;

		wr_addr_da1 <= wr_addr_da1 - 9'd105;
		wr_addr_di1 <= wr_addr_di1 - 9'd105;
		wr_addr_df1 <= wr_addr_df1 - 9'd105;
		wr_addr_do1 <= wr_addr_do1 - 9'd105;

		tstep <= tstep + 3'd1;

		rd_layr2_t <= rd_layr2_t - 6'd16;
		rd_layr2_h <= rd_layr2_h - 6'd16;
		rd_layr2_a <= rd_layr2_a - 6'd16;
		rd_layr2_i <= rd_layr2_i - 6'd16;
		rd_layr2_o <= rd_layr2_o - 6'd16;

		rd_layr2_f <= rd_layr2_f - 6'd16;
		rd_layr2_state <= rd_layr2_state - 6'd16;

		rd_layr1_a <= rd_layr1_a - 9'd106;
		rd_layr1_i <= rd_layr1_i - 9'd106;
		rd_layr1_o <= rd_layr1_o - 9'd106;

		rd_layr1_f <= rd_layr1_f - 9'd106;
		rd_layr1_state <= rd_layr1_state - 9'd106;
		#100;

	end
end
	
always 
begin
	#50;
	clk = !clk;
end


endmodule