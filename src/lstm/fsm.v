<<<<<<< HEAD
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//            
///////////////////////////////////////////////////////////////////////////////
module fsm (clk, en, en_addr_dgates_2, en_addr_w_bp_2, rst_addr_dgates, rst_fsm,  rst, rst_2, rst_acc, rst_mac, update, acc_x_1, acc_x_2, acc_h_1, acc_h_2, wr_h1, wr_h2,  wr_c1, wr_c2, wr_act_1, wr_act_2,
wr_dstate1, wr_dstate2, sel_in1, sel_in2, sel_in3, sel_in4, sel_in5, sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp,
acc_da, acc_di, acc_df, acc_do, acc_mac, sel_dgate, sel_state, sel_dstate, sel_dout, sel_wght, sel_wghts1, sel_wghts2,sel_a, sel_i, sel_f, sel_o, sel_h, sel_t, wr_da1, wr_di1, 
wr_df1, wr_do1, wr_da2, wr_di2, wr_df2, wr_do2, wr_dx2, wr_dout2, wr_dout1);

//common ports
input clk, rst_fsm;

output reg en, en_addr_dgates_2, en_addr_w_bp_2, rst_addr_dgates, rst, rst_2, rst_acc, rst_mac;
output reg update;

//output ports
output reg acc_x_1, acc_h_1, acc_x_2, acc_h_2;
output reg wr_h1;
output reg wr_c1;
output reg wr_act_1;
output reg wr_act_2;
output reg wr_h2;
output reg wr_c2;
output reg sel_a;
output reg sel_i;
output reg sel_f;
output reg sel_o;
output reg sel_h;
output reg sel_t;
output reg sel_state;
output reg sel_dstate;
output reg sel_dout;
output reg [1:0] sel_in1;
output reg [1:0] sel_in2;
output reg sel_in3;
output reg [1:0] sel_in4;
output reg [2:0] sel_in5;
output reg [1:0] sel_x1_1;
output reg sel_x1_2;
output reg [1:0] sel_x2_2;
output reg sel_as_1;
output reg [1:0] sel_as_2;
output reg sel_addsub;
output reg [1:0] sel_temp;

output reg acc_da, acc_di, acc_df, acc_do;
output reg acc_mac;
 
output reg [1:0] sel_dgate;

output reg sel_wght;
output reg [1:0] sel_wghts1;
output reg [2:0] sel_wghts2;
output reg wr_da1, wr_di1, wr_df1, wr_do1, wr_dstate1;

output reg wr_da2, wr_di2, wr_df2, wr_do2, wr_dstate2;

output reg wr_dx2, wr_dout2, wr_dout1;

reg [7:0] state;
reg [7:0] count, counter_cell, counter_layer, counter_timestep;


parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9,  
S10=10, S11=11, S12=12, S13=13, S14=14, S15=15, S16=16, S17=17, S18=18, 
S19=19, S20=20, S21=21, S22=22, S23=23, S24=24, S25=25, S26=26, S27=27, 
S28=28, S29=29, S30=30, S31=31, S32=32, S33=33, S34=34, S35=35, S36=36, 
S37=37, S38=38, S39=39, S40=40, S41=41, S42=42, S43=43, S44=44, S45=45, 
S46=46, S47=47, S48=48, S49=49, S50=50, S51=51, S52=52, S53=53, S54=54, 
S55=55, S56=56, S57=57, S58=58, S59=59, S60=60, S61=61, S62=62, S63=63, 
S64=64, S65=65, S66=66, S67=67, S68=68, S69=69, S70=70, S71=71, S72=72, 
S73=73, S74=74, S75=75, S76=76, S77=77, S78=78, S79=79, S80=80, S81=81, 
S82=82, S83=83, S84=84, S85=85, S86=86, S87=87;


always @(state) 
begin
	 case (state)
               //INITIAL START //
		S0:
		begin
			rst <= 1;
			rst_2 <= 1;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=0;
		end
		S1:
		begin
			rst <=0;
			rst_2 <=1;
			en <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=0;
		end
		S2:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			rst_2 <=1;
			rst <= 0;
		end

		S3:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			en <=1; 
		end
		// start computing for first layer -- repeat 53x -------------//
		S4:
		begin
			en <=1;
			update <=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
			rst <=0;
			rst_2 <=1;			
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;

		end
		S5:
		begin

			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end
		S6:
		begin
			//enable write h
			rst <=1;
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end
		S7:
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst<=0;
		end
		// ----------------------------------------------------------//

		// start computing for the 2nd and 1st layer - repeat 8x ----//
		S8: // repeat 8x
		begin
			acc_x_2 <=1;
			acc_h_2 <=1;
			acc_x_1 <=1;
       		acc_h_1 <=1;
       		rst_2 <= 0;
       		rst <=0;
		end

		S9: //repeat 45x
		begin
			acc_x_2 <=1;
			acc_h_2 <=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S10:
		begin
			acc_x_2<=0;
			acc_h_2<=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S11:
		begin
			wr_h2 <=1;
			wr_c2 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_2 <=1;
		end

		S12:
		begin
			wr_h2 <=0;
			wr_c2 <=0;
			wr_c1 <= 0; 
			wr_act_2 <=0;
		end

		// ---------------------------------------------//


		// -------start computing for first layer----repeat 45x ----//
		S13:
		begin
			acc_x_1 <=1;
			acc_h_1 <=1;
			rst <=0;
		end

		S14:
		begin
			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end

		S15 :
		begin
			//enable write h
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end

		S16 :
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
		end

		//----- start backprop ------//

		S17:
		begin
			rst <= 1;
			rst_acc <= 1;

			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b0;
			acc_mac <= 1'b0;
	
			wr_dx2 <= 1'b0;
		end
		//-------repeat 7x ----------//
		S18:
		/////////////// START LAYER 2 DELTA ///////////////////
		////////////// 1 ST  CELL ////////////////////////////
		begin
			rst <= 0;
			rst_acc <= 0;
			rst_addr_dgates <=1'b1;
			en_addr_dgates_2 <= 1'b1;
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
		end
		S19 :
		begin
			
			rst <= 0;
			rst_acc <= 0;
			rst_addr_dgates <=1'b1;
			en_addr_dgates_2 <= 1'b1;
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
		end
		S20:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
		S21:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end

		S22:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end					
		S23:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
			
		end

		S25:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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

		end
		
		S26:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end

		S27:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end

		S28:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end

		S29:
		begin

		// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end

		S30:
		begin
			en_addr_dgates_2 <= 1'b1;
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

		end

		//////////////// 2 ND TO LAST CELL ///////////////////////
		// repeat(8-1)----------------/////////////////

		S31:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end
			

		S32:
		begin
			// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
			sel_a <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			

		S33:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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



		end
			

		S34:
		begin
			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			

		S35:
		begin
			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			

		S36:
		begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			

		S37:
		begin

			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
		S38:
		begin
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			
	
		S39:
		begin			
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			
			// $display("dat <= %h \n", o_dgate);

		S40:
		begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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
		end
			
			// $display("dit <= %h \n", o_dgate);

		S41:
		begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
			en_addr_dgates_2 <= 1'b1;
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

			rst_mac <= 1'b1;
		end
			
		S42:
		begin
			wr_da2 <= 1'b0;
			en_addr_dgates_2 <= 1'b1;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;
			rst_mac <= 1'b0;
			acc_mac <= 1'b1;

		end
		////////////////// END LAYER 2 DELTA ///////////////////////////

		// REPEAT 53-1 //

		S43:
		begin
			wr_da2 <= 1'b0;
			en_addr_dgates_2 <= 1'b0;
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
		end


		S44:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S45:
		begin

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S46:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

		end

	
		S47:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
		end

		
		//---------------------/
		
		// Last Repeat to change mux on last cycle
		S48:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b001;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;	
		end

		S49:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S50:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S51:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;
	
		end	

		S52:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			sel_wghts2 <= 3'b100;
		end
		
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		//REPEAT 8X //

		S53:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b101;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end		
	

		S54:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

		S55:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

			
		S56:
		begin		
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

		end
	
		S57:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
		end

		//------///

		///////////////// START  CALCULATE LAYER 1 DELTA /////////////////////////
		//////////////// 1 ST CELL //////////////////////////////////////////////
		S58:
		begin
			rst <= 0;
			rst_acc <= 1;
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
		end 


		S59:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 2
		S60:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 3
		S61:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 4
		S62:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// CLOCK 5
		S63:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		

		// CLOCK 6
		S64:
		begin
			rst <= 0;
			rst_acc <= 0;
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

		end

		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
		S65:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		
		S66:
		begin
		// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
		end
				// $display("dat <= %h \n", o_dgate);

		// CLOCK 9
		S67:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// $display("dit <= %h \n", o_dgate);


		// CLOCK 10
		S68:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		S69:
		begin
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;
		end
		
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL //////////////////////

		// -----REPEAT 53-1------//


		S70:
		begin

			rst <= 0;
			rst_acc <= 0;
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
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end


		S71:
		begin
		// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
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
		end

		S72:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
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
			end

		S73:
		begin
		// CLOCK 3
		rst <= 0;
		rst_acc <= 0;
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
		end

		S74:
		begin
		// CLOCK 4
		rst <= 0;
		rst_acc <= 0;
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
		end
			S75:
			begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
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
			end
			S76:
			begin
			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
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

			end
			// $display("dot <= %h \n", o_dgate);
			S77:
			begin
			// CLOCK 7
			rst <= 0;
			rst_acc <= 0;
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
			end
			S78:
			begin
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dat <= %h \n", o_dgate);
			S79:
			begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dit <= %h \n", o_dgate);

			S80:
			begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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
			end

		S81:
		begin
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

		end
		//-----------------------//
		////////////////// END LAYER 1 DELTA ///////////////////////////

		///////////////// START  CALCULATE dOut2 /////////////////////////

		//---- repeat 53x----//

		S82:
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
		end

		S83:
		begin
			sel_dgate <= 2'b10;
			sel_wghts1 <= 2'b10;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end


		S84:
		begin	
			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end

		
		S85:
		begin
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;
		end

		
		S86:
		begin
			rst_mac = 1'b1;
			wr_dout1 <= 1'b0;	
		end


		 ///---------------/////////
		//// CONDITIONING FOR NEXT TIME STEP

		S87:
		begin
			rst <= 1;
			rst_acc <= 1;
		end
                   
		default:
		begin
			rst <= 1;
			rst_2 <=1;
			rst_acc <=1;
			rst_mac <=1;
		end

    endcase
end

always @(posedge clk or posedge rst_fsm)

begin
      if (rst_fsm)
           state <= S0;
      else
      begin
           case (state)
                S0:
                begin
                    counter_cell <= 8'd0;
                  	counter_layer <= 8'd0;
                    counter_timestep <= 8'd0;
                    state <= S1;
                end
                S1:
                begin
                    counter_cell <= 8'd0;
                    counter_layer <= 8'd0;
                    counter_timestep <= 8'd0;
                    state <= S2;
                end
               	S2:
                begin
                    counter_cell <= 8'd0;
                    counter_layer <= 8'd0;
                    counter_timestep <= 8'd0;
                    state <= S3;
                end
                S3:
                begin
                    counter_cell <= counter_cell+1;
                    counter_layer <= 8'd0;
                    counter_timestep <= 8'd0;
                    state <= S4;
                end

                S4:
                begin
                   if (counter_cell <= 8'd52)
                   begin
                        state <= S4;
                		counter_cell <= counter_cell+1; 

                   end
                   else 
                   begin
                    	counter_cell <= 8'd0;
                    	state <= S5;
                   end
                end

                S5:
                begin
                    counter_cell <= 8'd0;
                    state <= S6;
                end
                S6:
                begin
                    counter_cell <= 8'd0;
                    state <= S7;
                end
                S7:
                begin
                	if (counter_layer != 8'd51)
                	begin
                		counter_layer <= counter_layer +1; 
                    	state <= S4;
                    end
                    else begin
                    	counter_layer <= 8'd0;
                    	state <= S8;
                    end
                end
                // forward second and first cell
                S8:
                begin
                   if (counter_cell <= 8'd7)
                   begin
                		counter_cell <= counter_cell+1; 
                    	state <= S8;
                   end
                   else begin
                    	counter_cell <= 8'd0;
                    	state <= S9;
                   end
                end
                S9:
                begin
                   if (counter_cell <= 8'd44)
                   begin
                		counter_cell <= counter_cell+1; 
                    	state <= S9;
                    end
                   else begin
                    	counter_cell <= 8'd0;
                    	state <= S10;
                   end
                end
                S10:
                begin
                    counter_cell <= 8'd0;
                    state <= S11;
                end
                S11:
                begin
                	counter_cell <= 8'd0;
                    state <= S12;
                end
                S12:
                begin
                	if (counter_layer <= 8'd7)
                	begin
                		counter_layer <= counter_layer+1; 
                    	state <= S8;
                    end
                    else begin
                    	counter_layer <= 8'd0;
                    	state <= S13;
                    end
                end

                S13:
                begin
                   if (counter_cell <= 8'd52)
                   begin
                		counter_cell <= counter_cell+1; 
                    	state <= S13;
                   end
                   else begin
                    	counter_cell <= 8'd0;
                    	state <= S14;
                   end
                end
                S14:
                begin
                    counter_cell <= 8'd0;
                    state <= S15;
                end
                S15:
                begin
                    counter_cell <= 8'd0;
                    state <= S16;
                end
                S16:
                begin
                	if (counter_layer != 8'd44)
                	begin
                		counter_layer <= counter_layer+1; 
                    	state <= S13;
                    end
                    else if (counter_timestep!= 8'd6)
                    begin
                    	counter_timestep <= counter_timestep+1;
                    	state <= S14;
                    end
                    else
                    begin
                    	counter_layer <= 8'd0;
                    	state <= S17;
                    end
                end

                S17:
                begin
                    count <= 8'd0;
                    state <= S18;
                end

				S18:
                begin
                    count <= 8'd0;
                    state <= S19;
                end

                S19:
                begin
                    count <= 8'd0;
                    state <= S20;
                end

                S20:
                begin
                    count <= 8'd0;
                    state <= S21;
                end
                S21:
                begin
                    count <= 8'd0;
                    state <= S22;
                end
                S22:
                begin
                    count <= 8'd0;
                    state <= S23;
                end
                S23:
                begin
                    count <= 8'd0;
                    state <= S24;
                end
                S24:
                begin
                    count <= 8'd0;
                    state <= S25;
                end
                S25:
                begin
                    count <= 8'd0;
                    state <= S26;
                end
                S26:
                begin
                    count <= 8'd0;
                    state <= S27;
                end
                S27:
                begin
                    count <= 8'd0;
                    state <= S28;
                end
                S28:
                begin
                    count <= 8'd0;
                    state <= S29;
                end
                S29:
                begin
                    count <= 8'd0;
                    state <= S30;
                end
                S30:
                begin
                	state <= S31;
                end
                S31:
                begin
                	count<=8'd0;
                	state <= S32;
                end
                S32:
                begin
                	count<=8'd0;
                	state <= S33;
                end
                S33:
                begin
                	count<=8'd0;
                	state <= S34;
                end
                S34:
                begin
                	count<=8'd0;
                	state <= S35;
                end
                S35:
                begin
                	count<=8'd0;
                	state <= S36;
                end
                S36:
                begin
                	count<=8'd0;
                	state <= S37;
                end
                S37:
                begin
                	count<=8'd0;
                	state <= S38;
                end
                S38:
                begin
                	count<=8'd0;
                	state <= S39;
                end
                S39:
                begin
                	count<=8'd0;
                	state <= S40;
                end
                S40:
                begin
                	count<=8'd0;
                	state <= S41;
                end
                S41:
                begin
                	count<=8'd0;
                	state <= S42;
                end
                //-----------REPEAT 53-1--------///
                S42:
                begin
                	count<=8'd0;
                	state <= S43;
                end
                S43:
                begin
                	count<=8'd0;
                	state <= S44;
                end
                S44:
                begin
                	count<=8'd0;
                	state <= S45;
                end
                S45:
                begin
                	count<=8'd0;
                	state <= S46;
                end
                S46:
                begin
                	if (count<= 8'd51 )
                	begin
                		count <= count+1;
                		state <= S42;
                	end
                	else begin
                		count <= 8'd0;
                		state <= S47;
                	end
                end
                S47:
                begin
                	count<=8'd0;
                	state <= S48;
                end
                S48:
                begin
                	count<=8'd0;
                	state <= S49;
                end
                S49:
                begin
                	count<=8'd0;
                	state <= S50;
                end
                S50:
                begin
                	count<=8'd0;
                	state <= S51;
                end
                S51:
                begin
                	state <= S52;

                end
                S52:
                begin
                	state <= S53;

                end
                S53:
                begin
                	state <= S54;

                end
                S54:
                begin
                	state <= S55;

                end
                S55:
                begin
                	state <= S56;

                end
                S56:
                begin
                	if (count <=8'd7)
                	begin
                		count <= count+1;
                		state <= 52;
                	end
                	else begin
                		state <= 57;
                	end

                end
                S57:
                begin
                	state <= S58;

                end
                S58:
                begin
                	state <= S59;

                end
                S59:
                begin
                	state <= S60;

                end
                S60:
                begin
                	state <= S61;
         		end

                S61:
                begin
                	state <= S62;

                end
                S62:
                begin
                	state <= S63;

                end
                S63:
                begin
                	state <= S64;

                end
                S64:
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
				    	state <= S75;

				    end
				S75:
				    begin
				    	state <= S76;

				    end
				S76:
				    begin
				    	state <= S77;

				    end
				S77:
				    begin
				    	state <= S78;

				    end
				S78:
				    begin
				    	state <= S79;

				    end
				S79:
				    begin
				    	state <= S80;

				    end
				S80:
				    begin
				    	if (count<=8'd51)
				    	begin
				    		count <= count+1;
				    		state <= S69;
				    	end
				    	else begin
				    		state <= S81;
				    	end
				    end
			
				S81:
				    begin
				    	state <= S82;

				    end
				S82:
				    begin
				    	state <= S83;

				    end
				S83:
				    begin
				    	state <= S84;

				    end
				S84:
				    begin
				    	state <= S85;

				    end
				S85:
				    begin
				    	state <= S86;
				    end
				S86:
				    begin
				    	if (count <= 8'd6)
				    	begin
				    		count <= count+1;
				    		state <= S18;
				    	end
				    	else 
				    	begin
				    		state <=S86;
				    	end
				    end
    		endcase
    	end
end

endmodule



				//
//
				// S20:
				// begin
				// 	rst_2 <=0;
				// 	rst <=0;
				// 	rst_2 <=0;
				// 	rst <=1;
				// 	wr_h2 <=0;
				// 	lstm_2 <=0;
				// end
				// S21:
				// begin
				// 	rst_2 <=1;
				// 	rst <= 0;
				// end



////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//            
///////////////////////////////////////////////////////////////////////////////
module fsm (clk, en, rst_fsm,  rst, rst_2, rst_acc, rst_mac, update, acc_x_1, acc_x_2, acc_h_1, acc_h_2, wr_h1, wr_h2,  wr_c1, wr_c2, wr_act_1, wr_act_2,
wr_dstate1, wr_dstate2, sel_in1, sel_in2, sel_in3, sel_in4, sel_in5, sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp,
acc_da, acc_di, acc_df, acc_do, acc_mac, sel_dgate, sel_state, sel_dstate, sel_dout, sel_wght, sel_wghts1, sel_wghts2,sel_a, sel_i, sel_f, sel_o, sel_h, sel_t, wr_da1, wr_di1, 
wr_df1, wr_do1, wr_da2, wr_di2, wr_df2, wr_do2, wr_dx2, wr_dout2, wr_dout1);

//common ports
input clk, rst_fsm;

output reg en, rst, rst_2, rst_acc, rst_mac;
output reg update;

//output ports
output reg acc_x_1, acc_h_1, acc_x_2, acc_h_2;
output reg wr_h1;
output reg wr_c1;
output reg wr_act_1;
output reg wr_act_2;
output reg wr_h2;
output reg wr_c2;
output reg sel_a;
output reg sel_i;
output reg sel_f;
output reg sel_o;
output reg sel_h;
output reg sel_t;
output reg sel_state;
output reg sel_dstate;
output reg sel_dout;
output reg [1:0] sel_in1;
output reg [1:0] sel_in2;
output reg sel_in3;
output reg [1:0] sel_in4;
output reg [2:0] sel_in5;
output reg [1:0] sel_x1_1;
output reg sel_x1_2;
output reg [1:0] sel_x2_2;
output reg sel_as_1;
output reg [1:0] sel_as_2;
output reg sel_addsub;
output reg [1:0] sel_temp;

output reg acc_da, acc_di, acc_df, acc_do;
output reg acc_mac;
 
output reg [1:0] sel_dgate;

output reg sel_wght;
output reg [1:0] sel_wghts1;
output reg [2:0] sel_wghts2;
output reg wr_da1, wr_di1, wr_df1, wr_do1, wr_dstate1;

output reg wr_da2, wr_di2, wr_df2, wr_do2, wr_dstate2;

output reg wr_dx2, wr_dout2, wr_dout1;

reg [7:0] state;
reg [7:0] count;


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


always @(posedge clk)// or posedge rst_fsm ) 
begin

    
    
	 case (state)
               //INITIAL START //
		S0:
		begin
			rst <= 1;
			rst_2 <= 1;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=1;
		end
		S1:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=1;
		end
		S2:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			rst_2 <=1;
			rst <= 0;
		end

		S3:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			en <=1; 
		end
		// start computing for first layer -- repeat 53x -------------//
		S4:
		begin
			rst <=0;
			rst_2 <=0;			
			en <=1;
			acc_x_1 <=1;
			acc_h_1 <=1;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;

		end
		S5:
		begin

			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end
		S6:
		begin
			//enable write h
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end
		S7:
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
		end
		// ----------------------------------------------------------//

		// start computing for the 2nd and 1st layer - repeat 8x ----//
		S8: // repeat 8x
		begin
			acc_x_2 <=1;
			acc_h_2 <=1;
			acc_x_1 <=1;
       		acc_h_1 <=1;
       		rst_2 <= 0;
       		rst <=0;
		end

		S9: //repeat 45x
		begin
			acc_x_2 <=1;
			acc_h_2 <=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S10:
		begin
			acc_x_2<=0;
			acc_h_2<=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S11:
		begin
			wr_h2 <=1;
			wr_c2 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_2 <=1;
		end

		S12:
		begin
			wr_h2 <=0;
			wr_c2 <=0;
			wr_c1 <= 0; 
			wr_act_2 <=0;
		end

		// ---------------------------------------------//


		// -------start computing for first layer----repeat 45x ----//
		S13:
		begin
			acc_x_1 <=1;
			acc_h_1 <=1;
			rst <=0;
		end

		S14:
		begin
			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end

		S15 :
		begin
			//enable write h
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end

		S16 :
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
		end

		//----- start backprop ------//

		S17:
		begin
			rst <= 1;
			rst_acc <= 1;

			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b0;
			acc_mac <= 1'b0;
	
			wr_dx2 <= 1'b0;
		end
		//-------repeat 7x ----------//
		S18:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		S19 :
		begin
			
			rst <= 0;
			rst_acc <= 0;
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
		end
		S20:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		S21:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S22:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end					
		S23:
		begin
			rst_acc <= 0;
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
			
		end

		S25:
		begin
			rst <= 0;
			rst_acc <= 0;
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

		end
		
		S26:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S27:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S28:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S29:
		begin

		// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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
		end

		S30:
		begin

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

		end

		//////////////// 2 ND TO LAST CELL ///////////////////////
		// repeat(8-1)----------------


		S31:
		begin
			rst <= 0;
			rst_acc <= 0;
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
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end
			

		S32:
		begin
			// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S33:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
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



		end
			

		S34:
		begin
			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S35:
		begin
			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S36:
		begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S37:
		begin

			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
		S38:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
			
	
		S39:
		begin			
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dat <= %h \n", o_dgate);

		S40:
		begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dit <= %h \n", o_dgate);

		S41:
		begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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

			rst_mac <= 1'b1;
			

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

			rst_mac <= 1'b0;
			acc_mac <= 1'b1;

		end

		// REPEAT 53-1 //

		S42:
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
		end


		S43:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S44:
		begin

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S45:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

		end

	
		S46:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
		end

		
		//---------------------/
		
		// Last Repeat to change mux on last cycle
		S47:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b001;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;	
		end

		S48:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S49:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S50:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;
	
		end	

		S51:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			sel_wghts2 <= 3'b100;
		end
		
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		//REPEAT 8X //

		S52:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b101;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end		
	

		S53:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

		S54:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

			
		S55:
		begin		
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

		end
	
		S56:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
		end

		//------///

		///////////////// START  CALCULATE LAYER 1 DELTA /////////////////////////
		//////////////// 1 ST CELL //////////////////////////////////////////////
		S57:
		begin
			rst <= 0;
			rst_acc <= 1;
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
		end 


		S58:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 2
		S59:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 3
		S60:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 4
		S61:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// CLOCK 5
		S62:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		

		// CLOCK 6
		S63:
		begin
			rst <= 0;
			rst_acc <= 0;
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

		end

		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
		S64:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		
		S65:
		begin
		// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
		end
				// $display("dat <= %h \n", o_dgate);

		// CLOCK 9
		S66:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// $display("dit <= %h \n", o_dgate);


		// CLOCK 10
		S67:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		S68:
		begin
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;
		end
		
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL //////////////////////

		// -----REPEAT 53-1------//


		S69:
		begin

			rst <= 0;
			rst_acc <= 0;
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
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end


		S70:
		begin
		// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
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
		end

		S71:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
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
			end

			S72:
			begin
			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
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

			end
			S73:
			begin
			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
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
			end
			S74:
			begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
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
			end
			S75:
			begin
			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
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

			end
			// $display("dot <= %h \n", o_dgate);
			S76:
			begin
			// CLOCK 7
			rst <= 0;
			rst_acc <= 0;
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
			end
			S77:
			begin
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dat <= %h \n", o_dgate);
			S78:
			begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dit <= %h \n", o_dgate);

			S79:
			begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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
			end

		S80:
		begin
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

		end
		//-----------------------//
		////////////////// END LAYER 1 DELTA ///////////////////////////

		///////////////// START  CALCULATE dOut2 /////////////////////////

		//---- repeat 53x----//

		S81:
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
		end

		S82:
		begin
			sel_dgate <= 2'b10;
			sel_wghts1 <= 2'b10;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end


		S83:
		begin	
			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end

		
		S84:
		begin
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;
		end

		
		S85:
		begin
			rst_mac = 1'b1;
			wr_dout1 <= 1'b0;	
		end


		 ///---------------/////////
		//// CONDITIONING FOR NEXT TIME STEP

		S86:
		begin
			rst <= 1;
			rst_acc <= 1;
		end
                   
		default:
		begin
			rst <= 1;
			rst_2 <=1;
			rst_acc <=1;
			rst_mac <=1;
		end

    endcase
end

always @(posedge clk or posedge rst_fsm)

begin
      if (rst_fsm)
           state <= S0;
      else
      begin
           case (state)
                S0:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S1:
                begin
                    count <= 5'd0;
                    state <= S2;
                end
               	S2:
                begin
                    count <= 5'd0;
                    state <= S3;
                end
                S3:
                begin
                    count <= 5'd0;
                    state <= S4;
                end

                S4:
                begin
                   if (count <= 5'd52)
                   begin
                		count <= count+1; 
                    	state <= S4;
                   end
                   else 
                   begin
                    	count <= 5'd0;
                    	state <= S5;
                   end
                end

                S5:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S6:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S7:
                begin
                	if (count <= 5'd52)
                	begin
                		count <= count+1; 
                    	state <= S4;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S8;
                    end
                end

                S8:
                begin
                   if (count <= 5'd7)
                   begin
                		count <= count+1; 
                    	state <= S8;
                   end
                   else begin
                    	count <= 5'd0;
                    	state <= S9;
                   end
                end
                S9:
                begin
                   if (count <= 5'd44)
                   begin
                		count <= count+1; 
                    	state <= S10;
                    end
                   else begin
                    	count <= 5'd0;
                    	state <= S9;
                   end
                end
                S10:
                begin
                    count <= 5'd0;
                    state <= S11;
                end
                S11:
                begin
                	count <= 5'd0;
                    state <= S12;
                end
                S12:
                begin
                	if (count <= 5'd7)
                	begin
                		count <= count+1; 
                    	state <= S8;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S13;
                    end
                end

                S13:
                begin
                   if (count <= 5'd52)
                   begin
                		count <= count+1; 
                    	state <= S4;
                   end
                   else begin
                    	count <= 5'd0;
                    	state <= S5;
                   end
                end
                S14:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S15:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S16:
                begin
                	if (count <= 5'd44)
                	begin
                		count <= count+1; 
                    	state <= S13;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S17;
                    end
                end

                S17:
                begin
                    count <= 5'd0;
                    state <= S18;
                end

				S18:
                begin
                    count <= 5'd0;
                    state <= S19;
                end

                S19:
                begin
                    count <= 5'd0;
                    state <= S20;
                end

                S20:
                begin
                    count <= 5'd0;
                    state <= S21;
                end
                S21:
                begin
                    count <= 5'd0;
                    state <= S22;
                end
                S22:
                begin
                    count <= 5'd0;
                    state <= S23;
                end
                S23:
                begin
                    count <= 5'd0;
                    state <= S24;
                end
                S24:
                begin
                    count <= 5'd0;
                    state <= S25;
                end
                S25:
                begin
                    count <= 5'd0;
                    state <= S26;
                end
                S26:
                begin
                    count <= 5'd0;
                    state <= S27;
                end
                S27:
                begin
                    count <= 5'd0;
                    state <= S28;
                end
                S28:
                begin
                    count <= 5'd0;
                    state <= S29;
                end
                S29:
                begin
                    count <= 5'd0;
                    state <= S30;
                end
                S30:
                begin
                	state <= S31;
                end
                S31:
                begin
                	count<=5'd0;
                	state <= S32;
                end
                S32:
                begin
                	count<=5'd0;
                	state <= S33;
                end
                S33:
                begin
                	count<=5'd0;
                	state <= S34;
                end
                S34:
                begin
                	count<=5'd0;
                	state <= S35;
                end
                S35:
                begin
                	count<=5'd0;
                	state <= S36;
                end
                S36:
                begin
                	count<=5'd0;
                	state <= S37;
                end
                S37:
                begin
                	count<=5'd0;
                	state <= S38;
                end
                S38:
                begin
                	count<=5'd0;
                	state <= S39;
                end
                S39:
                begin
                	count<=5'd0;
                	state <= S40;
                end
                S40:
                begin
                	count<=5'd0;
                	state <= S41;
                end
                S41:
                begin
                	count<=5'd0;
                	state <= S42;
                end
                //-----------REPEAT 53-1--------///
                S42:
                begin
                	count<=5'd0;
                	state <= S43;
                end
                S43:
                begin
                	count<=5'd0;
                	state <= S44;
                end
                S44:
                begin
                	count<=5'd0;
                	state <= S45;
                end
                S45:
                begin
                	count<=5'd0;
                	state <= S46;
                end
                S46:
                begin
                	if (count<= 5'd51 )
                	begin
                		count <= count+1;
                		state <= S42;
                	end
                	else begin
                		count <= 5'd0;
                		state <= S47;
                	end
                end
                S47:
                begin
                	count<=5'd0;
                	state <= S48;
                end
                S48:
                begin
                	count<=5'd0;
                	state <= S49;
                end
                S49:
                begin
                	count<=5'd0;
                	state <= S50;
                end
                S50:
                begin
                	count<=5'd0;
                	state <= S51;
                end
                S51:
                begin
                	state <= S52;

                end
                S52:
                begin
                	state <= S53;

                end
                S53:
                begin
                	state <= S54;

                end
                S54:
                begin
                	state <= S55;

                end
                S55:
                begin
                	state <= S56;

                end
                S56:
                begin
                	if (count <=5'd7)
                	begin
                		count <= count+1;
                		state <= 52;
                	end
                	else begin
                		state <= 57;
                	end

                end
                S57:
                begin
                	state <= S58;

                end
                S58:
                begin
                	state <= S59;

                end
                S59:
                begin
                	state <= S60;

                end
                S60:
                begin
                	state <= S61;
         		end

                S61:
                begin
                	state <= S62;

                end
                S62:
                begin
                	state <= S63;

                end
                S63:
                begin
                	state <= S64;

                end
                S64:
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
				    	state <= S75;

				    end
				S75:
				    begin
				    	state <= S76;

				    end
				S76:
				    begin
				    	state <= S77;

				    end
				S77:
				    begin
				    	state <= S78;

				    end
				S78:
				    begin
				    	state <= S79;

				    end
				S79:
				    begin
				    	state <= S80;

				    end
				S80:
				    begin
				    	if (count<=5'd51)
				    	begin
				    		count <= count+1;
				    		state <= S69;
				    	end
				    	else begin
				    		state <= S81;
				    	end
				    end
			
				S81:
				    begin
				    	state <= S82;

				    end
				S82:
				    begin
				    	state <= S83;

				    end
				S83:
				    begin
				    	state <= S84;

				    end
				S84:
				    begin
				    	state <= S85;

				    end
				S85:
				    begin
				    	state <= S86;
				    end
				S86:
				    begin
				    	if (count <= 8'd6)
				    	begin
				    		count <= count+1;
				    		state <= S18;
				    	end
				    	else 
				    	begin
				    		state <=S86;
				    	end
				    end
    		endcase
    	end
end

endmodule



				//
//
				// S20:
				// begin
				// 	rst_2 <=0;
				// 	rst <=0;
				// 	rst_2 <=0;
				// 	rst <=1;
				// 	wr_h2 <=0;
				// 	lstm_2 <=0;
				// end
				// S21:
				// begin
				// 	rst_2 <=1;
				// 	rst <= 0;
				// end


=======

////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//            
///////////////////////////////////////////////////////////////////////////////
module fsm (clk, en, rst_fsm,  rst, rst_2, rst_acc, rst_mac, update, acc_x_1, acc_x_2, acc_h_1, acc_h_2, wr_h1, wr_h2,  wr_c1, wr_c2, wr_act_1, wr_act_2,
wr_dstate1, wr_dstate2, sel_in1, sel_in2, sel_in3, sel_in4, sel_in5, sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp,
acc_da, acc_di, acc_df, acc_do, acc_mac, sel_dgate, sel_state, sel_dstate, sel_dout, sel_wght, sel_wghts1, sel_wghts2,sel_a, sel_i, sel_f, sel_o, sel_h, sel_t, wr_da1, wr_di1, 
wr_df1, wr_do1, wr_da2, wr_di2, wr_df2, wr_do2, wr_dx2, wr_dout2, wr_dout1);

//common ports
input clk, rst_fsm;

output reg en, rst, rst_2, rst_acc, rst_mac;
output reg update;

//output ports
output reg acc_x_1, acc_h_1, acc_x_2, acc_h_2;
output reg wr_h1;
output reg wr_c1;
output reg wr_act_1;
output reg wr_act_2;
output reg wr_h2;
output reg wr_c2;
output reg sel_a;
output reg sel_i;
output reg sel_f;
output reg sel_o;
output reg sel_h;
output reg sel_t;
output reg sel_state;
output reg sel_dstate;
output reg sel_dout;
output reg [1:0] sel_in1;
output reg [1:0] sel_in2;
output reg sel_in3;
output reg [1:0] sel_in4;
output reg [2:0] sel_in5;
output reg [1:0] sel_x1_1;
output reg sel_x1_2;
output reg [1:0] sel_x2_2;
output reg sel_as_1;
output reg [1:0] sel_as_2;
output reg sel_addsub;
output reg [1:0] sel_temp;

output reg acc_da, acc_di, acc_df, acc_do;
output reg acc_mac;
 
output reg [1:0] sel_dgate;

output reg sel_wght;
output reg [1:0] sel_wghts1;
output reg [2:0] sel_wghts2;
output reg wr_da1, wr_di1, wr_df1, wr_do1, wr_dstate1;

output reg wr_da2, wr_di2, wr_df2, wr_do2, wr_dstate2;

output reg wr_dx2, wr_dout2, wr_dout1;

reg [7:0] state;
reg [7:0] count;


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


always @(posedge clk or posedge rst_fsm ) 
begin
	 case (state)
               //INITIAL START //
		S0:
		begin
			rst <= 1;
			rst_2 <= 1;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=1;
		end
		S1:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=1;
		end
		S2:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			rst_2 <=1;
			rst <= 0;
		end

		S3:
		begin
			rst <=0;
			rst_2 <=0;
			acc_x_1 <=0;
			acc_h_1 <=0;
			acc_x_2 <=0;
			acc_h_2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			en <=1; 
		end
		// start computing for first layer -- repeat 53x -------------//
		S4:
		begin
			rst <=0;
			rst_2 <=0;			
			en <=1;
			acc_x_1 <=1;
			acc_h_1 <=1;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;

		end
		S5:
		begin

			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end
		S6:
		begin
			//enable write h
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end
		S7:
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
		end
		// ----------------------------------------------------------//

		// start computing for the 2nd and 1st layer - repeat 8x ----//
		S8: // repeat 8x
		begin
			acc_x_2 <=1;
			acc_h_2 <=1;
			acc_x_1 <=1;
       		acc_h_1 <=1;
       		rst_2 <= 0;
       		rst <=0;
		end

		S9: //repeat 45x
		begin
			acc_x_2 <=1;
			acc_h_2 <=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S10:
		begin
			acc_x_2<=0;
			acc_h_2<=0;
			acc_x_1 <=1;
			acc_h_1 <=1;
		end

		S11:
		begin
			wr_h2 <=1;
			wr_c2 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_2 <=1;
		end

		S12:
		begin
			wr_h2 <=0;
			wr_c2 <=0;
			wr_c1 <= 0; 
			wr_act_2 <=0;
		end

		// ---------------------------------------------//


		// -------start computing for first layer----repeat 45x ----//
		S13:
		begin
			acc_x_1 <=1;
			acc_h_1 <=1;
			rst <=0;
		end

		S14:
		begin
			acc_x_1 <= 0;
			acc_x_1 <= 0;
		end

		S15 :
		begin
			//enable write h
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
		end

		S16 :
		begin
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
		end

		//----- start backprop ------//

		S17:
		begin
			rst <= 1;
			rst_acc <= 1;

			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b0;
			acc_mac <= 1'b0;
	
			wr_dx2 <= 1'b0;
		end
		//-------repeat 7x ----------//
		S18:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		S19 :
		begin
			
			rst <= 0;
			rst_acc <= 0;
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
		end
		S20:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		S21:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S22:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end					
		S23:
		begin
			rst_acc <= 0;
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
			
		end

		S25:
		begin
			rst <= 0;
			rst_acc <= 0;
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

		end
		
		S26:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S27:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S28:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		S29:
		begin

		// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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
		end

		S30:
		begin

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

		end

		//////////////// 2 ND TO LAST CELL ///////////////////////
		// repeat(8-1)----------------


		S31:
		begin
			rst <= 0;
			rst_acc <= 0;
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
			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b0;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end
			

		S32:
		begin
			// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S33:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
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



		end
			

		S34:
		begin
			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S35:
		begin
			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S36:
		begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
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
		end
			

		S37:
		begin

			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
		S38:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
			
	
		S39:
		begin			
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dat <= %h \n", o_dgate);

		S40:
		begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
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
		end
			
			// $display("dit <= %h \n", o_dgate);

		S41:
		begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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

			rst_mac <= 1'b1;
			

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

			rst_mac <= 1'b0;
			acc_mac <= 1'b1;

		end

		// REPEAT 53-1 //

		S42:
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
		end


		S43:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S44:
		begin

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S45:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

		end

	
		S46:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
		end

		
		//---------------------/
		
		// Last Repeat to change mux on last cycle
		S47:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b001;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;	
		end

		S48:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		S49:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end

		
		S50:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;
	
		end	

		S51:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			sel_wghts2 <= 3'b100;
		end
		
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		//REPEAT 8X //

		S52:
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b101;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac = 1'b0;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end		
	

		S53:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

		S54:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end

			
		S55:
		begin		
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

		end
	
		S56:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
		end

		//------///

		///////////////// START  CALCULATE LAYER 1 DELTA /////////////////////////
		//////////////// 1 ST CELL //////////////////////////////////////////////
		S57:
		begin
			rst <= 0;
			rst_acc <= 1;
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
		end 


		S58:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 2
		S59:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 3
		S60:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		// CLOCK 4
		S61:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// CLOCK 5
		S62:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end
		

		// CLOCK 6
		S63:
		begin
			rst <= 0;
			rst_acc <= 0;
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

		end

		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
		S64:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		
		S65:
		begin
		// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
		end
				// $display("dat <= %h \n", o_dgate);

		// CLOCK 9
		S66:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end

		// $display("dit <= %h \n", o_dgate);


		// CLOCK 10
		S67:
		begin
			rst <= 0;
			rst_acc <= 0;
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
		end


		S68:
		begin
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;
		end
		
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL //////////////////////

		// -----REPEAT 53-1------//


		S69:
		begin

			rst <= 0;
			rst_acc <= 0;
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
			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b0;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b0;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;
			acc_mac <= 1'b0;
		end


		S70:
		begin
		// CLOCK 1
			rst <= 0;
			rst_acc <= 0;
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
		end

		S71:
		begin
			// CLOCK 2
			rst <= 0;
			rst_acc <= 0;
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
			end

			S72:
			begin
			// CLOCK 3
			rst <= 0;
			rst_acc <= 0;
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

			end
			S73:
			begin
			// CLOCK 4
			rst <= 0;
			rst_acc <= 0;
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
			end
			S74:
			begin
			// CLOCK 5
			rst <= 0;
			rst_acc <= 0;
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
			end
			S75:
			begin
			// CLOCK 6
			rst <= 0;
			rst_acc <= 0;
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

			end
			// $display("dot <= %h \n", o_dgate);
			S76:
			begin
			// CLOCK 7
			rst <= 0;
			rst_acc <= 0;
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
			end
			S77:
			begin
			// CLOCK 8
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dat <= %h \n", o_dgate);
			S78:
			begin
			// CLOCK 9
			rst <= 0;
			rst_acc <= 0;
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
			end
			// $display("dit <= %h \n", o_dgate);

			S79:
			begin
			// CLOCK 10
			rst <= 0;
			rst_acc <= 0;
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
			end

		S80:
		begin
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

		end
		//-----------------------//
		////////////////// END LAYER 1 DELTA ///////////////////////////

		///////////////// START  CALCULATE dOut2 /////////////////////////

		//---- repeat 53x----//

		S81:
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
		end

		S82:
		begin
			sel_dgate <= 2'b10;
			sel_wghts1 <= 2'b10;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end


		S83:
		begin	
			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end

		
		S84:
		begin
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;
		end

		
		S85:
		begin
			rst_mac = 1'b1;
			wr_dout1 <= 1'b0;	
		end


		 ///---------------/////////
		//// CONDITIONING FOR NEXT TIME STEP

		S86:
		begin
			rst <= 1;
			rst_acc <= 1;
		end
                   
		default:
		begin
			rst <= 1;
			rst_2 <=1;
			rst_acc <=1;
			rst_mac <=1;
		end

    endcase
end

always @(posedge clk or posedge rst_fsm)

begin
      if (rst_fsm)
           state <= S0;
      else
      begin
           case (state)
                S0:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S1:
                begin
                    count <= 5'd0;
                    state <= S2;
                end
               	S2:
                begin
                    count <= 5'd0;
                    state <= S3;
                end
                S3:
                begin
                    count <= 5'd0;
                    state <= S4;
                end

                S4:
                begin
                   if (count <= 5'd52)
                   begin
                		count <= count+1; 
                    	state <= S4;
                   end
                   else 
                   begin
                    	count <= 5'd0;
                    	state <= S5;
                   end
                end

                S5:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S6:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S7:
                begin
                	if (count <= 5'd52)
                	begin
                		count <= count+1; 
                    	state <= S4;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S8;
                    end
                end

                S8:
                begin
                   if (count <= 5'd7)
                   begin
                		count <= count+1; 
                    	state <= S8;
                   end
                   else begin
                    	count <= 5'd0;
                    	state <= S9;
                   end
                end
                S9:
                begin
                   if (count <= 5'd44)
                   begin
                		count <= count+1; 
                    	state <= S10;
                    end
                   else begin
                    	count <= 5'd0;
                    	state <= S9;
                   end
                end
                S10:
                begin
                    count <= 5'd0;
                    state <= S11;
                end
                S11:
                begin
                	count <= 5'd0;
                    state <= S12;
                end
                S12:
                begin
                	if (count <= 5'd7)
                	begin
                		count <= count+1; 
                    	state <= S8;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S13;
                    end
                end

                S13:
                begin
                   if (count <= 5'd52)
                   begin
                		count <= count+1; 
                    	state <= S4;
                   end
                   else begin
                    	count <= 5'd0;
                    	state <= S5;
                   end
                end
                S14:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S15:
                begin
                    count <= 5'd0;
                    state <= S1;
                end
                S16:
                begin
                	if (count <= 5'd44)
                	begin
                		count <= count+1; 
                    	state <= S13;
                    end
                    else begin
                    	count <= 5'd0;
                    	state <= S17;
                    end
                end

                S17:
                begin
                    count <= 5'd0;
                    state <= S18;
                end

				S18:
                begin
                    count <= 5'd0;
                    state <= S19;
                end

                S19:
                begin
                    count <= 5'd0;
                    state <= S20;
                end

                S20:
                begin
                    count <= 5'd0;
                    state <= S21;
                end
                S21:
                begin
                    count <= 5'd0;
                    state <= S22;
                end
                S22:
                begin
                    count <= 5'd0;
                    state <= S23;
                end
                S23:
                begin
                    count <= 5'd0;
                    state <= S24;
                end
                S24:
                begin
                    count <= 5'd0;
                    state <= S25;
                end
                S25:
                begin
                    count <= 5'd0;
                    state <= S26;
                end
                S26:
                begin
                    count <= 5'd0;
                    state <= S27;
                end
                S27:
                begin
                    count <= 5'd0;
                    state <= S28;
                end
                S28:
                begin
                    count <= 5'd0;
                    state <= S29;
                end
                S29:
                begin
                    count <= 5'd0;
                    state <= S30;
                end
                S30:
                begin
                	state <= S31;
                end
                S31:
                begin
                	count<=5'd0;
                	state <= S32;
                end
                S32:
                begin
                	count<=5'd0;
                	state <= S33;
                end
                S33:
                begin
                	count<=5'd0;
                	state <= S34;
                end
                S34:
                begin
                	count<=5'd0;
                	state <= S35;
                end
                S35:
                begin
                	count<=5'd0;
                	state <= S36;
                end
                S36:
                begin
                	count<=5'd0;
                	state <= S37;
                end
                S37:
                begin
                	count<=5'd0;
                	state <= S38;
                end
                S38:
                begin
                	count<=5'd0;
                	state <= S39;
                end
                S39:
                begin
                	count<=5'd0;
                	state <= S40;
                end
                S40:
                begin
                	count<=5'd0;
                	state <= S41;
                end
                S41:
                begin
                	count<=5'd0;
                	state <= S42;
                end
                //-----------REPEAT 53-1--------///
                S42:
                begin
                	count<=5'd0;
                	state <= S43;
                end
                S43:
                begin
                	count<=5'd0;
                	state <= S44;
                end
                S44:
                begin
                	count<=5'd0;
                	state <= S45;
                end
                S45:
                begin
                	count<=5'd0;
                	state <= S46;
                end
                S46:
                begin
                	if (count<= 5'd51 )
                	begin
                		count <= count+1;
                		state <= S42;
                	end
                	else begin
                		count <= 5'd0;
                		state <= S47;
                	end
                end
                S47:
                begin
                	count<=5'd0;
                	state <= S48;
                end
                S48:
                begin
                	count<=5'd0;
                	state <= S49;
                end
                S49:
                begin
                	count<=5'd0;
                	state <= S50;
                end
                S50:
                begin
                	count<=5'd0;
                	state <= S51;
                end
                S51:
                begin
                	state <= S52;

                end
                S52:
                begin
                	state <= S53;

                end
                S53:
                begin
                	state <= S54;

                end
                S54:
                begin
                	state <= S55;

                end
                S55:
                begin
                	state <= S56;

                end
                S56:
                begin
                	if (count <=5'd7)
                	begin
                		count <= count+1;
                		state <= 52;
                	end
                	else begin
                		state <= 57;
                	end

                end
                S57:
                begin
                	state <= S58;

                end
                S58:
                begin
                	state <= S59;

                end
                S59:
                begin
                	state <= S60;

                end
                S60:
                begin
                	state <= S61;
         		end

                S61:
                begin
                	state <= S62;

                end
                S62:
                begin
                	state <= S63;

                end
                S63:
                begin
                	state <= S64;

                end
                S64:
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
				    	state <= S75;

				    end
				S75:
				    begin
				    	state <= S76;

				    end
				S76:
				    begin
				    	state <= S77;

				    end
				S77:
				    begin
				    	state <= S78;

				    end
				S78:
				    begin
				    	state <= S79;

				    end
				S79:
				    begin
				    	state <= S80;

				    end
				S80:
				    begin
				    	if (count<=5'd51)
				    	begin
				    		count <= count+1;
				    		state <= S69;
				    	end
				    	else begin
				    		state <= S81;
				    	end
				    end
			
				S81:
				    begin
				    	state <= S82;

				    end
				S82:
				    begin
				    	state <= S83;

				    end
				S83:
				    begin
				    	state <= S84;

				    end
				S84:
				    begin
				    	state <= S85;

				    end
				S85:
				    begin
				    	state <= S86;
				    end
				S86:
				    begin
				    	if (count <= 5'd6)
				    	begin
				    		count <= count+1;
				    		state <= S18;
				    	end
				    	else 
				    	begin
				    		state <=S86;
				    	end
				    end
    		endcase
    	end
end

endmodule



				//
//
				// S20:
				// begin
				// 	rst_2 <=0;
				// 	rst <=0;
				// 	rst_2 <=0;
				// 	rst <=1;
				// 	wr_h2 <=0;
				// 	lstm_2 <=0;
				// end
				// S21:
				// begin
				// 	rst_2 <=1;
				// 	rst <= 0;
				// end


>>>>>>> parent of 7294d3f... change fsm
