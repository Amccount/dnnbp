
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Finite State Machine
// File Name        : fsm.v
// Version          : 2.0
// Description      : State machine to generate control signal Datapath
//            
///////////////////////////////////////////////////////////////////////////////
module fsm (
clk, rst, en_1, en_2,
update, 
acc_x1, acc_x2, acc_h1, acc_h2, 
wr_h1, wr_h2, wr_c1, wr_c2, wr_act_1, wr_act_2,

en_delta_2, en_delta_1, en_dx2, en_dout2, en_dout1,
en_rw_dout2, en_rw_dout1, en_rw_dx2,
update, bp, rd_dgate,

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
parameter LAYR2_T = "layer2_t_bp.list";


//common ports
input clk, rst;


/////////////////////////////////////////////
//      Output Port & Reg Declaration      //
/////////////////////////////////////////////

// Forward Section
output reg acc_x1, acc_h1, acc_x2, acc_h2;
output reg wr_h1;
output reg wr_c1;
output reg wr_act_1;
output reg wr_act_2;
output reg wr_h2;
output reg wr_c2;
output reg en_1, en_2, rst, rst_2;
output reg update;
////
// Backpropagation Section
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
////
// update weight
output reg wr_w1;
output reg wr_u1;
output reg wr_b1;
output reg wr_w2;
output reg wr_u2;
output reg wr_b2;
output reg en_x1;
output reg en_x2;
output reg en_h1;
output reg en_h2;
output reg en_w1;
output reg en_w2;
output reg en_u1;
output reg en_u2;
output reg en_b1;
output reg en_b2;
output reg acc_x1;
output reg acc_h1;
output reg acc_dgate1;
output reg acc_x2;
output reg acc_h2;
output reg acc_dgate2;
output reg rst_mac_1;
output reg rst_mac_2;
output reg rst_acc_1;
output reg rst_acc_2;

/////////////////////////////////////////////
//          Register Declaration           //
/////////////////////////////////////////////
reg flag;
reg [7:0] state;

// Counter for Forward Section
// reg [7:0] count, counter_cell, counter_layer, counter_timestep;
reg [7:0] counter_cell, counter_layer, counter_timestep;

// Counter for Backpropagation Section
reg [7:0] count1, count2;

// Counter for Update Weight Section
reg [11:0] count, count3, count4, count5;

// STATES
// State for Forward Propagation
parameter 	S0=0, 		S1=1, 		S2=2, 		S3=3, 		S4=4,
			S5=5, 		S6=6, 		S7=7, 		S8=8, 		S9=9,  
		 	S10=10, 	S11=11, 	S12=12, 	S13=13, 	S14=14;
// State for Backward Propagation
parameter 	BP0=15, 	BP1=16, 	BP2=17, 	BP3=18, 	BP4=19,
			BP5=20, 	BP6=21, 	BP7=22, 	BP8=23, 	BP9=24,
			BP10=25,	BP11=26,	BP12=27,	BP13=28,	BP14=29,
			BP15=30,	BP16=31,	BP17=32,	BP18=33,	BP19=34,
			BP20=35,	BP21=36,	BP22=37,	BP23=38,	BP24=39,
			BP25=40, 	BP26=41, 	BP27=42, 	BP28=43, 	BP29=44, 
			BP30=45,	BP31=46, 	BP32=47, 	BP33=48, 	BP34=49,
			BP35=50, 	BP36=51, 	BP37=52, 	BP38=53, 	BP39=54,
			BP40=55,	BP41=56, 	BP42=57, 	BP43=58,	BP44=59,
			BP45=60,	BP46=61,	BP47=62, 	BP48=63,	BP49=64,
			BP50=65,	BP51=66, 	BP52=67,	BP53=68,	BP54=69,
			BP55=70,	BP56=71,	BP57=72,	BP58=73,	BP59=74,
			BP60=75, 	BP61=76, 	BP62=77;
// State for Update Weight
parameter 	UPD0 = 78,  UPD1 = 79,  UPD2 = 80,  UPD3 = 81,  UPD4 = 82;
			UPD5 = 83,  UPD6 = 84,  UPD7 = 85,  UPD8 = 86,  UPD9 = 87;
			UPD10 = 88, UPD11 = 89, UPD12 = 90, UPD13 = 91, UPD14 = 92;
			UPD1B = 93, UPD5B = 94, UPD9B = 95;
			UPD1C = 96, UPD5C = 97, UPD9C = 98;


/////////////////////////////////////////////
//            FSM State Handler            //
/////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin  
	if (rst)
	begin
	   state <= S0;
	   flag <=1'd0;
	end
	else
	begin
	 	case (state)
			//INITIAL START //
		 	S0:
	        begin
	            counter_cell <= 8'd0;
	          	counter_layer <= 8'd0;
	            counter_timestep <= 8'd0;
	            state <= S1;
	        end
	       	S1:
	        begin
	            counter_layer <= 8'd0;
	            counter_timestep <= 8'd0;
	            state <= S2;
	        end
	        S2:
	        begin
	           if (counter_cell != 8'd52)
	           begin
	                state <= S2;
	        		counter_cell <= counter_cell+1; 
	           end
	           else 
	           begin
	            	counter_cell <= 8'd0;
	            	state <= S3;
	           end
	        end
	        S3:
	        begin
	            counter_cell <= 8'd0;
	            state <= S4;
	        end
	        S4:
	        begin
	            counter_cell <= 8'd0;
	            state <= S5;
	        end 
	        S5:
	        begin
	        	if (counter_layer!=8'd52)
	        	begin
	            	counter_cell <=8'd0;
	            	state <= S6;
	            end
	            else 
	            begin
	            	counter_cell <=8'd0;
	            	state <=S7;
	            end
	        end
	        S6:
	        begin
	        	if (flag==1'd0)
	        	begin
	            	if (counter_layer != 8'd52)
	            	begin
	            		counter_layer <= counter_layer +1; 
	                	state <= S2;
	                end
	                else if(counter_layer== 8'd52)
	                begin
	                	flag <= 1'd1;
	                	counter_layer <= 8'd0;
	                	counter_cell <= 8'd0;
	                	state <= S7;
	                end
	            end
	            else  // flag 1
	            begin
	            	if (counter_layer != 8'd44)
	            	begin
	            		counter_layer <= counter_layer +1; 
	                	state <= S2;
	                end
	                else if (counter_layer ==8'd44)
	                begin
	                	counter_layer <= 8'd0;
	                	counter_cell <= 8'd0;
	                	state <= S2;
	                end
	            end
	        end
	        S7:
	        begin
	        	counter_cell <= 8'd0;
	        	state <=S8;
	        	counter_layer <= 8'd0;
	        end
	        // forward second and first cell
	        S8:
	        begin
	           if (counter_cell != 8'd7)
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
	           if (counter_cell != 8'd44)
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
	        	if (counter_layer!=8'd7)
	        	begin
	            	counter_cell <=8'd0;
	            	state <= S13;
	            end
	            else 
	            begin
	            	counter_cell <=8'd0;
	            	state <=S14;
	            end
	        end
	        S13:
	        begin
	        	if (counter_layer != 8'd7)
	        	begin
	            	state <= S8;
	            	counter_layer <= counter_layer+1;
	            end
	            else begin
	            	counter_layer <= 8'd0;
	            	state <= S14;
	            end
	        end
	        S14:
	        begin
	        	counter_cell <=0;
	        	counter_layer <=0;
	        	if (counter_timestep!=6)
	        	begin
					state <= S2;
					counter_timestep <= counter_timestep + 1;
				end
				else
	        	begin
	        		state <= S15;
	        	end
	        end
			S15:
			begin
				state <= BP0;
			end

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
				state <= BP62;
			end
			BP62:
			begin
				if (count6 < TIMESTEP-1)
				begin
					count6 <= count6 + 1;
					state <= BP22;
				end
				else
				begin
					count6 <= 8'd0;
					state <= UPD0;
				end
			end
			UPD0: begin
					state <= UPD1;
			UPD1: begin
					if (count != TIMESTEP-2)
					begin
						count <= count + 1;
					end
					else
					begin
						count <= 0;
						if (count3 == 53)
						begin
							count3 <= 0;
							state <= UPD1B;
						end
						else
						begin
							count3 <= count3 + 1;
							state <= UPD1C;
						end
					end
				end
			UPD1B: begin
					state <= UPD2;
				end
			UPD1C:begin
					state <= UPD2;
				end
			UPD2: begin
					count5 <= count5 + 1;
					state <= UPD3;
				end
			UPD3: begin
					state <= UPD4;
				end
			UPD4:	begin
					if (count5 == 8)
					begin
						count5 <= 0;
						state <= UPD5;
					end
					else
					begin
						state <= UPD1;
					end
				end
			UPD5: begin
					if(count != TIMESTEP-2)
					begin
						count <= count + 1;
					end
					else
					begin
						count <= 0;
						if (count3 == 53)
						begin
							count3 <= 0;
							state <= UPD5B;
						end
						else
						begin
							count3 <= count3 + 1;
							state <= UPD5C;
						end
					end
				end
			UPD5B:begin
					state <= UPD6;
				end
			UPD5C:begin
					state <= UPD6;
				end
			UPD6: begin
					count5 <= count5 + 1;
					state <= UPD7;
				end
			UPD7: begin
					state <= UPD8;
				end
			UPD8:	begin
					if (count5 == 45)
					begin
						count5 <= 0;
						if (count4 == 8)
						begin
							count4 <= 0;
							state  <= S9;
						end
						else begin
							count4 <= count4 +1 ;
							state <= UPD1;
						end
					end
					else
					begin
						state <= UPD5;
					end
				end
			UPD9: begin
					if(count != TIMESTEP-2)
					begin
						count <= count + 1;
					end
					else
					begin
						count <= 0;
						if (count3 == 53)
						begin
							count3 <= 0;
							state <= UPD9B;
						end
						else
						begin
							count3 <= count3 + 1;
							state <= UPD9C;
						end
					end
				end
			UPD9B:begin
					state <= UPD10;
				end
			UPD9C:begin
					state <= UPD10;
				end
			UPD10:begin
					count5 <= count5 + 1;
					state <= UPD11;
				end
			UPD11:begin
					state <= UPD12;
				end
			UPD12:begin
					if(count5 == 53*45+10)
					begin
						state <= UPD13;
					end
					else
					begin
						state <= UPD9;
					end
				end

			UPD13:begin
				end
			default:
			begin
				rst_mac_1 <= 1;
				rst_mac_2 <=1;
			end
    	endcase
    end
end

/////////////////////////////////////////////
// Control Signal Generator Based on State //
/////////////////////////////////////////////

always @(state) 
begin
 	case (state)
 		// Start of FSM
 		// Forward Propagation Section
	    S0:
		begin
			rst_mac_1 <= 1;
			rst_mac_2 <= 1;
			acc_x1 <=0;
			acc_h1 <=0;
			acc_x2 <=0;
			acc_h2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			update <=0;
			en_1 <=0;
		end
		S1:
		begin
			rst_mac_1 <=0;
			rst_mac_2 <=1;
			acc_x1 <=0;
			acc_h1 <=0;
			acc_x2 <=0;
			acc_h2 <=0;
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
			en_1<=1; 
		end
		// start computing for fir_macst layer -- repeat 53x -------------//
		S2:
		begin
			rst_mac_1 <=0;
			rst_mac_2 <=1;
			en_1<=1;
			update <=0;
			acc_x1 <=1;
			acc_h1 <=1;			
			wr_h1 <=0;
			wr_h2 <=0;
			wr_c1 <=0;
			wr_c2 <=0;
		end
		S3:
		begin
			en_1 <=1;
			acc_x1 <= 0;
			acc_h1 <= 0;		
		end
		S4:
		begin
			//enable write h
			en_1 <=1;
			en_2 <=0;
			wr_h1 <=1;
			//enable write state and activation
			wr_c1 <= 1; 
			wr_act_1 <=1;
			rst_mac_1<=0;
		end
		S5:
		begin
			en_1 <=1;
			en_2 <=0;
			wr_h1 <=0;
			wr_c1 <=0;
			wr_act_1 <=0;
			rst_mac_1 <=1;
			rst_mac_2<=1;
		end
		S6:
		begin
			rst_mac_1 <= 0;
			rst_mac_2 <=1;
			en_1 <=1;
			en_2 <=0;
		end
		// ----------------------------------------------------------//
		S7:
		begin
			rst_mac_1 <= 0;
			rst_mac_2 <=0;
			en_2 <=1;	
		end
		// start computing for the 2nd and 1st layer - repeat 8x ----//
		S8: // repeat 8x
		begin
			en_2 <= 1;
			acc_x2 <=1;
			acc_h2 <=1;
			acc_x1 <=1;
       		acc_h1 <=1;
       		rst_mac_2 <= 0;
       		rst_mac_1 <=0;
		end
		S9: //repeat 45x
		begin
			en_2 <= 1;
			acc_x2 <=1;
			acc_h2 <=0;
			acc_x1 <=1;
			acc_h1 <=1;
		end
		S10: 
		begin
			en_2 <= 1;
			acc_x2 <=0;
			acc_h2 <=0;
			acc_x1 <=0;
			acc_h1 <=0;
		end
		S11:
		begin
			en_2 <= 1;
			wr_h2 <=1;
			wr_c2 <=1;
			//enable write state and activation
			wr_c1 <=1; 
			wr_h1 <=1;
			wr_act_2 <=1;
			wr_act_1 <=1;
		end
		S12:
		begin
			en_2 <= 1;
			en_1 <=1;
			wr_h1 <=0;
			wr_c1 <=0;
			wr_act_2 <=0;
			wr_act_1 <=0;
			rst_mac_1 <=1;
			rst_mac_2<=1;
			wr_h2 <=0;
			wr_c2 <=0;
			//enable write state and activation
			wr_c1 <=0; 
			wr_h1 <=0;
		end
		S13:
		begin
			en_2 <= 1;
			en_1 <=1;
			wr_h2 <=0;
			wr_c2 <=0;
			wr_c1 <= 0; 
			wr_act_2 <=0;
			wr_act_2 <=0;
			wr_act_1 <=0;
			rst_mac_1 <=0;
			rst_mac_2 <=0;
		end
		// ---------------------TRANSITION STATE------------------------//
		S14:
		begin
			acc_h1 <=0;
			acc_h2 <=0;
			acc_x1 <=0;
			acc_x2 <=0;
			en_2 <=0;
			en_1 <=1;
			wr_h2 <=0;
			wr_c2 <=0;
			wr_c1 <= 0; 
			wr_act_2 <=0;
			wr_act_2 <=0;
			wr_act_1 <=0;
			rst_mac_1 <=0;
			rst_mac_2 <=1;
		end

		// Backpropagation Section
		BP0:
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
		// BP1 - BP12 repeaeted 8 times, and calculating only for delta 2
		BP1:
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
		BP2:
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
		BP3:
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
		BP4:
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
		BP5:
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
		BP6:
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
		BP7:
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
		BP8:
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
		BP9:
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
		BP10:
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
		BP11:
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
		BP12:
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
		
		// BPtart Calculating for dX2 and dOut2 ///////
		// pre calc
		BP13:
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
			en_rw_dx2 <= 1'b0;
			// en_rw_dout1 <= 1'b0;
		end 
		BP14: // Loop dout2 & dx2
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
		BP15: // not acc & write
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b1;
			wr_dout_2 <= 1'b1;
			// wr_dout_1 <= 1'b0;
			en_dout2 <= 1'b1;
		end
		BP16: // reset
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
		BP17:
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
		BP18: // Loop dout2 & dx2
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
		BP19: // not acc & write
		begin
			acc_x2 <= 1'b0;
			acc_h2 <= 1'b0;
			// acc_h1 <= 1'b1;

			wr_dx2 <= 1'b1;
			wr_dout_2 <= 1'b0;
			// wr_dout_1 <= 1'b0;
			en_dout2 <= 1'b0;
		end
		BP20: // reset
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

		// Update Weight Section
		UPD0:
		begin
			rst    	  <= 1;
			rst_mac_1 <= 1;			rst_mac_2 <= 1;
			en_x1     <= 0; 		en_x2     <= 0;
			en_h1     <= 0;			en_h2     <= 0;
			en_w1     <= 0;			en_w2     <= 0;
			en_u1     <= 0;			en_u2     <= 0;
			en_b1     <= 0;			en_b2     <= 0;
			bp	      <= 0;			update    <= 1;
			wr_w1     <= 0;			wr_w2     <= 0;
			wr_u1     <= 0;			wr_u2     <= 0;
			wr_b1     <= 0;			wr_b2     <= 0;
			acc_x1    <= 0;			acc_x2    <= 0;
			acc_h1    <= 0;			acc_h2    <= 0;
			acc_dgate1<= 0;			acc_dgate2<= 0;
			rst_acc_1 <= 1;			rst_acc_2 <= 1;
		end
		UPD1: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD1B: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 1;		acc_dgate2<= 1;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD1C:
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Write mac result
		UPD2: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 1;		wr_w2     <= 1;
				wr_u1     <= 1;		wr_u2     <= 1;
				wr_b1     <= 1;		wr_b2     <= 1;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Turn WR off, transition state
		UPD3: 
		begin
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Reset MAC result
		UPD4: 
		begin
				rst       <= 0;
				rst_mac_1 <= 1;		rst_mac_2 <= 1;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 1;		rst_acc_2 <= 1;
		end
		UPD5: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD5B: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 1;		acc_dgate2<= 1;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD5C:
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Write mac result
		UPD6: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 1;		wr_w2     <= 1;
				wr_u1     <= 1;		wr_u2     <= 0;
				wr_b1     <= 1;		wr_b2     <= 1;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Turn WR off, transition state
		UPD7: 
		begin
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Reset MAC result
		UPD8: 
		begin
				rst       <= 0;
				rst_mac_1 <= 1;		rst_mac_2 <= 1;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 0;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 1;		rst_acc_2 <= 1;
		end
		UPD9: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD9B:
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 1;		acc_dgate2<= 1;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		UPD9C:
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 1;		acc_x2    <= 1;
				acc_h1    <= 1;		acc_h2    <= 1;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Write mac result
		UPD10: 
		begin 
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 1;		wr_w2     <= 0;
				wr_u1     <= 1;		wr_u2     <= 0;
				wr_b1     <= 1;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Turn WR off, transition state
		UPD11: 
		begin
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
		// Reset MAC result
		UPD12: 
		begin
				rst       <= 0;
				rst_mac_1 <= 1;		rst_mac_2 <= 1;
				en_x1     <= 1;		en_x2     <= 1;
				en_h1     <= 1;		en_h2     <= 1;
				en_w1     <= 1;		en_w2     <= 1;
				en_u1     <= 1;		en_u2     <= 1;
				en_b1     <= 1;		en_b2     <= 1;
				bp	      <= 0;		update    <= 1;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 1;		rst_acc_2 <= 1;
		end
		UPD13: 
		begin
				rst       <= 0;
				rst_mac_1 <= 0;		rst_mac_2 <= 0;
				en_x1     <= 0;		en_x2     <= 0;
				en_h1     <= 0;		en_h2     <= 0;
				en_w1     <= 0;		en_w2     <= 0;
				en_u1     <= 0;		en_u2     <= 0;
				en_b1     <= 0;		en_b2     <= 0;
				bp	      <= 0;		update    <= 0;
				wr_w1     <= 0;		wr_w2     <= 0;
				wr_u1     <= 0;		wr_u2     <= 0;
				wr_b1     <= 0;		wr_b2     <= 0;
				acc_x1    <= 0;		acc_x2    <= 0;
				acc_h1    <= 0;		acc_h2    <= 0;
				acc_dgate1<= 0;		acc_dgate2<= 0;
				rst_acc_1 <= 0;		rst_acc_2 <= 0;
		end
	endcase
end

endmodule