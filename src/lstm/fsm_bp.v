module fsm_bp(
	clk, rst,

	en_delta_2, en_delta_1, en_dx2, en_dout2, en_dout1,
	en_rw_dout2, en_rw_dout1, en_rw_dx2,
	update, bp, rd_dgate,
	acc_x1, acc_h1,
	acc_x2, acc_h2,

	wr_dout_2, wr_dstate_2,

	sel_in1_2, sel_in1_1,
	sel_in2_2, sel_in2_1,
	sel_in3_2, sel_in3_1,
	sel_in4_2, sel_in4_1,
	sel_in5_2, sel_in5_1,
	sel_x1_1_2, sel_x1_1_1,
	sel_x1_2_2, sel_x1_2_1,
	sel_x2_2_2, sel_x2_2_1,
	sel_as_1_2, sel_as_1_1,
	sel_as_2_2, sel_as_2_1,
	sel_addsub_2, sel_addsub_1,
	sel_temp_2, sel_temp_1,

	wr_da2, wr_di2, wr_df2, wr_do2,
	wr_dx2, wr_dout_1, wr_dstate_1,

	wr_da1, wr_di1, wr_df1, wr_do1,

	rst_cost, acc_cost,

	rst_mac_1, rst_mac_2
	);

// parameters
parameter WIDTH = 24;
parameter FRAC = 20;
parameter LAYR2_CELL = 8;
parameter LAYR1_CELL = 53;
parameter TIMESTEP = 7;

// common ports
input clk, rst;

// output ports
output reg en_delta_2, en_delta_1, en_dx2, en_dout2, en_dout1;
output reg en_rw_dout2, en_rw_dout1, en_rw_dx2;
output reg update, bp, rd_dgate;
output reg acc_x1, acc_h1;
output reg acc_x2, acc_h2;

output reg wr_dout_2, wr_dstate_2;

output reg [1:0] sel_in1_2, sel_in1_1;
output reg [1:0] sel_in2_2, sel_in2_1;
output reg sel_in3_2, sel_in3_1;
output reg [1:0] sel_in4_2, sel_in4_1;
output reg [2:0] sel_in5_2, sel_in5_1;
output reg [1:0] sel_x1_1_2, sel_x1_1_1;
output reg sel_x1_2_2, sel_x1_2_1;
output reg [1:0] sel_x2_2_2, sel_x2_2_1;
output reg sel_as_1_2, sel_as_1_1;
output reg [1:0] sel_as_2_2, sel_as_2_1;
output reg sel_addsub_2, sel_addsub_1;
output reg [1:0] sel_temp_2, sel_temp_1;

output reg wr_da2, wr_di2, wr_df2, wr_do2;
output reg wr_dx2, wr_dout_1, wr_dstate_1;

output reg wr_da1, wr_di1, wr_df1, wr_do1;

output reg rst_cost, acc_cost;
output reg rst_mac_1, rst_mac_2;

reg [7:0] state, count1, count2, count_bp2, count_bp1;

parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9,  
S10=10, S11=11, S12=12, S13=13, S14=14, S15=15, S16=16, S17=17, S18=18, 
S19=19, S20=20, S21=21, S22=22, S23=23, S24=24, S25=25, S26=26, S27=27, 
S28=28, S29=29, S30=30, S31=31, S32=32, S33=33, S34=34, S35=35, S36=36, 
S37=37, S38=38, S39=39, S40=40, S41=41, S42=42, S43=43, S44=44, S45=45, 
S46=46, S47=47, S48=48, S49=49, S50=50, S51=51, S52=52, S53=53, S54=54, 
S55=55, S56=56, S57=57, S58=58, S59=59, S60=60, S61=61, S62=62, S63=63, 
S64=64, S65=65, S66=66, S67=67, S68=68, S69=69, S70=70, S71=71, S72=72, 
S73=73, S74=74, S75=75, S76=76, S99=77;



always @(state) 
begin
	case (state)
		// prep state for delta, can be merged into forward last state
		S0:
		begin
			rd_dgate <= 1'b0;
			rst_mac_2 <= 1'b1;
			rst_mac_1 <= 1'b1;
			acc_h2  <= 1'b0;
			acc_x2  <= 1'b0;
			acc_h1  <= 1'b0;
			acc_x1  <= 1'b0;
			update  <= 1'b0;
			bp		<= 1'b1;
			en_delta_2 <= 1'b0;
			en_delta_1 <= 1'b0;
			en_rw_dout2 <= 1'b1;
			en_rw_dout1 <= 1'b0;
			en_rw_dx2 <= 1'b0;
			rst_cost <= 1'b1;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		// S1 - S12 repeaeted 8 times, and calculating only for delta 2
		S1:
		begin
			rst_mac_2 <= 1'b0;
			rst_mac_1 <= 1'b0;
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			en_dout2 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h1;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h1;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S2:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S3:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h2;
			sel_in2_2 <= 2'h3;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h1;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h3;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h3;
			sel_addsub_2 <= 1'h1;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h2;
			sel_in2_1 <= 2'h3;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h1;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h3;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h3;
			sel_addsub_1 <= 1'h1;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S4:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b1;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h2;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h4;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h2;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h4;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S5:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h1;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h2;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h1;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h2;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S6:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h1;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h1;
			sel_as_1_2 <= 1'h1;
			sel_as_2_2 <= 2'h2;
			sel_addsub_2 <= 1'h1;
			sel_temp_2 <= 2'h1;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h1;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h1;
			sel_as_1_1 <= 1'h1;
			sel_as_2_1 <= 2'h2;
			sel_addsub_1 <= 1'h1;
			sel_temp_1 <= 2'h1;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S7:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h1;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h2;	
			sel_x1_1_2 <= 2'h2;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h1;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b1;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h1;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h2;
			sel_x1_1_1 <= 2'h2;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h1;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S8:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h1;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h3;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h1;
			sel_x2_2_2 <= 2'h2;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h1;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h3;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h1;
			sel_x2_2_1 <= 2'h2;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S9:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h3;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h2;	
			sel_in5_2 <= 3'h3;	
			sel_x1_1_2 <= 2'h2;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h1;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b1;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h3;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h2;
			sel_in5_1 <= 3'h3;
			sel_x1_1_1 <= 2'h2;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h1;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S10:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h1;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b1;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h1;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S11:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h1;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h2;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b0;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h1;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h2;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S12:
		begin
			en_delta_2 <= 1'b1;
			en_delta_1 <= 1'b0;
			rst_cost <= 1'b0;
			acc_cost <= 1'b0;
			sel_in1_2 <= 2'h0;
			sel_in2_2 <= 2'h0;	
			sel_in3_2 <= 1'h0;	
			sel_in4_2 <= 2'h0;	
			sel_in5_2 <= 3'h0;	
			sel_x1_1_2 <= 2'h0;
			sel_x1_2_2 <= 1'h0;
			sel_x2_2_2 <= 2'h0;
			sel_as_1_2 <= 1'h0;
			sel_as_2_2 <= 2'h0;
			sel_addsub_2 <= 1'h0;
			sel_temp_2 <= 2'h0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate_2 <= 1'b1;
			sel_in1_1 <= 2'h0;
			sel_in2_1 <= 2'h0;
			sel_in3_1 <= 1'h0;
			sel_in4_1 <= 2'h0;
			sel_in5_1 <= 3'h0;
			sel_x1_1_1 <= 2'h0;
			sel_x1_2_1 <= 1'h0;
			sel_x2_2_1 <= 2'h0;
			sel_as_1_1 <= 1'h0;
			sel_as_2_1 <= 2'h0;
			sel_addsub_1 <= 1'h0;
			sel_temp_1 <= 2'h0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		// DELTA 2 calculation ends here ////////
		
		// Start Calculating for dX2 and dOut2 ///////
		// pre calc
		S13:
		begin
		 	rd_dgate <= 1'b1;
			en_delta_2 <= 1'b0;
			en_delta_1 <= 1'b0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;

			wr_dstate_2 <= 1'b0;

			en_dx2 <= 1'b1;
			en_dout2 <= 1'b1;
			// en_dout1 <= 1'b1;

			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b0;

			en_rw_dout2 <= 1'b0;
			en_rw_dx2 <= 1'b1;
			// en_rw_dout1 <= 1'b0;
		end 
		S14: // Loop dout2 & dx2
		begin
			rd_dgate <= 1'b1;
			
			en_dx2 <= 1'b1;
			en_dout2 <= 1'b1;
			// en_dout1 <= 1'b1;
			
			en_rw_dout2 <= 1'b1;
			en_rw_dx2 <= 1'b1;
			
			acc_x2 <= 1'b1;
			acc_h2 <= 1'b1;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b0;
		end
		S15: // not acc & write
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b1;
			wr_dout_2 <= 1'b1;
			// wr_dout_1 <= 1'b0;
			en_dout2 <= 1'b1;
		end
		S16: // reset
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b1;
		end
		S17:
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			en_dx2 <= 1'b1;
			en_dout2 <= 1'b0;
			// en_dout1 <= 1'b1;
			
			en_rw_dout2 <= 1'b0;
			en_rw_dx2 <= 1'b1;
			// en_rw_dout1 <= 1'b0;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b1;
		end
		S18: // Loop dout2 & dx2
		begin
			rd_dgate <= 1'b1;
			
			en_dx2 <= 1'b1;
			en_dout2 <= 1'b0;
			// en_dout1 <= 1'b1;
			
			en_rw_dout2 <= 1'b0;
			en_rw_dx2 <= 1'b1;
			// en_rw_dout1 <= 1'b0;

			acc_x2 <= 1'b1;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b0;
		end
		S19: // not acc & write
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b1;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;
			en_dout2 <= 1'b0;
		end
		S20: // reset
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b1;
		end
		// end of 1st dx dout, prep for repeating delta
		S21:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_1    <= 1'b1;  en_dout2     <= 1'b0;
			rst_mac_2    <= 1'b1;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b1;  en_rw_dout1  <= 1'b0;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S22: // start of delta calculation
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h1;  sel_in4_1    <= 2'h1;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S23:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S24:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h2;  sel_in1_1    <= 2'h2;
			sel_in2_2    <= 2'h3;  sel_in2_1    <= 2'h3;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h1;  sel_in5_1    <= 3'h1;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h3;  sel_x2_2_1   <= 2'h3;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h3;  sel_as_2_1   <= 2'h3;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S25:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b1;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h2;  sel_in2_1    <= 2'h2;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h4;  sel_in5_1    <= 3'h4;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S26:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h1;  sel_x1_1_1   <= 2'h1;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S27:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h1;  sel_in3_1    <= 1'h1;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h1;  sel_as_1_1   <= 1'h1;
			sel_as_2_2   <= 2'h2;  sel_as_2_1   <= 2'h2;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h1;  sel_temp_1   <= 2'h1;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S28:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h1;  sel_in1_1    <= 2'h1;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h2;  sel_in5_1    <= 3'h2;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h1;  sel_as_2_1   <= 2'h1;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b1;  wr_do1       <= 1'b1;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S29:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h1;  sel_in2_1    <= 2'h1;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S30:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h3;  sel_in1_1    <= 2'h3;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b1;  wr_da1       <= 1'b1;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S31:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b1;  wr_di1       <= 1'b1;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S32:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S33:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b1;  wr_df1       <= 1'b1;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b1;  wr_dstate_1  <= 1'b1;
		end
		// switch to delta 1 only //////////////////////
		S34:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b1;  wr_df1       <= 1'b1;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b1;  wr_dstate_1  <= 1'b1;
		end
		S35:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h1;  sel_in4_1    <= 2'h1;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S36:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S37:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h2;  sel_in1_1    <= 2'h2;
			sel_in2_2    <= 2'h3;  sel_in2_1    <= 2'h3;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h1;  sel_in5_1    <= 3'h1;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h3;  sel_x2_2_1   <= 2'h3;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h3;  sel_as_2_1   <= 2'h3;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S38:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b1;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h2;  sel_in2_1    <= 2'h2;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h4;  sel_in5_1    <= 3'h4;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S39:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h1;  sel_x1_1_1   <= 2'h1;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S40:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h1;  sel_in3_1    <= 1'h1;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h1;  sel_as_1_1   <= 1'h1;
			sel_as_2_2   <= 2'h2;  sel_as_2_1   <= 2'h2;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h1;  sel_temp_1   <= 2'h1;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S41:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h1;  sel_in1_1    <= 2'h1;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h2;  sel_in5_1    <= 3'h2;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h1;  sel_as_2_1   <= 2'h1;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b1;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S42:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h1;  sel_in2_1    <= 2'h1;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S43:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h3;  sel_in1_1    <= 2'h3;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b1;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S44:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b1;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S45:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S46:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b1;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b1;
		end
		S47:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
		                           en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b1;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b0;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S48: // loop dout2, dx2, dout1
		begin
			acc_x2       <= 1'b1;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b1;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b1;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S49: // not acc & write layer 2
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b1;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b1;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b1;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S50: // reset
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b1;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;	
		end
		S51: // loop for dout1
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S52: // not acc & write layer 1
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b1;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S53: // reset
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b1;
			rst_mac_1    <= 1'b1;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S54: // prep for next loop
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b1;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		/// rest of dout1 and dx2
		S55: // loop dx2, dout1
		begin
			acc_x2       <= 1'b1;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S56: // not acc & write layer 2
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b1;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S57: // reset
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b1;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;	
		end
		S58: // loop for dout1
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b1;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S59: // not acc & write layer 1
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b1;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S60: // reset
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b1;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b1;  en_dx2       <= 1'b1;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S61: // prep for finish
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b1;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b1;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b1;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b1;  en_rw_dout1  <= 1'b0;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S62: // prep for NEXT TIMESTEP
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b1;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S63: // identical to S62 but w/o en_delta_2
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S64: // start of delta calculation
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h1;  sel_in4_1    <= 2'h1;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S65:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S66:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h2;  sel_in1_1    <= 2'h2;
			sel_in2_2    <= 2'h3;  sel_in2_1    <= 2'h3;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h1;  sel_in5_1    <= 3'h1;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h3;  sel_x2_2_1   <= 2'h3;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h3;  sel_as_2_1   <= 2'h3;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S67:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b1;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h2;  sel_in2_1    <= 2'h2;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h4;  sel_in5_1    <= 3'h4;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S68:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h1;  sel_x1_1_1   <= 2'h1;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S69:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h1;  sel_in3_1    <= 1'h1;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h1;  sel_as_1_1   <= 1'h1;
			sel_as_2_2   <= 2'h2;  sel_as_2_1   <= 2'h2;
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h1;  sel_temp_1   <= 2'h1;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S70:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h1;  sel_in1_1    <= 2'h1;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h2;  sel_in5_1    <= 3'h2;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h1;  sel_as_2_1   <= 2'h1;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b1;  wr_do1       <= 1'b1;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S71:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h1;  sel_in2_1    <= 2'h1;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h2;  sel_x2_2_1   <= 2'h2;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S72:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h3;  sel_in1_1    <= 2'h3;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h2;  sel_in4_1    <= 2'h2;  
			sel_in5_2    <= 3'h3;  sel_in5_1    <= 3'h3;  
			sel_x1_1_2   <= 2'h2;  sel_x1_1_1   <= 2'h2;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b1;  wr_da1       <= 1'b1;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S73:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h1;  sel_x1_2_1   <= 1'h1;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b1;  wr_di1       <= 1'b1;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S74:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h1;  sel_x2_2_1   <= 2'h1;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
		S75:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b1; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b1;  wr_df1       <= 1'b1;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b1;  wr_dstate_1  <= 1'b1;
		end
		// switch to delta 1 only //////////////////////
		S76:
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
								   en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b1;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0; 
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b1;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b1;
			
			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;  
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;  
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;  
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;  
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b1;  wr_df1       <= 1'b1;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b1;  wr_dstate_1  <= 1'b1;
		end
		S99: // last idle state
		begin
			acc_x2       <= 1'b0;  wr_dx2       <= 1'b0;
			acc_h2       <= 1'b0;  wr_dout_2    <= 1'b0;
			acc_h1       <= 1'b0;  wr_dout_1    <= 1'b0;
			                       en_dout1     <= 1'b0;
			rst_mac_2    <= 1'b0;  en_dout2     <= 1'b0;
			rst_mac_1    <= 1'b0;  en_dx2       <= 1'b0;
			//
			rd_dgate     <= 1'b0;  en_delta_2   <= 1'b0;
			update       <= 1'b0;  en_delta_1   <= 1'b0;
			bp           <= 1'b1;  en_rw_dout2  <= 1'b0;
			rst_cost     <= 1'b0;  en_rw_dout1  <= 1'b0;
			acc_cost     <= 1'b0;  en_rw_dx2    <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_in1_1    <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_in2_1    <= 2'h0;
			sel_in3_2    <= 1'h0;  sel_in3_1    <= 1'h0;
			sel_in4_2    <= 2'h0;  sel_in4_1    <= 2'h0;
			sel_in5_2    <= 3'h0;  sel_in5_1    <= 3'h0;
			sel_x1_1_2   <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_x1_2_2   <= 1'h0;  sel_x1_2_1   <= 1'h0;
			sel_x2_2_2   <= 2'h0;  sel_x2_2_1   <= 2'h0;
			sel_as_1_2   <= 1'h0;  sel_as_1_1   <= 1'h0;
			sel_as_2_2   <= 2'h0;  sel_as_2_1   <= 2'h0;
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;

			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
		end
	endcase
end



always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		state <= S0;
		count1 <= 8'd0;
		count2 <= 8'd0;
		count_bp2 <= 3'd0;
		count_bp1 <= 3'd0;
	end
	else
	begin
		case (state)
			S0:
			begin
				state <= S1;
			end
			S1:
			begin
				state <= S2;
			end
			S2:
			begin
				state <= S3;
			end
			S3:
			begin
				state <= S4;
			end
			S4:
			begin
				state <= S5;
			end
			S5:
			begin
				state <= S6;
			end
			S6:
			begin
				state <= S7;
			end
			S7:
			begin
				state <= S8;
			end
			S8:
			begin
				state <= S9;
			end
			S9:
			begin
				state <= S10;
			end
			S10:
			begin
				state <= S11;
			end
			S11:
			begin
				state <= S12;
			end
			S12:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S1;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S13;
				end
			end
			S13: // prep
			begin
				count_bp2 <= count_bp2 + 1;
				state <= S14;
			end
			S14: // repeat for dout2 & dx2
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S14;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S15;
				end
			end
			S15: // not acc & wr
			begin
				if (count2 < LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= S16;
				end
				else
				begin
					count2 <= 8'd0;
					state <= S17;
				end
			end
			S16: // reset
			begin
				state <= S14;
			end
			S17:
			begin
				state <= S18;
			end
			S18: // repeat for dx2
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S18;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S19;
				end
			end
			S19: // not acc & wr
			begin
				if (count2 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= S20;
				end
				else
				begin
					count2 <= 8'd0;
					state <= S21;
				end
			end
			S20:
			begin
				state <= S18;
			end
			S21:
			begin
				state <= S22;
			end
			S22:
			begin
				state <= S23;
			end
			S23:
			begin
				state <= S24;
			end
			S24:
			begin
				state <= S25;
			end
			S25:
			begin
				state <= S26;
			end
			S26:
			begin
				state <= S27;
			end
			S27:
			begin
				state <= S28;
			end
			S28:
			begin
				state <= S29;
			end
			S29:
			begin
				state <= S30;
			end
			S30:
			begin
				state <= S31;
			end
			S31:
			begin
				state <= S32;
			end
			S32:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S33;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S34;
				end
			end
			S33:
			begin
				state <= S22;
			end
			S34:
			begin
				count_bp2 <= count_bp2 + 1;
				state <= S35;
			end
			S35:
			begin
				state <= S36;
			end
			S36:
			begin
				state <= S37;
			end
			S37:
			begin
				state <= S38;
			end
			S38:
			begin
				state <= S39;
			end
			S39:
			begin
				state <= S40;
			end
			S40:
			begin
				state <= S41;
			end
			S41:
			begin
				state <= S42;
			end
			S42:
			begin
				state <= S43;
			end
			S43:
			begin
				state <= S44;
			end
			S44:
			begin
				state <= S45;
			end
			S45:
			begin
				state <= S46;
			end
			S46:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;	
					state <= S35;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S47;
				end
			end
			S47:
			begin
				count_bp1 <= count_bp1 + 1;
				state <= S48;
			end
			S48:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S48;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S49;
				end
			end
			S49:
			begin
				state <= S50;
			end
			S50:
			begin
				state <= S51;
			end
			S51:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-3)
				begin
					count1 <= count1 + 1;
					state <= S51;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S52;
				end
			end
			S52:
			begin
				if (count2 < LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= S53;	
				end
				else
				begin
					count2 <= 8'd0;
					state <= S54;
				end
			end
			S53:
			begin
				state <= S48;
			end
			S54:
			begin
				state <= S55;
			end
			S55:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S55;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S56;
				end
			end
			S56:
			begin
				state <= S57;
			end
			S57:
			begin
				state <= S58;
			end
			S58:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-3)
				begin
					count1 <= count1 + 1;
					state <= S58;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S59;
				end
			end
			S59:
			begin
				if (count2 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= S60;
				end
				else
				begin
					count2 <= 8'd0;
					state <= S61;
				end
			end
			S60:
			begin
				state <= S55;
			end
			S61:
			begin
				if (count_bp2 < TIMESTEP)
				begin
					state <= S62;
				end
				else
				begin
					state <= S63;
				end
			end
			S62:
			begin
				state <= S22;
			end
			S63: // identical to 62 but w/0 en_delta2
			begin
				if (count_bp1 < TIMESTEP)
				begin
					state <= S64;
				end
				else
				begin
					state <= S99;
				end
			end
			S64: // identical to 22 but w/0 en_delta2
			begin
				state <= S65;
			end
			S65:
			begin
				state <= S66;
			end
			S66:
			begin
				state <= S67;
			end
			S67:
			begin
				state <= S68;
			end
			S68:
			begin
				state <= S69;
			end
			S69:
			begin
				state <= S70;
			end
			S70:
			begin
				state <= S71;
			end
			S71:
			begin
				state <= S72;
			end
			S72:
			begin
				state <= S73;
			end
			S73:
			begin
				state <= S74;
			end
			S74:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S75;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S76;
				end
			end
			S75:
			begin
				state <= S64;
			end
			S76: // identical to 34 but w/0 en_delta2
			begin
				state <= S35;
			end
			S99: // last idle state
			begin
				state <= S99;
			end
		endcase
	end
end

endmodule