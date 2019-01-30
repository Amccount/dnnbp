
module update_tb();	

// parameters
parameter WIDTH = 24;
parameter FRAC = 20;
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

// States
parameter S0 = 3'h0, S1 = 3'h1, S2 = 3'h2, S3 = 3'h3, S4 = 3'h4; 
reg [2:0] STATE;

// common ports
reg clk, rst, rst_fsm;
reg bp, update;


// control ports
reg wr_wa_1;
reg wr_wi_1;
reg wr_wf_1;
reg wr_wo_1;
reg wr_ua_1;
reg wr_ui_1;
reg wr_uf_1;
reg wr_uo_1;
reg wr_ba_1;
reg wr_bi_1;
reg wr_bf_1;
reg wr_bo_1;
reg wr_wa_2;
reg wr_wi_2;
reg wr_wf_2;
reg wr_wo_2;
reg wr_ua_2;
reg wr_ui_2;
reg wr_uf_2;
reg wr_uo_2;
reg wr_bo_2;
reg wr_ba_2;
reg wr_bi_2;
reg wr_bf_2;

reg en_x1;
reg en_x2;
reg en_h1;
reg en_h2;

reg en_w1;
reg en_w2;
reg en_u1;
reg en_u2;
reg en_b1;
reg en_b2;


// Wires

// Layer 1 addresses
wire [ADDR_WIDTH-1:0] wr_addr_a_d1;
wire [ADDR_WIDTH-1:0] rd_addr_b_d1;
wire [ADDR_WIDTH-1:0] wr_addr_a_w1;
wire [ADDR_WIDTH-1:0] wr_addr_a_u1;
wire [ADDR_WIDTH-1:0] wr_addr_a_b1;
wire [ADDR_WIDTH-1:0] rd_addr_b_x1;
wire [ADDR_WIDTH-1:0] rd_addr_b_h1;


// Layer 2 addresses
wire [ADDR_WIDTH-1:0] wr_addr_a_d2;
wire [ADDR_WIDTH-1:0] rd_addr_b_d2;
wire [ADDR_WIDTH-1:0] wr_addr_a_w2;
wire [ADDR_WIDTH-1:0] wr_addr_a_u2;
wire [ADDR_WIDTH-1:0] wr_addr_a_b2;
wire [ADDR_WIDTH-1:0] rd_addr_b_x2;
wire [ADDR_WIDTH-1:0] rd_addr_b_h2;

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
		.rst      (rst),
		.en       (en_x1),
		.o_addr_d (wr_addr_a_d1),
		.o_addr_x (rd_addr_b_x1)
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
		.rst      (rst),
		.en       (en_x2),
		.o_addr_d (wr_addr_a_d2),
		.o_addr_x (rd_addr_b_x2)
	);

// Address generator dgates . H = dU
// Layer 1
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.DELAY(3)
	) inst_upd_xhd_h1 (
		.clk      (clk),
		.rst      (rst),
		.en       (en_h1),
		.o_addr_d (rd_addr_b_d1),
		.o_addr_x (rd_addr_b_h1)
	);
// Layer 2
addr_gen_upd_xhd #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.TIMESTEP(TIMESTEP),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.DELAY(3)
	) inst_upd_xhd_h2 (
		.clk      (clk),
		.rst      (rst),
		.en       (en_h2),
		.o_addr_d (rd_addr_b_d2),
		.o_addr_x (rd_addr_b_h2)
	);

// Address generator write update W
// Layer 1
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR1_CELL),
		.NUM_INPUT(LAYR1_INPUT),
		.TIMESTEP(TIMESTEP),
		.DELAY(3)
	) inst_upd_wub_w1 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_w1),
		.o_addr (wr_addr_a_w1)
	);

// Layer 2
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(3)
	) inst_upd_wub_w2 (
		.clk    (clk),
		.rst    (rst),
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
		.DELAY(3)
	) inst_upd_wub_u1 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_u1),
		.o_addr (wr_addr_a_u1)
	);


// Layer 2

addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(3)
	) inst_upd_wub_u2 (
		.clk    (clk),
		.rst    (rst),
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
		.DELAY(3)
	) inst_upd_wub_b1 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_b1),
		.o_addr (wr_addr_a_b1)
	);

// Layer 2
addr_gen_upd_wub #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.NUM_CELL(LAYR2_CELL),
		.NUM_INPUT(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.DELAY(3)
	) inst_upd_wub_b2 (
		.clk    (clk),
		.rst    (rst),
		.en     (en_b2),
		.o_addr (wr_addr_a_b2)
	);

datapath #(
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
		.LAYR2_T(),
		.LAYR1_dOut(LAYR1_dOut),
		.LAYR1_dState(LAYR1_dState),
		.LAYR2_dOut(LAYR2_dOut),
		.LAYR2_dState(LAYR2_dState)
	) inst_datapath (
		.clk                (clk),
		.rst                (rst),
		.wr_h1              (),
		.wr_c1              (),
		.wr_wa_1            (wr_wa_1),
		.wr_wi_1            (wr_wi_1),
		.wr_wf_1            (wr_wf_1),
		.wr_wo_1            (wr_wo_1),
		.wr_ua_1            (wr_ua_1),
		.wr_ui_1            (wr_ui_1),
		.wr_uf_1            (wr_uf_1),
		.wr_uo_1            (wr_uo_1),
		.wr_ba_1            (wr_ba_1),
		.wr_bi_1            (wr_bi_1),
		.wr_bf_1            (wr_bf_1),
		.wr_bo_1            (wr_bo_1),
		.wr_addr_a_h1       (),
		.wr_addr_a_c1       (),
		.wr_addr_a_wa_1     (wr_addr_a_w1),
		.wr_addr_a_wi_1     (wr_addr_a_w1),
		.wr_addr_a_wf_1     (wr_addr_a_w1),
		.wr_addr_a_wo_1     (wr_addr_a_w1),
		.wr_addr_a_ua_1     (wr_addr_a_u1),
		.wr_addr_a_ui_1     (wr_addr_a_u1),
		.wr_addr_a_uf_1     (wr_addr_a_u1),
		.wr_addr_a_uo_1     (wr_addr_a_u1),
		.wr_addr_a_ba_1     (wr_addr_a_b1),
		.wr_addr_a_bi_1     (wr_addr_a_b1),
		.wr_addr_a_bf_1     (wr_addr_a_b1),
		.wr_addr_a_bo_1     (wr_addr_a_b1),
		.rd_addr_b_x1       (rd_addr_b_x1),
		.rd_addr_b_h1       (rd_addr_b_h1),
		.rd_addr_b_c1       (),
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
		.acc_x1             (),
		.acc_h1             (),
		.wr_act_1           (),
		.wr_addr_a_act_1    (),
		.rd_addr_b_a1       (),
		.rd_addr_b_f1       (),
		.rd_addr_b_i1       (),
		.rd_addr_b_o1       (),
		.wr_h2              (),
		.wr_c2              (),
		.wr_wa_2            (wr_wa_2),
		.wr_wi_2            (wr_wi_2),
		.wr_wf_2            (wr_wf_2),
		.wr_wo_2            (wr_wo_2),
		.wr_ua_2            (wr_ua_2),
		.wr_ui_2            (wr_ui_2),
		.wr_uf_2            (wr_uf_2),
		.wr_uo_2            (wr_uo_2),
		.wr_ba_2            (wr_ba_2),
		.wr_bi_2            (wr_bi_2),
		.wr_bf_2            (wr_bf_2),
		.wr_bo_2            (wr_bo_2),
		.wr_addr_a_h2       (),
		.wr_addr_a_c2       (),
		.wr_addr_a_wa_2     (wr_addr_a_w2),
		.wr_addr_a_wi_2     (wr_addr_a_w2),
		.wr_addr_a_wf_2     (wr_addr_a_w2),
		.wr_addr_a_wo_2     (wr_addr_a_w2),
		.wr_addr_a_ua_2     (wr_addr_a_u2),
		.wr_addr_a_ui_2     (wr_addr_a_u2),
		.wr_addr_a_uf_2     (wr_addr_a_u2),
		.wr_addr_a_uo_2     (wr_addr_a_u2),
		.wr_addr_a_ba_2     (wr_addr_a_b2),
		.wr_addr_a_bi_2     (wr_addr_a_b2),
		.wr_addr_a_bf_2     (wr_addr_a_b2),
		.wr_addr_a_bo_2     (wr_addr_a_b2),
		.rd_addr_b_x2       (rd_addr_b_x2),
		.rd_addr_b_h2       (rd_addr_b_h2),
		.rd_addr_b_c2       (),
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
		.acc_x2             (),
		.acc_h2             (),
		.wr_act_2           (),
		.wr_addr_a_act_2    (),
		.rd_addr_b_a2       (),
		.rd_addr_b_f2       (),
		.rd_addr_b_i2       (),
		.rd_addr_b_o2       (),
		.wr_t2              (),
		.wr_addr_a_t2       (),
		.rd_addr_b_t2       (),
		.wr_dout_2          (),
		.wr_dstate_2        (),
		.wr_addr_a_dout_2   (),
		.wr_addr_a_dstate_2 (),
		.rd_addr_b_dout_2   (),
		.rd_addr_b_dstate_2 (),
		.sel_in1_2          (),
		.sel_in2_2          (),
		.sel_in3_2          (),
		.sel_in4_2          (),
		.sel_in5_2          (),
		.sel_x1_1_2         (),
		.sel_x1_2_2         (),
		.sel_x2_2_2         (),
		.sel_as_1_2         (),
		.sel_as_2_2         (),
		.sel_addsub_2       (),
		.sel_temp_2         (),
		.wr_da2             (),
		.wr_di2             (),
		.wr_df2             (),
		.wr_do2             (),
		.wr_addr_a_da2      (wr_addr_a_d2),
		.wr_addr_a_di2      (wr_addr_a_d2),
		.wr_addr_a_df2      (wr_addr_a_d2),
		.wr_addr_a_do2      (wr_addr_a_d2),
		.rd_addr_b_da2      (rd_addr_b_d2),
		.rd_addr_b_di2      (rd_addr_b_d2),
		.rd_addr_b_df2      (rd_addr_b_d2),
		.rd_addr_b_do2      (rd_addr_b_d2),
		.wr_dx2             (),
		.wr_addr_a_dx2      (),
		.rd_addr_b_dx2      (),
		.wr_dout_1          (),
		.wr_dstate_1        (),
		.wr_addr_a_dout_1   (),
		.wr_addr_a_dstate_1 (),
		.rd_addr_b_dout_1   (),
		.rd_addr_b_dstate_1 (),
		.sel_in1_1          (),
		.sel_in2_1          (),
		.sel_in3_1          (),
		.sel_in4_1          (),
		.sel_in5_1          (),
		.sel_x1_1_1         (),
		.sel_x1_2_1         (),
		.sel_x2_2_1         (),
		.sel_as_1_1         (),
		.sel_as_2_1         (),
		.sel_addsub_1       (),
		.sel_temp_1         (),
		.wr_da1             (),
		.wr_di1             (),
		.wr_df1             (),
		.wr_do1             (),
		.wr_addr_a_da1      (wr_addr_a_d1),
		.wr_addr_a_di1      (wr_addr_a_d1),
		.wr_addr_a_df1      (wr_addr_a_d1),
		.wr_addr_a_do1      (wr_addr_a_d1),
		.rd_addr_b_da1      (rd_addr_b_d1),
		.rd_addr_b_di1      (rd_addr_b_d1),
		.rd_addr_b_df1      (rd_addr_b_d1),
		.rd_addr_b_do1      (rd_addr_b_d1),
		.rst_cost           (),
		.acc_cost           (),
		.o_cost             ()
	);


always @(posedge clk or posedge rst_fsm)
begin
	if (rst_fsm) begin
		STATE <= S0;
	end
	else
	begin
		case (STATE)
			S0:
				begin
					STATE <= S1;
				end
			S1:
				begin
					if (count != TIMESTEP-1)
					begin
						count <= count + 1;
					end
					else
					begin
						count <= 0;
						STATE <= S2;
					end
				end
			S2:
				begin
					STATE <= S3;
				end
			S3:
				begin
					STATE <= S4;
				end
			S4:
				begin
					STATE <= S1;
				end
		endcase
	end
end

always @(STATE)
begin
	case (STATE)
		S0: begin
				rst     <= 1;
				en_x1   <= 0;
				en_x2   <= 0;
				en_h1   <= 0;
				en_h2   <= 0;
				en_w1   <= 0;
				en_w2   <= 0;
				en_u1   <= 0;
				en_u2   <= 0;
				en_b1   <= 0;
				en_b2   <= 0;
				bp	    <= 0;
				update  <= 0;
				wr_wa_1 <= 0;
				wr_wi_1 <= 0;
				wr_wf_1 <= 0;
				wr_wo_1 <= 0;
				wr_ua_1 <= 0;
				wr_ui_1 <= 0;
				wr_uf_1 <= 0;
				wr_uo_1 <= 0;
				wr_ba_1 <= 0;
				wr_bi_1 <= 0;
				wr_bf_1 <= 0;
				wr_bo_1 <= 0;
				wr_wa_2 <= 0;
				wr_wi_2 <= 0;
				wr_wf_2 <= 0;
				wr_wo_2 <= 0;
				wr_ua_2 <= 0;
				wr_ui_2 <= 0;
				wr_uf_2 <= 0;
				wr_uo_2 <= 0;
				wr_bo_2 <= 0;
				wr_ba_2 <= 0;
				wr_bf_2 <= 0;
				wr_bi_2 <= 0;
			end
		S1: begin 
				rst     <= 0;
				en_x1   <= 1;
				en_x2   <= 1;
				en_h1   <= 1;
				en_h2   <= 1;
				en_w1   <= 1;
				en_w2   <= 1;
				en_u1   <= 1;
				en_u2   <= 1;
				en_b1   <= 1;
				en_b2   <= 1;
				bp	    <= 0;
				update  <= 1;
				wr_wa_1 <= 0;
				wr_wi_1 <= 0;
				wr_wf_1 <= 0;
				wr_wo_1 <= 0;
				wr_ua_1 <= 0;
				wr_ui_1 <= 0;
				wr_uf_1 <= 0;
				wr_uo_1 <= 0;
				wr_ba_1 <= 0;
				wr_bi_1 <= 0;
				wr_bf_1 <= 0;
				wr_bo_1 <= 0;
				wr_wa_2 <= 0;
				wr_wi_2 <= 0;
				wr_wf_2 <= 0;
				wr_wo_2 <= 0;
				wr_ua_2 <= 0;
				wr_ui_2 <= 0;
				wr_uf_2 <= 0;
				wr_uo_2 <= 0;
				wr_bo_2 <= 0;
				wr_ba_2 <= 0;
				wr_bf_2 <= 0;
				wr_bi_2 <= 0;
			end
		S2: begin 
				rst     <= 0;
				en_x1   <= 1;
				en_x2   <= 1;
				en_h1   <= 1;
				en_h2   <= 1;
				en_w1   <= 1;
				en_w2   <= 1;
				en_u1   <= 1;
				en_u2   <= 1;
				en_b1   <= 1;
				en_b2   <= 1;
				bp	    <= 0;
				update  <= 1;
				wr_wa_1 <= 1;
				wr_wi_1 <= 1;
				wr_wf_1 <= 1;
				wr_wo_1 <= 1;
				wr_ua_1 <= 1;
				wr_ui_1 <= 1;
				wr_uf_1 <= 1;
				wr_uo_1 <= 1;
				wr_ba_1 <= 1;
				wr_bi_1 <= 1;
				wr_bf_1 <= 1;
				wr_bo_1 <= 1;
				wr_wa_2 <= 1;
				wr_wi_2 <= 1;
				wr_wf_2 <= 1;
				wr_wo_2 <= 1;
				wr_ua_2 <= 1;
				wr_ui_2 <= 1;
				wr_uf_2 <= 1;
				wr_uo_2 <= 1;
				wr_bo_2 <= 1;
				wr_ba_2 <= 1;
				wr_bf_2 <= 1;
				wr_bi_2 <= 1;
			end
		S3: begin
				rst     <= 0;
				en_x1   <= 1;
				en_x2   <= 1;
				en_h1   <= 1;
				en_h2   <= 1;
				en_w1   <= 1;
				en_w2   <= 1;
				en_u1   <= 1;
				en_u2   <= 1;
				en_b1   <= 1;
				en_b2   <= 1;
				bp	    <= 0;
				update  <= 1;
				wr_wa_1 <= 0;
				wr_wi_1 <= 0;
				wr_wf_1 <= 0;
				wr_wo_1 <= 0;
				wr_ua_1 <= 0;
				wr_ui_1 <= 0;
				wr_uf_1 <= 0;
				wr_uo_1 <= 0;
				wr_ba_1 <= 0;
				wr_bi_1 <= 0;
				wr_bf_1 <= 0;
				wr_bo_1 <= 0;
				wr_wa_2 <= 0;
				wr_wi_2 <= 0;
				wr_wf_2 <= 0;
				wr_wo_2 <= 0;
				wr_ua_2 <= 0;
				wr_ui_2 <= 0;
				wr_uf_2 <= 0;
				wr_uo_2 <= 0;
				wr_bo_2 <= 0;
				wr_ba_2 <= 0;
				wr_bf_2 <= 0;
				wr_bi_2 <= 0;
			end
		S4: begin
				rst     <= 0;
				en_x1   <= 1;
				en_x2   <= 1;
				en_h1   <= 1;
				en_h2   <= 1;
				en_w1   <= 1;
				en_w2   <= 1;
				en_u1   <= 1;
				en_u2   <= 1;
				en_b1   <= 1;
				en_b2   <= 1;
				bp	    <= 0;
				update  <= 1;
				wr_wa_1 <= 0;
				wr_wi_1 <= 0;
				wr_wf_1 <= 0;
				wr_wo_1 <= 0;
				wr_ua_1 <= 0;
				wr_ui_1 <= 0;
				wr_uf_1 <= 0;
				wr_uo_1 <= 0;
				wr_ba_1 <= 0;
				wr_bi_1 <= 0;
				wr_bf_1 <= 0;
				wr_bo_1 <= 0;
				wr_wa_2 <= 0;
				wr_wi_2 <= 0;
				wr_wf_2 <= 0;
				wr_wo_2 <= 0;
				wr_ua_2 <= 0;
				wr_ui_2 <= 0;
				wr_uf_2 <= 0;
				wr_uo_2 <= 0;
				wr_bo_2 <= 0;
				wr_ba_2 <= 0;
				wr_bf_2 <= 0;
				wr_bi_2 <= 0;
			end
	endcase
end

initial
begin
	clk = 1;
	rst_fsm <= 1;
	#100;
	rst_fsm <= 0;
end

always
begin
	#50; clk <= !clk;
end

endmodule