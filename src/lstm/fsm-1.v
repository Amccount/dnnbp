
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
module fsm (clk, en, rst, rst_2, acc_x_1, acc_x_2, acc_h_1, acc_h_2, wr_h1, wr_h2,  wr_c1, wr_c2, wr_act_1, wr_act_2,
sel_in1, sel_in2, sel_in3, sel_in4, sel_in5, sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp,
acc_da, acc_di, acc_df, acc_do, acc_mac, sel_dgate, sel_wght, sel_wghts1, sel_wghts2);

//common ports
input clk, en, rst, rst_2;

//output ports
output reg acc_x_1, acc_h_1, acc_x_2, acc_h_2;
output reg wr_h1;
output reg wr_c1;
output reg wr_act_1;
output reg wr_act_2;
output reg wr_h2;
output reg wr_c2;

reg [1:0] state;
reg [2:0] count;


parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8;

reg [1:0] state;
reg [2:0] count;


always @(posedge clk or posedge rst or posedge rst_2) 
begin
	 case (state)
               //INITIAL START //
				S0:
				begin
				  	clk = 1;
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
				end
				S1:
				begin
					rst <=0;
					rst_2 <=0;
				end
				S2:
				begin
					acc_x_2 <=0;
					acc_h_2 <=0;
					rst_2 <=1;
					rst <= 0;
				end
				S3:
				begin
					en <=1; 
				end
				// start computing for first layer -- repeat 53x -------------//
				S4:
				begin
					acc_x_1 <=1;
					acc_h_1 <=1;
					rst <=0;
				end
				S5:
				begin
					acc_x_1 <= 0;
					acc_x_1 <= 0;
				end
				S6 :
				begin
					//enable write h
					wr_h1 <=1;
					//enable write state and activation
					wr_c1 <= 1; 
					wr_act_1 <=1;
				S7 :
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
					acc_h_2<=0
					acc_x_1 <=1;;
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
					sel_x2_2 <= 2'h0;
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

				S3O:
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

					rd_layr2_t <= rd_layr2_t + 6'd1;
					rd_layr2_h <= rd_layr2_h + 6'd1;
					rd_layr2_a <= rd_layr2_a + 6'd1;
					rd_layr2_i <= rd_layr2_i + 6'd1;
					rd_layr2_o <= rd_layr2_o + 6'd1;

					rd_layr2_f <= rd_layr2_f + 6'd9;
					rd_layr2_state <= rd_layr2_state + 6'd9;
		
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
			sel_x2_2 <= 2'h0;
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

			rd_layr2_f <= rd_layr2_f - 6'd8;
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
			
			rd_layr2_state <= rd_layr2_state - 6'd8;
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

			rd_layr2_t <= rd_layr2_t + 6'd1;
			rd_layr2_h <= rd_layr2_h + 6'd1;
			rd_layr2_a <= rd_layr2_a + 6'd1;
			rd_layr2_i <= rd_layr2_i + 6'd1;
			rd_layr2_o <= rd_layr2_o + 6'd1;

			rd_layr2_f <= rd_layr2_f + 6'd9;
			rd_layr2_state <= rd_layr2_state + 6'd9;
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


			
			#100;
		S43:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end
			#100;

		S44:
		begin

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end
			#100;
		
		S45:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

		end

			#100;	
		S46:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
		end
			#100;
		
		//---------------------/
		////
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
		#100;

		S48:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end
		#100;

		S49:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
		end
		#100;
		
		S50:
		begin
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;
	
		end
		#100;	

		S51:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
			sel_wghts2 <= 3'b100;
		end
		#100;
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		repeat(8)
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
			#100;

		S53:
		begin
			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end
			#100;

		S54:
		begin
			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
		end
			#100;
			
		S55:
		begin		
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

		end
			#100;	
		S56:
		begin
			rst_mac = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
			wr_addr_dout2 <= wr_addr_dout2 + 4'd1;
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
		#100;

		S58:
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
		#100;

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
		#100;

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

			rd_layr1_f <= rd_layr1_f - 9'd53;
		end
		#100;

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

			rd_layr1_state <= rd_layr1_state - 9'd53;
		end
		#100;
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
		#100;
		
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
		#100;
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
		#100;

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
			rd_addr_dx2 <= rd_addr_dx2 + 9'd1;

			rd_layr1_a <= rd_layr1_a + 9'd1;
			rd_layr1_i <= rd_layr1_i + 9'd1;
			rd_layr1_o <= rd_layr1_o + 9'd1;
			
			rd_layr1_f <= rd_layr1_f + 9'd54;
			rd_layr1_state <= rd_layr1_state + 9'd54;
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

			rd_layr1_f <= rd_layr1_f - 9'd53;
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

			rd_layr1_state <= rd_layr1_state - 9'd53;
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
			rd_addr_dx2 <= rd_addr_dx2 + 9'd1;

			rd_layr1_a <= rd_layr1_a + 9'd1;
			rd_layr1_i <= rd_layr1_i + 9'd1;
			rd_layr1_o <= rd_layr1_o + 9'd1;
			
			rd_layr1_f <= rd_layr1_f + 9'd54;
			rd_layr1_state <= rd_layr1_state + 9'd54;
			end
			#100;

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
			#100;

		S83:
		begin	
			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
		end
			#100;
		
		S84:
		begin
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;
		end
			#100;	
		
		S85:
		begin
			rst_mac = 1'b1;
			wr_dout1 <= 1'b0;	
			wr_addr_dout1 <= wr_addr_dout1 + 4'd1;
		end
			#100;

		 ///---------------/////////
		//// CONDITIONING FOR NEXT TIME STEP

		S86:
		begin
		rst <= 1;
		rst_acc <= 1;
		end






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

               end
                   
               default:
               begin
                  trigger <= 1'b0;
                  sel_gen <= 1'b0;
                  we <=1'b0;
                end
    endcase
end

