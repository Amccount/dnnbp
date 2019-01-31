
module top_level (clk, rst_fsm, h2);


parameter ADDR_WIDTH = 12;
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
parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9,  
S10=10, S11=11, S12=12, S13=13, S14=14, S15=15, S16=16, S17=17, S18=18, 
S19=19, S20=20, S21=21, S22=22, S23=23, S24=24, S25=25, S26=26, S27=27, 
S28=28, S29=29, S30=30, S31=31, S32=32, S33=33, S34=34, S35=35, S36=36, 
S37=37, S38=38, S39=39, S40=40, S41=41, S42=42, S43=43, S44=44, S45=45, 
S46=46, S47=47, S48=48, S49=49, S50=50, S51=51, S52=52, S53=53, S54=54, 
S55=55, S56=56, S57=57, S58=58, S59=59, S60=60, S61=61, S62=62, S63=63, 
S64=64, S65=65, S66=66, S67=67, S68=68, S69=69, S70=70, S71=71, S72=72, 
S73=73, S74=74, S75=75, S76=76, S77=77, S78=78, S79=79, S80=80, S81=81, 
S82=82, S83=83, S84=84, S85=85, S86=86;


//common ports
input clk, rst_fsm;

wire en_1, en_2, en_h_x, en_addr_dgate_2, en_addr_w_bp_2, rst, rst_addr_dgates, rst_2, rst_acc, rst_mac, rst_bias_1, rst_bias_2;
output [WIDTH-1:0] h2;

//output ports
wire acc_x_1, acc_h_1, acc_x_2, acc_h_2;
wire wr_h1;
wire wr_c1;
wire wr_act_1;
wire wr_act_2;
wire wr_h2;
wire wr_c2;
wire sel_a;
wire sel_i;
wire sel_f;
wire sel_o;
wire sel_h;
wire sel_t;
wire sel_state;
wire sel_dstate;
wire sel_dout;
wire [1:0] sel_in1;
wire [1:0] sel_in2;
wire sel_in3;
wire [1:0] sel_in4;
wire [2:0] sel_in5;
wire [1:0] sel_x1_1;
wire sel_x1_2;
wire [1:0] sel_x2_2;
wire sel_as_1;
wire [1:0] sel_as_2;
wire sel_addsub;
wire [1:0] sel_temp;

wire acc_da, acc_di, acc_df, acc_do;
wire acc_mac;
 
wire [1:0] sel_dgate;

wire sel_wght;
wire [1:0] sel_wghts1;
wire [2:0] sel_wghts2;
wire wr_da1, wr_di1, wr_df1, wr_do1, wr_dstate1;

wire wr_da2, wr_di2, wr_df2, wr_do2, wr_dstate2;

wire wr_dx2, wr_dout2, wr_dout1;

wire signed [11:0] addr_x1;

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
 

	// addr_gen_c #(
	// 		.ADDR_WIDTH(ADDR_WIDTH),
	// 		.TIMESTEP(7),
	// 		.NUM_CELL(53),
	// 		.NUM_INPUT(52),
	// 		.DELAY(4)
	// 	) inst_addr_gen_x (
	// 		.clk      (clk),
	// 		.rst      (rst),
	// 		.en       (en),
	// 		.o_addr_h (addr_x1),
	// 		.o_addr_c ()
	// 	);

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
			.en     (en_h_x),
			.o_addr (addr_x1)
		);


	addr_gen_c #(
			.ADDR_WIDTH(ADDR_WIDTH),
			.TIMESTEP(7),
			.NUM_CELL(53),
			.NUM_INPUT(53),
			.DELAY(4)
		) inst_addr_gen_c1h1 (
			.clk      (clk),
			.rst      (rst_fsm),
			.en       (en_h_x),
			.o_addr_h (wr_addr_h1),
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
			.STOP(52),
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
			.STOP(2808),
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
			.DELAY(49)
		) inst_addr_gen_c2h2 (
			.clk      (clk),
			.rst      (rst_fsm),
			.en       (en_2),
			.o_addr_h (wr_addr_h2),
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


	fsm #(
		.S0(S0),
		.S1(S1),
		.S2(S2),
		.S3(S3),
		.S4(S4),
		.S5(S5),
		.S6(S6),
		.S7(S7),
		.S8(S8),
		.S9(S9),
		.S10(S10),
		.S11(S11),
		.S12(S12),
		.S13(S13),
		.S14(S14),
		.S15(S15),
		.S16(S16),
		.S17(S17),
		.S18(S18),
		.S19(S19),
		.S20(S20),
		.S21(S21),
		.S22(S22),
		.S23(S23),
		.S24(S24),
		.S25(S25),
		.S26(S26),
		.S27(S27),
		.S28(S28),
		.S29(S29),
		.S30(S30),
		.S31(S31),
		.S32(S32),
		.S33(S33),
		.S34(S34),
		.S35(S35),
		.S36(S36),
		.S37(S37),
		.S38(S38),
		.S39(S39),
		.S40(S40),
		.S41(S41),
		.S42(S42),
		.S43(S43),
		.S44(S44),
		.S45(S45),
		.S46(S46),
		.S47(S47),
		.S48(S48),
		.S49(S49),
		.S50(S50),
		.S51(S51),
		.S52(S52),
		.S53(S53),
		.S54(S54),
		.S55(S55),
		.S56(S56),
		.S57(S57),
		.S58(S58),
		.S59(S59),
		.S60(S60),
		.S61(S61),
		.S62(S62),
		.S63(S63),
		.S64(S64),
		.S65(S65),
		.S66(S66),
		.S67(S67),
		.S68(S68),
		.S69(S69),
		.S70(S70),
		.S71(S71),
		.S72(S72),
		.S73(S73),
		.S74(S74),
		.S75(S75),
		.S76(S76),
		.S77(S77),
		.S78(S78),
		.S79(S79),
		.S80(S80),
		.S81(S81),
		.S82(S82),
		.S83(S83),
		.S84(S84),
		.S85(S85),
		.S86(S86)
		)
		inst_fsm_module (
			.clk        (clk),
			.update		(update),
			.en_1       (en_1),
			.en_2 		(en_2),
			.en_h_x		(en_h_x),
			.en_addr_dgates_2 (en_addr_dgates_2),
			.en_addr_w_bp_2 (en_addr_w_bp_2),
			.rst_addr_dgates (rst_addr_dgates),
			.rst_fsm    (rst_fsm),
			.rst_bias_1 (rst_bias_1),
			.rst_bias_2 (rst_bias_2),
			.rst        (rst),
			.rst_2      (rst_2),
			.rst_acc    (rst_acc), 
			.rst_mac    (rst_mac),
			.acc_x_1    (acc_x_1),
			.acc_x_2    (acc_x_2),
			.acc_h_1    (acc_h_1),
			.acc_h_2    (acc_h_2),
			.wr_h1      (wr_h1),
			.wr_h2      (wr_h2),
			.wr_c1      (wr_c1),
			.wr_c2      (wr_c2),
			.wr_act_1   (wr_act_1),
			.wr_act_2   (wr_act_2),
			.wr_dstate1 (wr_dstate1),
			.wr_dstate2 (wr_dstate2),
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
			.acc_da     (acc_da),
			.acc_di     (acc_di),
			.acc_df     (acc_df),
			.acc_do     (acc_do),
			.acc_mac    (acc_mac),
			.sel_dgate  (sel_dgate),
			.sel_state  (sel_state),
			.sel_dstate (sel_dstate),
			.sel_dout   (sel_dout),
			.sel_wght   (sel_wght),
			.sel_wghts1 (sel_wghts1),
			.sel_wghts2 (sel_wghts2),
			.sel_a      (sel_a),
			.sel_i      (sel_i),
			.sel_f      (sel_f),
			.sel_o      (sel_o),
			.sel_h      (sel_h),
			.sel_t      (sel_t),
			.wr_da1     (wr_da1),
			.wr_di1     (wr_di1),
			.wr_df1     (wr_df1),
			.wr_do1     (wr_do1),
			.wr_da2     (wr_da2),
			.wr_di2     (wr_di2),
			.wr_df2     (wr_df2),
			.wr_do2     (wr_do2),
			.wr_dx2     (wr_dx2),
			.wr_dout2   (wr_dout2),
			.wr_dout1   (wr_dout1)
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
			.LAYR2_X(LAYR2_X),
			.LAYR2_H(LAYR2_H),
			.LAYR2_C(LAYR2_C),
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
		) inst_datapath (
			.clk             (clk),
			.rst             (rst),
			.rst_2           (rst_2),
			.acc_x_1         (acc_x_1),
			.acc_h_1         (acc_h_1),
			.acc_x_2         (acc_x_2),
			.acc_h_2         (acc_h_2),
			.wr_h1           (wr_h1),
			.wr_h2           (wr_h2),
			.wr_c1           (wr_c1),
			.wr_c2           (wr_c2),
			.wr_x2           (wr_x2),
			.addr_x1         (addr_x1),
			.rd_addr_x2      (),
			.wr_addr_x2      (),
			.wr_addr_act_1   (wr_addr_act_1),
			.wr_act_1        (wr_act_1),
			.wr_addr_act_2   (wr_addr_act_2),
			.wr_act_2        (wr_act_2),
			.wr_addr_w_1     (wr_addr_w_1),
			.wr_w_1          (wr_w_1),
			.rd_addr_w_1     (rd_addr_w_1),
			.wr_addr_u_1     (wr_addr_u_1),
			.wr_u_1          (wr_u_1),
			.rd_addr_u_1     (rd_addr_u_1),
			.wr_addr_b_1     (wr_addr_b_1),
			.wr_b_1          (wr_b_1),
			.rd_addr_b_1     (rd_addr_b_1),
			.wr_addr_w_2     (wr_addr_w_2),
			.wr_w_2          (wr_w_2),
			.rd_addr_w_2     (rd_addr_w_2),
			.wr_addr_b_2     (wr_addr_b_2),
			.wr_b_2          (wr_b_2),
			.rd_addr_b_2     (rd_addr_b_2),
			.wr_addr_u_2     (wr_addr_u_2),
			.wr_u_2          (wr_u_2),
			.rd_addr_u_2     (rd_addr_u_2),
			.rd_addr_h1      (rd_addr_h1),
			.rd_addr_h2      (rd_addr_h2),
			.rd_addr_c1      (rd_addr_c1),
			.rd_addr_c2      (rd_addr_c2),
			.wr_addr_h1      (wr_addr_h1),
			.wr_addr_h2      (wr_addr_h2),
			.wr_addr_c1      (wr_addr_c1),
			.wr_addr_c2      (wr_addr_c2),
			.rst_acc         (rst_acc),
			.rst_mac_bp      (rst_mac_bp),
			.rst_cost        (rst_cost),
			.sel_a           (sel_a),
			.sel_i           (sel_i),
			.sel_f           (sel_f),
			.sel_o           (sel_o),
			.sel_h           (sel_h),
			.sel_t           (sel_t),
			.sel_state       (sel_state),
			.sel_dstate      (sel_dstate),
			.sel_dout        (sel_dout),
			.sel_in1         (sel_in1),
			.sel_in2         (sel_in2),
			.sel_in3         (sel_in3),
			.sel_in4         (sel_in4),
			.sel_in5         (sel_in5),
			.sel_x1_1        (sel_x1_1),
			.sel_x1_2        (sel_x1_2),
			.sel_x2_2        (sel_x2_2),
			.sel_as_1        (sel_as_1),
			.sel_as_2        (sel_as_2),
			.sel_addsub      (sel_addsub),
			.sel_temp        (sel_temp),
			.acc_mac         (acc_mac),
			.acc_da          (acc_da),
			.acc_di          (acc_di),
			.acc_df          (acc_df),
			.acc_do          (acc_do),
			.acc_cost        (acc_cost),
			.sel_dgate       (sel_dgate),
			.sel_wght        (sel_wght),
			.sel_wghts1      (sel_wghts1),
			.sel_wghts2      (sel_wghts2),
			.wr_da1          (wr_da1),
			.wr_di1          (wr_di1),
			.wr_df1          (wr_df1),
			.wr_do1          (wr_do1),
			.wr_da2          (wr_da2),
			.wr_di2          (wr_di2),
			.wr_df2          (wr_df2),
			.wr_do2          (wr_do2),
			.rd_addr_da1     (),
			.rd_addr_di1     (),
			.rd_addr_df1     (),
			.rd_addr_do1     (),
			.rd_addr_da2     (),
			.rd_addr_di2     (),
			.rd_addr_df2     (),
			.rd_addr_do2     (),
			.wr_addr_da1     (),
			.wr_addr_di1     (),
			.wr_addr_df1     (),
			.wr_addr_do1     (),
			.wr_addr_da2     (),
			.wr_addr_di2     (),
			.wr_addr_df2     (),
			.wr_addr_do2     (),
			.wr_dx2          (wr_dx2),
			.rd_addr_dx2     (),
			.wr_addr_dx2     (),
			.wr_dout2        (wr_dout2),
			.rd_addr_dout2   (),
			.wr_addr_dout2   (),
			.wr_dout1        (wr_dout1),
			.rd_addr_dout1   (),
			.wr_addr_dout1   (),
			.wr_dstate2      (wr_dstate2),
			.rd_addr_dstate2 (),
			.wr_addr_dstate2 (),
			.wr_dstate1      (wr_dstate1),
			.rd_addr_dstate1 (),
			.wr_addr_dstate1 (),
			.rd_layr2_wa     (),
			.rd_layr2_wi     (),
			.rd_layr2_wf     (),
			.rd_layr2_wo     (),
			.rd_layr2_ua     (),
			.rd_layr2_ui     (),
			.rd_layr2_uf     (),
			.rd_layr2_uo     (),
			.rd_layr1_ua     (),
			.rd_layr1_ui     (),
			.rd_layr1_uf     (),
			.rd_layr1_uo     (),
			.rd_layr1_a      (),
			.rd_layr1_i      (),
			.rd_layr1_f      (),
			.rd_layr1_o      (),
			.rd_layr1_state  (),
			.rd_layr2_a      (),
			.rd_layr2_i      (),
			.rd_layr2_f      (),
			.rd_layr2_o      (),
			.rd_layr2_state  (),
			.rd_layr2_t      (),
			.rd_layr2_h      (),
			.update          (update),
			.o_cost          (),
			.dgate           (),
			.h2              (h2)
		);

assign rd_addr_w_1 = addr_wu_1;
assign rd_addr_u_1 = addr_wu_1;

endmodule

