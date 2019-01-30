module fsm_bp(
	clk, rst,

	en_delta, en_dx2, en_dout_2, en_dout_1,
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

// common ports
input clk, rst;

// output ports
output reg en_delta, en_dx2, en_dout_2, en_dout_1;
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

reg [7:0] state, count1, count2;

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
			en_delta <= 1'b1;
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
		S1:
		begin
			rst_mac_2 <= 1'b0;
			rst_mac_1 <= 1'b0;
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			wr_do1 <= 1'b1;
			wr_dstate_1 <= 1'b0;
		end
		S8:
		begin
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			wr_da1 <= 1'b1;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S10:
		begin
			en_delta <= 1'b1;
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
			wr_di1 <= 1'b1;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
		end
		S11:
		begin
			en_delta <= 1'b1;
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
			en_delta <= 1'b1;
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
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b1;
		end
		// END DELTA HERE ////////
		// START dX & dOut ///////
		// Loop Type 1 ///////////
		S13:
		begin
			rd_dgate <= 1'b1;
			en_delta <= 1'b0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
			
			en_dx2 <= 1'b1;
			en_dout_2 <= 1'b1;
			en_dout_1 <= 1'b1;
			
			acc_x2 <= 1'b1;
			acc_h2 <= 1'b1;
			acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			wr_dout_1 <= 1'b0;

			rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b0;
		end
		// Loop Type 2 ///////////
		S14:
		begin
			rd_dgate <= 1'b1;
			en_delta <= 1'b0;
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate_1 <= 1'b0;
			
			en_dx2 <= 1'b1;
			en_dout_2 <= 1'b0;
			en_dout_1 <= 1'b1;
			
			acc_x2 <= 1'b1;
			acc_h2 <= 1'b0;
			acc_h1 <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			wr_dout_1 <= 1'b0;

			rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b0;
		end
		// Write & Hold ////////
		S15:
		begin
			wr_dx2 <= 1'b1;
			wr_dout_2 <= 1'b1;
			wr_dout_1 <= 1'b0;
		end
		S16:
		begin
			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			wr_dout_1 <= 1'b0;
		end
		// Reset & Stop Acc ////
		S17:
		begin
			rst_mac_1 <= 1'b1;
			rst_mac_2 <= 1'b0;

			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			acc_h1 <= 1'b1;
		end
		// Loop Type 3 ///////////
		S18:
		begin
			rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b0;

			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			acc_h1 <= 1'b1;
		end
		// Write dOut1 and hold //
		S19:
		begin
			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			wr_dout_1 <= 1'b1;
		end
		S20:
		begin
			wr_dx2 <= 1'b0;
			wr_dout_2 <= 1'b0;
			wr_dout_1 <= 1'b0;
		end
		// Reset % Stop Acc //////
		S21:
		begin
			rst_mac_1 <= 1'b0;
			rst_mac_2 <= 1'b1;

			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			acc_h1 <= 1'b1;
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
			S13:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S13;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S15;
				end
			end
			S14:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= S13;
				end
				else
				begin
					count1 <= 8'd0;
					state <= S15;
				end
			end
			S15:
			begin
				state <= S16;
			end
			S16:
			begin
				state <= S17;
			end
			S17:
			begin
				state <= S18;
			end
			S18:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-2)
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
			S19:
			begin
				state <= S20;
			end
			S20:
			begin
				state <= S21;
			end
			S21:
			begin
				if (count2 < LAYR1_CELL)
				begin
					count2 <= count2 + 8'd1;
					if (count2 < LAYR2_CELL)
						state <= S13;
					else
						state <= S14;
				end
				else
				begin
					count2 <= 8'd0;
					state <= S22;
				end

			end
		endcase
	end
end



endmodule