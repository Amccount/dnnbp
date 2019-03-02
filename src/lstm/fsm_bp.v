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

parameter BP0=0, BP1=1, BP2=2, BP3=3, BP4=4, BP5=5, BP6=6, BP7=7, BP8=8, BP9=9,  
BP10=10, BP11=11, BP12=12, BP13=13, BP14=14, BP15=15, BP16=16, BP17=17, BP18=18, 
BP19=19, BP20=20, BP21=21, BP22=22, BP23=23, BP24=24, BP25=25, BP26=26, BP27=27, 
BP28=28, BP29=29, BP30=30, BP31=31, BP32=32, BP33=33, BP34=34, BP35=35, BP36=36, 
BP37=37, BP38=38, BP39=39, BP40=40, BP41=41, BP42=42, BP43=43, BP44=44, BP45=45, 
BP46=46, BP47=47, BP48=48, BP49=49, BP50=50, BP51=51, BP52=52, BP53=53, BP54=54, 
BP55=55, BP56=56, BP57=57, BP58=58, BP59=59, BP60=60, BP61=61, BP62=62, BP63=63, 
BP64=64, BP65=65, BP66=66, BP67=67, BP68=68, BP69=69, BP70=70, BP71=71, BP72=72, 
BP73=73, BP74=74, BP75=75, BP76=76, BP77=77;



always @(state) 
begin
	case (state)
		// prep state for delta, can be merged into forward last state
		BP0:
		begin
			rd_dgate     <= 1'b0;
			rst_mac_2    <= 1'b1;  acc_h2       <= 1'b0;
			rst_mac_1    <= 1'b1;  acc_x2       <= 1'b0;
			update       <= 1'b0;  acc_h1       <= 1'b0;
			bp           <= 1'b1;  acc_x1       <= 1'b0;
			
			en_delta_2   <= 1'b0;  en_rw_dout2  <= 1'b1;
			en_delta_1   <= 1'b0;  en_rw_dout1  <= 1'b0;
			rst_cost     <= 1'b1;  en_rw_dx2    <= 1'b0;
			acc_cost     <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		// S1 - S12 repeaeted 8 times, and calculating only for delta 2
		BP1:
		begin
			rst_mac_2    <= 1'b0;  en_delta_2   <= 1'b1;
			rst_mac_1    <= 1'b0;  en_delta_1   <= 1'b0;
			rst_cost     <= 1'b0;  en_dout2     <= 1'b0;
			acc_cost     <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h1;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h1;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		BP2:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;

			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		BP3:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h2;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h3;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h3;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h1;  sel_as_2_2   <= 2'h3;  
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h2;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h3;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h3;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h1;  sel_as_2_1   <= 2'h3;
		end
		BP4:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b1;
					
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h2;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h4;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h2;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h4;  sel_as_2_1   <= 2'h0;
		end
		BP5:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h1;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h2;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h1;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h2;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		BP6:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h1;  sel_x2_2_2   <= 2'h1;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h1;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h2;  
			sel_addsub_2 <= 1'h1;  sel_addsub_1 <= 1'h1;
			sel_temp_2   <= 2'h1;  sel_temp_1   <= 2'h1;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h1;  sel_x2_2_1   <= 2'h1;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h1;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h2;
		end
		BP7:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h1;  sel_x1_1_2   <= 2'h2;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h2;  sel_as_2_2   <= 2'h1;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b1;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h1;  sel_x1_1_1   <= 2'h2;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h2;  sel_as_2_1   <= 2'h1;
		end
		BP8:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h1;  sel_x1_2_2   <= 1'h1;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h2;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h3;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h1;  sel_x1_2_1   <= 1'h1;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h2;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h3;  sel_as_2_1   <= 2'h0;
		end
		BP9:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h3;  sel_x1_1_2   <= 2'h2;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h1;  
			sel_in4_2    <= 2'h2;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h3;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b1;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h3;  sel_x1_1_1   <= 2'h2;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h1;
			sel_in4_1    <= 2'h2;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h3;  sel_as_2_1   <= 2'h0;
		end
		BP10:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h1;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b1;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h1;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		BP11:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h1;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h2;  sel_temp_1   <= 2'h2;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b0;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b0;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h1;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		BP12:
		begin
			en_delta_2   <= 1'b1;  rst_cost     <= 1'b0;
			en_delta_1   <= 1'b0;  acc_cost     <= 1'b0;
			
			sel_in1_2    <= 2'h0;  sel_x1_1_2   <= 2'h0;
			sel_in2_2    <= 2'h0;  sel_x1_2_2   <= 1'h0;  
			sel_in3_2    <= 1'h0;  sel_x2_2_2   <= 2'h0;  
			sel_in4_2    <= 2'h0;  sel_as_1_2   <= 1'h0;  
			sel_in5_2    <= 3'h0;  sel_as_2_2   <= 2'h0;  
			sel_addsub_2 <= 1'h0;  sel_addsub_1 <= 1'h0;
			sel_temp_2   <= 2'h0;  sel_temp_1   <= 2'h0;
			wr_da2       <= 1'b0;  wr_da1       <= 1'b0;
			wr_di2       <= 1'b0;  wr_di1       <= 1'b0;
			wr_df2       <= 1'b1;  wr_df1       <= 1'b0;
			wr_do2       <= 1'b0;  wr_do1       <= 1'b0;
			wr_dstate_2  <= 1'b1;  wr_dstate_1  <= 1'b0;
			sel_in1_1    <= 2'h0;  sel_x1_1_1   <= 2'h0;
			sel_in2_1    <= 2'h0;  sel_x1_2_1   <= 1'h0;
			sel_in3_1    <= 1'h0;  sel_x2_2_1   <= 2'h0;
			sel_in4_1    <= 2'h0;  sel_as_1_1   <= 1'h0;
			sel_in5_1    <= 3'h0;  sel_as_2_1   <= 2'h0;
		end
		// DELTA 2 calculation ends here ////////

		// Start Calculating for dX2 and dOut2 ///////
		// pre calc
		BP13:
		begin
		    rd_dgate       <= 1'b1;
			en_delta_2     <= 1'b0;
			en_delta_1     <= 1'b0;
			wr_da1         <= 1'b0;
			wr_di1         <= 1'b0;
			wr_df1         <= 1'b0;
			wr_do1         <= 1'b0;
			wr_da2         <= 1'b0;
			wr_di2         <= 1'b0;
			wr_df2         <= 1'b0;
			wr_do2         <= 1'b0;

			wr_dstate_2    <= 1'b0;

			en_dx2         <= 1'b1;
			en_dout2       <= 1'b1;
			// en_dout1    <= 1'b1;

			acc_x2         <= 1'b0;
			acc_h2         <= 1'b0;
			// acc_h1      <= 1'b0;

			en_rw_dout2    <= 1'b0;
			en_rw_dx2      <= 1'b1;
			// en_rw_dout1 <= 1'b0;
		end 
		BP14: // Loop dout2 & dx2
		begin
			rd_dgate     <= 1'b1;
			
			en_dx2       <= 1'b1;
			en_dout2     <= 1'b1;
			// en_dout1  <= 1'b1;
			
			en_rw_dout2  <= 1'b1;
			en_rw_dx2    <= 1'b1;
			
			acc_x2       <= 1'b1;
			acc_h2       <= 1'b1;
			// acc_h1    <= 1'b1;

			wr_dx2       <= 1'b0;
			wr_dout_2    <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2    <= 1'b0;
		end
		BP15: // not acc & write
		begin
			acc_x2       <= 1'b0;
			acc_h2       <= 1'b0;
			// acc_h1    <= 1'b1;

			wr_dx2       <= 1'b1;
			wr_dout_2    <= 1'b1;
			// wr_dout_1 <= 1'b0;
			en_dout2     <= 1'b1;
		end
		BP16: // reset
		begin
			acc_x2       <= 1'b0;
			acc_h2       <= 1'b0;
			// acc_h1    <= 1'b1;

			wr_dx2       <= 1'b0;
			wr_dout_2    <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2    <= 1'b1;
		end
		BP17:
		begin
			acc_x2         <= 1'b0;
			acc_h2         <= 1'b0;
			// acc_h1      <= 1'b1;

			en_dx2         <= 1'b1;
			en_dout2       <= 1'b0;
			// en_dout1    <= 1'b1;
			
			en_rw_dout2    <= 1'b0;
			en_rw_dx2      <= 1'b1;
			// en_rw_dout1 <= 1'b0;

			wr_dx2         <= 1'b0;
			wr_dout_2      <= 1'b0;
			// wr_dout_1   <= 1'b0;

			// rst_mac_1   <= 1'b0;
			rst_mac_2      <= 1'b1;
		end
		BP18: // Loop dout2 & dx2
		begin
			rd_dgate       <= 1'b1;
			
			en_dx2         <= 1'b1;
			en_dout2       <= 1'b0;
			// en_dout1    <= 1'b1;
			
			en_rw_dout2    <= 1'b0;
			en_rw_dx2      <= 1'b1;
			// en_rw_dout1 <= 1'b0;

			acc_x2         <= 1'b1;
			acc_h2         <= 1'b0;
			// acc_h1      <= 1'b1;

			wr_dx2         <= 1'b0;
			wr_dout_2      <= 1'b0;
			// wr_dout_1   <= 1'b0;

			// rst_mac_1   <= 1'b0;
			rst_mac_2      <= 1'b0;
		end
		BP19: // not acc & write
		begin
			acc_x2       <= 1'b0;
			acc_h2       <= 1'b0;
			// acc_h1    <= 1'b1;

			wr_dx2       <= 1'b1;
			wr_dout_2    <= 1'b0;
			// wr_dout_1 <= 1'b0;
			en_dout2     <= 1'b0;
		end
		BP20: // reset
		begin
			acc_x2       <= 1'b0;
			acc_h2       <= 1'b0;
			// acc_h1    <= 1'b1;

			wr_dx2       <= 1'b0;
			wr_dout_2    <= 1'b0;
			// wr_dout_1 <= 1'b0;

			// rst_mac_1 <= 1'b0;
			rst_mac_2    <= 1'b1;
		end
		// end of 1st dx dout, prep for repeating delta
		BP21:
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
		BP22: // start of delta calculation
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
		BP23:
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
		BP24:
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
		BP25:
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
		BP26:
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
		BP27:
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
		BP28:
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
		BP29:
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
		BP30:
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
		BP31:
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
		BP32:
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
		BP33:
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
		BP34:
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
		BP35:
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
		BP36:
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
		BP37:
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
		BP38:
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
		BP39:
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
		BP40:
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
		BP41:
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
		BP42:
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
		BP43:
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
		BP44:
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
		BP45:
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
		BP46:
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
		BP47:
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
		BP48: // loop dout2, dx2, dout1
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
		BP49: // not acc & write layer 2
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
		BP50: // reset
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
		BP51: // loop for dout1
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
		BP52: // not acc & write layer 1
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
		BP53: // reset
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
		BP54: // prep for next loop
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
		BP55: // loop dx2, dout1
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
		BP56: // not acc & write layer 2
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
		BP57: // reset
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
		BP58: // loop for dout1
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
		BP59: // not acc & write layer 1
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
		BP60: // reset
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
		BP61: // prep for finish
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
		BP62: // prep for NEXT TIMESTEP
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
		BP63: // identical to S62 but w/o en_delta_2
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
		BP64: // start of delta calculation
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
		BP65:
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
		BP66:
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
		BP67:
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
		BP68:
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
		BP69:
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
		BP70:
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
		BP71:
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
		BP72:
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
		BP73:
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
		BP74:
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
		BP75:
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
		BP76:
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
		BP77: // last idle state
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
		state <= BP0;
		count1 <= 8'd0;
		count2 <= 8'd0;
		count_bp2 <= 3'd0;
		count_bp1 <= 3'd0;
	end
	else
	begin
		case (state)
			BP0:
			begin
				state <= BP1;
			end
			BP1:
			begin
				state <= BP2;
			end
			BP2:
			begin
				state <= BP3;
			end
			BP3:
			begin
				state <= BP4;
			end
			BP4:
			begin
				state <= BP5;
			end
			BP5:
			begin
				state <= BP6;
			end
			BP6:
			begin
				state <= BP7;
			end
			BP7:
			begin
				state <= BP8;
			end
			BP8:
			begin
				state <= BP9;
			end
			BP9:
			begin
				state <= BP10;
			end
			BP10:
			begin
				state <= BP11;
			end
			BP11:
			begin
				state <= BP12;
			end
			BP12:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP1;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP13;
				end
			end
			BP13: // prep
			begin
				count_bp2 <= count_bp2 + 1;
				state <= BP14;
			end
			BP14: // repeat for dout2 & dx2
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP14;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP15;
				end
			end
			BP15: // not acc & wr
			begin
				if (count2 < LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= BP16;
				end
				else
				begin
					count2 <= 8'd0;
					state <= BP17;
				end
			end
			BP16: // reset
			begin
				state <= BP14;
			end
			BP17:
			begin
				state <= BP18;
			end
			BP18: // repeat for dx2
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP18;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP19;
				end
			end
			BP19: // not acc & wr
			begin
				if (count2 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= BP20;
				end
				else
				begin
					count2 <= 8'd0;
					state <= BP21;
				end
			end
			BP20:
			begin
				state <= BP18;
			end
			BP21:
			begin
				state <= BP22;
			end
			BP22:
			begin
				state <= BP23;
			end
			BP23:
			begin
				state <= BP24;
			end
			BP24:
			begin
				state <= BP25;
			end
			BP25:
			begin
				state <= BP26;
			end
			BP26:
			begin
				state <= BP27;
			end
			BP27:
			begin
				state <= BP28;
			end
			BP28:
			begin
				state <= BP29;
			end
			BP29:
			begin
				state <= BP30;
			end
			BP30:
			begin
				state <= BP31;
			end
			BP31:
			begin
				state <= BP32;
			end
			BP32:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP33;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP34;
				end
			end
			BP33:
			begin
				state <= BP22;
			end
			BP34:
			begin
				count_bp2 <= count_bp2 + 1;
				state <= BP35;
			end
			BP35:
			begin
				state <= BP36;
			end
			BP36:
			begin
				state <= BP37;
			end
			BP37:
			begin
				state <= BP38;
			end
			BP38:
			begin
				state <= BP39;
			end
			BP39:
			begin
				state <= BP40;
			end
			BP40:
			begin
				state <= BP41;
			end
			BP41:
			begin
				state <= BP42;
			end
			BP42:
			begin
				state <= BP43;
			end
			BP43:
			begin
				state <= BP44;
			end
			BP44:
			begin
				state <= BP45;
			end
			BP45:
			begin
				state <= BP46;
			end
			BP46:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;	
					state <= BP35;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP47;
				end
			end
			BP47:
			begin
				count_bp1 <= count_bp1 + 1;
				state <= BP48;
			end
			BP48:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP48;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP49;
				end
			end
			BP49:
			begin
				state <= BP50;
			end
			BP50:
			begin
				state <= BP51;
			end
			BP51:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-3)
				begin
					count1 <= count1 + 1;
					state <= BP51;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP52;
				end
			end
			BP52:
			begin
				if (count2 < LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= BP53;	
				end
				else
				begin
					count2 <= 8'd0;
					state <= BP54;
				end
			end
			BP53:
			begin
				state <= BP48;
			end
			BP54:
			begin
				state <= BP55;
			end
			BP55:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP55;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP56;
				end
			end
			BP56:
			begin
				state <= BP57;
			end
			BP57:
			begin
				state <= BP58;
			end
			BP58:
			begin
				if (count1 < LAYR1_CELL-LAYR2_CELL-3)
				begin
					count1 <= count1 + 1;
					state <= BP58;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP59;
				end
			end
			BP59:
			begin
				if (count2 < LAYR1_CELL-LAYR2_CELL-1)
				begin
					count2 <= count2 + 1;
					state <= BP60;
				end
				else
				begin
					count2 <= 8'd0;
					state <= BP61;
				end
			end
			BP60:
			begin
				state <= BP55;
			end
			BP61:
			begin
				if (count_bp2 < TIMESTEP)
				begin
					state <= BP62;
				end
				else
				begin
					state <= BP63;
				end
			end
			BP62:
			begin
				state <= BP22;
			end
			BP63: // identical to 62 but w/0 en_delta2
			begin
				if (count_bp1 < TIMESTEP)
				begin
					state <= BP64;
				end
				else
				begin
					state <= BP77;
				end
			end
			BP64: // identical to 22 but w/0 en_delta2
			begin
				state <= BP65;
			end
			BP65:
			begin
				state <= BP66;
			end
			BP66:
			begin
				state <= BP67;
			end
			BP67:
			begin
				state <= BP68;
			end
			BP68:
			begin
				state <= BP69;
			end
			BP69:
			begin
				state <= BP70;
			end
			BP70:
			begin
				state <= BP71;
			end
			BP71:
			begin
				state <= BP72;
			end
			BP72:
			begin
				state <= BP73;
			end
			BP73:
			begin
				state <= BP74;
			end
			BP74:
			begin
				if (count1 < LAYR2_CELL-1)
				begin
					count1 <= count1 + 1;
					state <= BP75;
				end
				else
				begin
					count1 <= 8'd0;
					state <= BP76;
				end
			end
			BP75:
			begin
				state <= BP64;
			end
			BP76: // identical to 34 but w/0 en_delta2
			begin
				state <= BP35;
			end
			BP77: // last idle state
			begin
				state <= BP77;
			end
		endcase
	end
end

endmodule