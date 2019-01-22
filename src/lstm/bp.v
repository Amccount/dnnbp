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

module bp ( clk, rst, i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state,
            i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t,
            i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo,
            i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo,
            i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo,
            i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo,
            i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo,
            i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo);

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

// This holds d gates
parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";

// common ports
input clk, rst;

// input ports
input signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state, i_layr1_d_state;
input signed [WIDTH-1:0] i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_d_state, i_layr2_h, i_layr2_t;

input signed [WIDTH-1:0] i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo;
input signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;
input signed [WIDTH-1:0] i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo;
input signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
input signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;
input signed [WIDTH-1:0] i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo;

// control ports
input sel_layr1_in1;
input sel_layr1_in2;
input sel_layr1_in3;
input sel_layr1_in4;
input sel_layr1_in5;
input sel_layr1_x1_1;
input sel_layr1_x1_2;
input sel_layr1_x2_2;
input sel_layr1_as_1;
input sel_layr1_as_2;
input sel_layr1_addsub;
input sel_layr1_temp;

input sel_layr2_in1;
input sel_layr2_in2;
input sel_layr2_in3;
input sel_layr2_in4;
input sel_layr2_in5;
input sel_layr2_x1_1;
input sel_layr2_x1_2;
input sel_layr2_x2_2;
input sel_layr2_as_1;
input sel_layr2_as_2;
input sel_layr2_addsub;
input sel_layr2_temp;

// output ports


// registers


// wires
wire signed [WIDTH-1:0] wr_da2, wr_di2, wr_df2, wr_do2;
wire signed [WIDTH-1:0] rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
wire signed [WIDTH-1:0] wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

wire signed [WIDTH-1:0] wr_da1, wr_di1, wr_df1, wr_do1;
wire signed [WIDTH-1:0] rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
wire signed [WIDTH-1:0] wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

wire signed [WIDTH-1:0] da1, di1, df1, do1, da2, di2, df2, do2;


// LAYER 2 Delta
// in: i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t
// out: odgate
delta #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) layr2_delta (
        .clk        (clk),
        .rst        (rst),
        .sel_in1    (sel_layr2_in1),
        .sel_in2    (sel_layr2_in2),
        .sel_in3    (sel_layr2_in3),
        .sel_in4    (sel_layr2_in4),
        .sel_in5    (sel_layr2_in5),
        .sel_x1_1   (sel_layr2_x1_1),
        .sel_x1_2   (sel_layr2_x1_2),
        .sel_x2_2   (sel_layr2_x2_2),
        .sel_as_1   (sel_layr2_as_1),
        .sel_as_2   (sel_layr2_as_2),
        .sel_addsub (sel_layr2_addsub),
        .sel_temp   (sel_layr2_temp),
        .at         (i_layr2_a),
        .it         (i_layr2_i),
        .ft         (i_layr2_f),
        .ot         (i_layr2_o),
        .h          (),
        .t          (),
        .state      (i_layr2_state),
        .d_state    (i_layr2_d_state),
        .d_out      (),
        .o_dgate    (dgate_layr2)
    );


// LAYER 2 dA, dI, dF, dO Memory
// out: da2, di2, df2, do2
memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR2_dA)
    ) mem_da2 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_da2),
        .rd_addr (rd_addr_da2),
        .wr_addr (wr_addr_da2),
        .i       (dgate_layr2),
        .o       (da2)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR2_dI)
    ) mem_di2 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_di2),
        .rd_addr (rd_addr_di2),
        .wr_addr (wr_addr_di2),
        .i       (dgate_layr2),
        .o       (di2)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR2_dF)
    ) mem_df2 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_df2),
        .rd_addr (rd_addr_df2),
        .wr_addr (wr_addr_df2),
        .i       (dgate_layr2),
        .o       (df2)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR2_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR2_dO)
    ) mem_do2 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_do2),
        .rd_addr (rd_addr_do2),
        .wr_addr (wr_addr_do2),
        .i       (dgate_layr2),
        .o       (do2)
    );

// LAYER 2 ACC Array for dX and delta Out
// in: da, di, df, do
// out: dx, delta Out


// LAYER 2 Multiplexer
// in: dgates memory
// out: da/di/df/do


// LAYER 2 MAC
// in: dgate
// out: dX/delta Out


// LAYER 2 dX Memory
// in: acc_o


// LAYER 2 delta Out Memory
// in: acc_o


// LAYER 1 Delta
// in: i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
// out: odgate
delta #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) layr1_delta (
        .clk        (clk),
        .rst        (rst),
        .sel_in1    (sel_layr1_in1),
        .sel_in2    (sel_layr1_in2),
        .sel_in3    (sel_layr1_in3),
        .sel_in4    (sel_layr1_in4),
        .sel_in5    (sel_layr1_in5),
        .sel_x1_1   (sel_layr1_x1_1),
        .sel_x1_2   (sel_layr1_x1_2),
        .sel_x2_2   (sel_layr1_x2_2),
        .sel_as_1   (sel_layr1_as_1),
        .sel_as_2   (sel_layr1_as_2),
        .sel_addsub (sel_layr1_addsub),
        .sel_temp   (sel_layr1_temp),
        .at         (i_layr1_a),
        .it         (i_layr1_i),
        .ft         (i_layr1_f),
        .ot         (i_layr1_o),
        .h          (),
        .t          (),
        .state      (i_layr1_state),
        .d_state    (i_layr1_d_state),
        .d_out      (),
        .o_dgate    (dgate_layr1)
    );

// LAYER 1 dA, dI, dF, dO Memory
// in: addr, wr, odgate
// out: da, di, df, do
memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR1_dA)
    ) mem_da1 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_da1),
        .rd_addr (rd_addr_da1),
        .wr_addr (wr_addr_da1),
        .i       (dgate_layr1),
        .o       (da1)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR1_dI)
    ) mem_di1 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_di1),
        .rd_addr (rd_addr_di1),
        .wr_addr (wr_addr_di1),
        .i       (dgate_layr1),
        .o       (di1)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR1_dF)
    ) mem_df1 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_df1),
        .rd_addr (rd_addr_df1),
        .wr_addr (wr_addr_df1),
        .i       (dgate_layr1),
        .o       (df1)
    );

memory_dgates #(
        .WIDTH(WIDTH),
        .NUM_LSTM(LAYR1_CELL),
        .TIMESTEP(TIMESTEP),
        .FILENAME(LAYR1_dO)
    ) mem_do1 (
        .clk     (clk),
        .rst     (rst),
        .wr      (wr_do1),
        .rd_addr (rd_addr_do1),
        .wr_addr (wr_addr_do1),
        .i       (dgate_layr1),
        .o       (do1)
    );


// LAYER 1 ACC Array
// in: dgates memory
// out: da/di/df/do


// LAYER 1 Multiplexer
// in: dgates memory
// out: da/di/df/do


// LAYER 1 MAC
// in: dgate
// out: dX/delta Out


// LAYER 1 delta Out Memory
// in: delta Out
// out: reg delta Out


endmodule