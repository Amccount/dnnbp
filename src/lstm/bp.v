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
            i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo,
            sel_layr1_in1, sel_layr1_in2, sel_layr1_in3, sel_layr1_in4, sel_layr1_in5,
            sel_layr2_in1, sel_layr2_in2, sel_layr2_in3, sel_layr2_in4, sel_layr2_in5,
            sel_layr1_x1_1, sel_layr1_x1_2, sel_layr1_x2_2, sel_layr1_as_1, sel_layr1_as_2, 
            sel_layr2_x1_1, sel_layr2_x1_2, sel_layr2_x2_2, sel_layr2_as_1, sel_layr2_as_2,
            sel_layr1_addsub, sel_layr2_addsub, sel_layr1_temp, sel_layr2_temp,
            acc_da1, acc_di1, acc_df1, acc_do1, 
            acc_da2, acc_di2, acc_df2, acc_do2,
            acc_mac1, acc_mac2,
            wr_da1, wr_di1, wr_df1, wr_do1,
            wr_da2, wr_di2, wr_df2, wr_do2,
            wr_dx2, wr_dout2, wr_dout1,
            rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1,
            wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1,
            rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2,
            wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2,
            rd_addr_dx2, rd_addr_dout2, rd_addr_dout1,
            wr_addr_dx2, wr_addr_dout2, wr_addr_dout1,
            load_d_state1, load_d_state2,
            sel_dgate1, sel_dgate2,
            sel_wghts1, sel_wghts2
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

// This holds d gates
parameter LAYR2_dA = "layer2_dA.list";
parameter LAYR2_dI = "layer2_dI.list";
parameter LAYR2_dF = "layer2_dF.list";
parameter LAYR2_dO = "layer2_dO.list";
parameter LAYR2_dX = "layer2_dX.list";
parameter LAYR2_dOut = "layer2_dOut.list";

// common ports
input clk, rst;

// input ports
input signed [WIDTH-1:0] i_layr1_a, i_layr1_i, i_layr1_f, i_layr1_o, i_layr1_state;
input signed [WIDTH-1:0] i_layr2_a, i_layr2_i, i_layr2_f, i_layr2_o, i_layr2_state, i_layr2_h, i_layr2_t;

input signed [WIDTH-1:0] i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo;
input signed [WIDTH-1:0] i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo;
input signed [WIDTH-1:0] i_layr1_ba, i_layr1_bi, i_layr1_bf, i_layr1_bo;
input signed [WIDTH-1:0] i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo;
input signed [WIDTH-1:0] i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo;
input signed [WIDTH-1:0] i_layr2_ba, i_layr2_bi, i_layr2_bf, i_layr2_bo;

// control ports
input sel_layr1_in1, sel_layr2_in1;
input sel_layr1_in2, sel_layr2_in2;
input sel_layr1_in3, sel_layr2_in3;
input sel_layr1_in4, sel_layr2_in4;
input sel_layr1_in5, sel_layr2_in5;
input sel_layr1_x1_1, sel_layr2_x1_1;
input sel_layr1_x1_2, sel_layr2_x1_2;
input sel_layr1_x2_2, sel_layr2_x2_2;
input sel_layr1_as_1, sel_layr2_as_1;
input sel_layr1_as_2, sel_layr2_as_2;
input sel_layr1_addsub, sel_layr2_addsub;
input sel_layr1_temp, sel_layr2_temp;

input acc_da1, acc_di1, acc_df1, acc_do1;
input acc_da2, acc_di2, acc_df2, acc_do2;
input acc_mac1, acc_mac2;

input load_d_state1, load_d_state2;

input [1:0] sel_dgate1, sel_dgate2;
input [2:0] sel_wghts1, sel_wghts2;


input [WIDTH-1:0] wr_da1, wr_di1, wr_df1, wr_do1;
input [WIDTH-1:0] rd_addr_da1, rd_addr_di1, rd_addr_df1, rd_addr_do1;
input [WIDTH-1:0] wr_addr_da1, wr_addr_di1, wr_addr_df1, wr_addr_do1;

input [WIDTH-1:0] wr_da2, wr_di2, wr_df2, wr_do2;
input [WIDTH-1:0] rd_addr_da2, rd_addr_di2, rd_addr_df2, rd_addr_do2;
input [WIDTH-1:0] wr_addr_da2, wr_addr_di2, wr_addr_df2, wr_addr_do2;

input [WIDTH-1:0] wr_dx2, wr_dout2, wr_dout1;
input [WIDTH-1:0] rd_addr_dx2, rd_addr_dout2, rd_addr_dout1;
input [WIDTH-1:0] wr_addr_dx2, wr_addr_dout2, wr_addr_dout1;
// output ports


// registers
reg signed [WIDTH-1:0] reg_d_state1, reg_d_state2;


// wires
wire signed [WIDTH-1:0] layr1_d_state, layr2_d_state;
wire signed [WIDTH-1:0] dgate_layr1, dgate_layr2;
wire signed [WIDTH-1:0] da1, di1, df1, do1, da2, di2, df2, do2;

wire signed [WIDTH-1:0] o_acc_da1, o_acc_di1, o_acc_df1, o_acc_do1;
wire signed [WIDTH-1:0] o_acc_da2, o_acc_di2, o_acc_df2, o_acc_do2;

wire signed [WIDTH-1:0] dgate_mux1, dgate_mux2;
wire signed [WIDTH-1:0] wghts_mux1, wghts_mux2;
wire signed [WIDTH-1:0] o_mac1, o_mac2;

wire signed [WIDTH-1:0] dx2, dout1, dout2;

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
        .d_state    (reg_d_state2),
        .d_out      (),
        .o_dgate    (dgate_layr2),
        .o_d_state  (layr2_d_state)
    );

// LAYER 2 delta State Delay Register
always @(posedge clk or posedge rst)
begin
    if (rst) 
        reg_d_state2 = {WIDTH{1'b0}};
    else
    begin
        if (load_d_state2)
            reg_d_state2 = layr2_d_state;
    end
end

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
        .i_a    (dgate_layr2),
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
        .i_a    (dgate_layr2),
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
        .i_a    (dgate_layr2),
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
        .i_a    (dgate_layr2),
        .o_a    (),
        .o_b    (do2)
    );


// LAYER 2 ACC Array for dX and delta Out
// in: da, di, df, do
// out: dx, delta Out
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_da_2 (.clk(clk), .rst(rst), .acc(acc_da2), .i(dgate_layr2), .o(o_acc_da2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_di_2 (.clk(clk), .rst(rst), .acc(acc_di2), .i(dgate_layr2), .o(o_acc_di2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_df_2 (.clk(clk), .rst(rst), .acc(acc_df2), .i(dgate_layr2), .o(o_acc_df2));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_do_2 (.clk(clk), .rst(rst), .acc(acc_do2), .i(dgate_layr2), .o(o_acc_do2));

// LAYER 2 dgates Multiplexer
// in: o_acc_da2, o_acc_di2, o_acc_df2, o_acc_do2
// out: dgate_mux2
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_x2 (.i_a(o_acc_da2), .i_b(o_acc_di2), .i_c(o_acc_df2), .i_d(o_acc_do2), .sel(sel_dgate2), .o(dgate_mux2));

// LAYER 2 W & U Memory Multiplexer
// in: i_layr2_wa, i_layr2_wi, i_layr2_wf, i_layr2_wo,i_layr2_ua, i_layr2_ui, i_layr2_uf, i_layr2_uo
// out: wghts_mux2
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout2_1 (.i_a(i_layr2_wa), .i_b(i_layr2_wi), .i_c(i_layr2_wf), .i_d(i_layr2_wo), .sel(sel_wghts2[1:0]), .o(layr2_w));
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout2_2 (.i_a(i_layr2_ua), .i_b(i_layr2_ui), .i_c(i_layr2_uf), .i_d(i_layr2_uo), .sel(sel_wghts2[1:0]), .o(layr2_u));
assign wghts_mux2 = sel_wghts2[2] ? layr2_u : layr2_w;

// LAYER 2 MAC
// in: dgate
// out: dX/delta Out
mac #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) mac2 (
        .clk (clk),
        .rst (rst),
        .acc (acc_mac2),
        .i_x (dgate_mux2),
        .i_m (wghts_mux2),
        .o   (o_mac2)
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
        .i_a    (o_mac2),
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
        .i_a    (o_mac2),
        .o_a    (),
        .o_b    (dout2)
    );

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
        .d_state    (),
        .d_out      (),
        .o_dgate    (dgate_layr1),
        .o_d_state  (layr1_d_state)
    );

// LAYER 1 delta State Delay Register
always @(posedge clk or posedge rst)
begin
    if (rst) 
        reg_d_state1 = {WIDTH{1'b0}};
    else
    begin
        if (load_d_state1)
            reg_d_state1 = layr1_d_state;
    end
end

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
        .i_a    (dgate_layr1),
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
        .i_a    (dgate_layr1),
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
        .i_a    (dgate_layr1),
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
        .i_a    (dgate_layr1),
        .o_a    (),
        .o_b    (do1)
    );

// LAYER 1 ACC Array
// in: dgates memory
// out: da/di/df/do
// input acc_da1, acc_di1, acc_df1, acc_do1;
// wire signed [WIDTH-1:0] o_acc_da1, o_acc_di1, o_acc_df1, o_acc_do1;
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_da_1 (.clk(clk), .rst(rst), .acc(acc_da1), .i(dgate_layr1), .o(o_acc_da1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_di_1 (.clk(clk), .rst(rst), .acc(acc_di1), .i(dgate_layr1), .o(o_acc_di1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_df_1 (.clk(clk), .rst(rst), .acc(acc_df1), .i(dgate_layr1), .o(o_acc_df1));
acc #(.WIDTH(WIDTH), .FRAC(FRAC)) acc_do_1 (.clk(clk), .rst(rst), .acc(acc_do1), .i(dgate_layr1), .o(o_acc_do1));


// LAYER 1 dgates Multiplexer
// in: o_acc_da1, o_acc_di1, o_acc_df1, o_acc_do1
// out: dgate_mux1
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_x1 (.i_a(o_acc_da1), .i_b(o_acc_di1), .i_c(o_acc_df1), .i_d(o_acc_do1), .sel(sel_dgate1), .o(dgate_mux1));


// LAYER 1 U Memory Multiplexer
// in: i_layr1_wa, i_layr1_wi, i_layr1_wf, i_layr1_wo,i_layr1_ua, i_layr1_ui, i_layr1_uf, i_layr1_uo
// out: wghts_mux1
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout1_1 (.i_a(i_layr1_wa), .i_b(i_layr1_wi), .i_c(i_layr1_wf), .i_d(i_layr1_wo), .sel(sel_wghts1[1:0]), .o(layr1_w));
multiplexer_4to1 #(.WIDTH(WIDTH)) mux_dout1_2 (.i_a(i_layr1_ua), .i_b(i_layr1_ui), .i_c(i_layr1_uf), .i_d(i_layr1_uo), .sel(sel_wghts1[1:0]), .o(layr1_u));
assign wghts_mux1 = sel_wghts1[2] ? layr1_u : layr1_w;


// LAYER 1 MAC
// in: dgate
// out: dX/delta Out
mac #(
        .WIDTH(WIDTH),
        .FRAC(FRAC)
    ) mac1 (
        .clk (clk),
        .rst (rst),
        .acc (acc_mac1),
        .i_x (dgate_mux1),
        .i_m (wghts_mux1),
        .o   (o_mac1)
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
        .i_a    (o_mac1),
        .o_a    (),
        .o_b    (dout1)
    );

endmodule