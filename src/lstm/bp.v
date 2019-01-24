////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation module
// File Name        : bp.v
// Version          : 2.0
// Description      : LSTM Backpropagation calculation include:
//                    calculation of delta, dweight, dbias, and cost
//
////////////////////////////////////////////////////////////////////////////////

module bp ( clk, rst, rst_acc, rst_mac,
            i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state,
            i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t,
            // i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo,
            i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo,
            // i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo,
            i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo,
            i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo,
            // i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo,
            sel_a, sel_i, sel_f, sel_o, sel_h, sel_t, sel_state, sel_dstate, sel_dout,
            sel_in1, sel_in2, sel_in3, sel_in4, sel_in5,
            sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, 
            sel_addsub, sel_temp,
            acc_da, acc_di, acc_df, acc_do, acc_mac,
            
            sel_dgate, sel_wght, sel_wghts1, sel_wghts2,
            wr_da1, wr_di1, wr_df1, wr_do1,
            wr_da2, wr_di2, wr_df2, wr_do2,
            wr_dx2, wr_dout2, wr_dout1,
            wr_dstate2, wr_dstate1,
            rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1,
            wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1,
            rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2,
            wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2,
            rd_addr_dx2, rd_addr_dout2, rd_addr_dout1,
            wr_addr_dx2, wr_addr_dout2, wr_addr_dout1,
            rd_addr_dstate2, rd_addr_dstate1,
            wr_addr_dstate2, wr_addr_dstate1
            );

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
parameter LAYR1_dState = "layer1_dState.list";

// This holds d gates
parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";
parameter LAYR2_dState = "layer2_dState.list";

// common ports
input clk, rst, rst_acc, rst_mac;

// input ports
input signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
input signed [WIDTH-1:0] i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t;

// input signed [WIDTH-1:0] i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo;
input signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;
// input signed [WIDTH-1:0] i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo;
input signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
input signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;
// input signed [WIDTH-1:0] i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo;

// control ports
input sel_a;
input sel_i;
input sel_f;
input sel_o;
input sel_h;
input sel_t;
input sel_state;
input sel_dstate;
input sel_dout;

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

input acc_da, acc_di, acc_df, acc_do;
input acc_mac;

input [1:0] sel_dgate;

input sel_wght;
input [1:0] sel_wghts1;
input [2:0] sel_wghts2;

input wr_da1, wr_di1, wr_df1, wr_do1;
input [8:0] rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
input [8:0] wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

input wr_da2, wr_di2, wr_df2, wr_do2;
input [5:0] rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
input [5:0] wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

input wr_dx2, wr_dout2, wr_dout1;
input [8:0] rd_addr_dx2, wr_addr_dx2;
input [3:0] rd_addr_dout2, wr_addr_dout2;
input [6:0] rd_addr_dout1, wr_addr_dout1;

input wr_dstate1, wr_dstate2;
input [3:0] rd_addr_dstate2, wr_addr_dstate2;
input [6:0] rd_addr_dstate1, wr_addr_dstate1;
// output ports


// registers

// wires
wire signed [WIDTH-1:0] i_a, i_i, i_f, i_o, i_h, i_t, i_state;
wire signed [WIDTH-1:0] d_state, reg_d_state, reg_d_state1, reg_d_state2;

wire signed [WIDTH-1:0] dgate;
wire signed [WIDTH-1:0] da1, di1, df1, do1;
wire signed [WIDTH-1:0] da2, di2, df2, do2;

wire signed [WIDTH-1:0] o_acc_da, o_acc_di, o_acc_df, o_acc_do;
wire signed [WIDTH-1:0] dgate_mux;
wire signed [WIDTH-1:0] wghts_mux1, wghts_mux2;

wire signed [WIDTH-1:0] o_mac;
wire signed [WIDTH-1:0] dx2, dout, dout1, dout2;

wire signed [WIDTH-1:0] layr2_w, layr2_u, layr1_w, layr1_u;

// Input Multiplexers
// in: layr1_aifo and layr2_aifo
assign i_a = sel_a ? i_layr1_a : i_layr2_a;
assign i_i = sel_i ? i_layr1_i : i_layr2_i;
assign i_f = sel_f ? i_layr1_f : i_layr2_f;
assign i_o = sel_o ? i_layr1_o : i_layr2_o;
assign i_h = sel_h ? dx2 : i_layr2_h;
assign i_t = sel_t ? {WIDTH{1'b0}} : i_layr2_t;
assign i_state = sel_state ? i_layr1_state : i_layr2_state;
assign reg_d_state = sel_dstate ? reg_d_state1 : reg_d_state2;
assign dout = sel_dout ? dout1 : dout2;

// Delta
// in: i_a, i_i, i_f, i_o, i_state, i_h, i_t
// out: odgate
delta #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) delta (
        .clk        (clk),
        .rst        (rst),
        .sel_in1    (sel_in1),
        .sel_in2    (sel_in2),
        .sel_in3    (sel_in3),
        .sel_in4    (sel_in4),
        .sel_in5    (sel_in5),
        .sel_x1_1   (sel_x1_1),
        .sel_x1_2   (sel_x1_2),
        .sel_x2_2   (sel_x2_2),
        .sel_as_1   (sel_as_1),
        .sel_as_2   (sel_as_2),
        .sel_addsub (sel_addsub),
        .sel_temp   (sel_temp),
        .at         (i_a),
        .it         (i_i),
        .ft         (i_f),
        .ot         (i_o),
        .h          (i_h),
        .t          (i_t),
        .state      (i_state),
        .d_state    (reg_d_state),
        .d_out      (dout),
        .o_dgate    (dgate),
        .o_d_state  (d_state)
    );

// LAYER 2 delta State Memory
memory_cell #(
        .ADDR(4),
        .WIDTH(WIDTH),
        .NUM(16),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dState)
    ) mem_dstate2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dstate2),
        .addr_a (wr_addr_dstate2),
        .addr_b (rd_addr_dstate2),
        .i_a    (d_state),
        .o_a    (),
        .o_b    (reg_d_state2)
    );

// LAYER 1 delta State Memory
memory_cell #(
        .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(106),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dState)
    ) mem_dstate1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dstate1),
        .addr_a (wr_addr_dstate1),
        .addr_b (rd_addr_dstate1),
        .i_a    (d_state),
        .o_a    (),
        .o_b    (reg_d_state1)
    );

// LAYER 2 dA, dI, dF, dO Memory
// out: da2, di2, df2, do2
memory_cell #(
        .ADDR(6),
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
        .ADDR(6),
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
        .ADDR(6),
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
        .ADDR(6),
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


// ACC Array for dX and delta Out
// in: da, di, df, do
// out: dx, delta Out
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_da (.clk(clk), .rst(rst_acc), .acc(acc_da), .i(dgate), .o(o_acc_da));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_di (.clk(clk), .rst(rst_acc), .acc(acc_di), .i(dgate), .o(o_acc_di));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_df (.clk(clk), .rst(rst_acc), .acc(acc_df), .i(dgate), .o(o_acc_df));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) _acc_do (.clk(clk), .rst(rst_acc), .acc(acc_do), .i(dgate), .o(o_acc_do));

// LAYER 2 dgates Multiplexer
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_x (.i_a(o_acc_da), .i_b(o_acc_di), .i_c(o_acc_df), .i_d(o_acc_do), .sel(sel_dgate), .o(dgate_mux));

// LAYER 2 W & U Memory Multiplexer
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout_w2 (.i_a(i_layr2_wa), .i_b(i_layr2_wi), .i_c(i_layr2_wf), .i_d(i_layr2_wo), .sel(sel_wghts2[1:0]), .o(layr2_w));
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout_u2 (.i_a(i_layr2_ua), .i_b(i_layr2_ui), .i_c(i_layr2_uf), .i_d(i_layr2_uo), .sel(sel_wghts2[1:0]), .o(layr2_u));
assign wghts_mux2 = sel_wghts2[2] ? layr2_u : layr2_w;

// LAYER 1 U Memory Multiplexer
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout_u1 (.i_a(i_layr1_ua), .i_b(i_layr1_ui), .i_c(i_layr1_uf), .i_d(i_layr1_uo), .sel(sel_wghts1[1:0]), .o(layr1_u));
assign wghts_mux1 = sel_wght ? layr1_u : wghts_mux2;

// LAYER 2 MAC
// in: dgate
// out: dX/delta Out
mac #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) mac (
        .clk (clk),
        .rst (rst_mac),
        .acc (acc_mac),
        .i_x (dgate_mux),
        .i_m (wghts_mux1),
        .o   (o_mac)
    );

// LAYER 2 dX Memory
// in: o_mac2
// out: dx2
memory_cell #(
        .ADDR(9),
        .WIDTH(WIDTH),
        .NUM(371),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dX)
    ) mem_dx2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dx2),
        .addr_a (wr_addr_dx2),
        .addr_b (rd_addr_dx2),
        .i_a    (o_mac),
        .o_a    (),
        .o_b    (dx2)
    );

// LAYER 2 delta Out Memory
// in: o_mac2
// out: dout2
memory_cell #(
        .ADDR(4),
        .WIDTH(WIDTH),
        .NUM(16),
        .TIMESTEP(1),
        .FILENAME(LAYR2_dOut)
    ) mem_dout2 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dout2),
        .addr_a (wr_addr_dout2),
        .addr_b (rd_addr_dout2),
        .i_a    (o_mac),
        .o_a    (),
        .o_b    (dout2)
    );

// LAYER 1 dA, dI, dF, dO Memory
// in: addr, wr, odgate
// out: da, di, df, do
memory_cell #(
        .ADDR(9),
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
        .ADDR(9),
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
        .ADDR(9),
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
        .ADDR(9),
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

// LAYER 1 delta Out Memory
// in: o_mac1
// out: dout1
memory_cell #(
        .ADDR(7),
        .WIDTH(WIDTH),
        .NUM(106),
        .TIMESTEP(1),
        .FILENAME(LAYR1_dOut)
    ) mem_dout1 (
        .clk    (clk),
        .rst    (rst),
        .wr_a   (wr_dout1),
        .addr_a (wr_addr_dout1),
        .addr_b (rd_addr_dout1),
        .i_a    (o_mac),
        .o_a    (),
        .o_b    (dout1)
    );

endmodule