module new_datapath_tb();

// parameters
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

// common ports
reg clk, rst, rst_2, acc_x_1, acc_h_1, acc_x_2, acc_h_2;

// control ports
reg [11:0] addr_x1;
reg [11:0] rd_addr_x1, wr_addr_x1;

reg wr_h1;
reg [11:0] rd_addr_h1;
reg [11:0] wr_addr_h1;
reg wr_c1;
reg [11:0] rd_addr_c1;
reg [11:0] wr_addr_c1;
reg wr_x2;
reg [11:0] wr_addr_x2;
reg [11:0] rd_addr_x2;

reg wr_act_1;
reg [11:0] wr_addr_act_1;

reg wr_act_2;
reg [11:0] wr_addr_act_2;

reg wr_w_1;
reg [11:0] rd_addr_w_1;
reg wr_b_1;
reg [11:0] rd_addr_b_1;
reg wr_u_1;
reg [11:0] rd_addr_u_1;

reg wr_w_2;
reg [11:0] rd_addr_w_2;
reg wr_b_2;
reg [11:0] rd_addr_b_2;
reg wr_u_2;
reg [11:0] rd_addr_u_2;


reg wr_h2;
reg [11:0] rd_addr_h2;
reg [11:0] wr_addr_h2;
reg wr_c2;
reg [11:0] rd_addr_c2;
reg [11:0] wr_addr_c2;
reg wr_layr2;
reg [11:0] rd_addr_layr2;
reg [11:0] wr_addr_layr2;
reg [11:0] lstm, lstm_2;
reg [11:0] timestep;

/////////////////////
reg [2:0] tstep;
/////////////////////

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
			.rd_addr_x2      (rd_addr_x2),
			.wr_addr_x2      (wr_addr_x2),
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
			.rd_addr_da1     (rd_addr_da1),
			.rd_addr_di1     (rd_addr_di1),
			.rd_addr_df1     (rd_addr_df1),
			.rd_addr_do1     (rd_addr_do1),
			.rd_addr_da2     (rd_addr_da2),
			.rd_addr_di2     (rd_addr_di2),
			.rd_addr_df2     (rd_addr_df2),
			.rd_addr_do2     (rd_addr_do2),
			.wr_addr_da1     (wr_addr_da1),
			.wr_addr_di1     (wr_addr_di1),
			.wr_addr_df1     (wr_addr_df1),
			.wr_addr_do1     (wr_addr_do1),
			.wr_addr_da2     (wr_addr_da2),
			.wr_addr_di2     (wr_addr_di2),
			.wr_addr_df2     (wr_addr_df2),
			.wr_addr_do2     (wr_addr_do2),
			.wr_dx2          (wr_dx2),
			.rd_addr_dx2     (rd_addr_dx2),
			.wr_addr_dx2     (wr_addr_dx2),
			.wr_dout2        (wr_dout2),
			.rd_addr_dout2   (rd_addr_dout2),
			.wr_addr_dout2   (wr_addr_dout2),
			.wr_dout1        (wr_dout1),
			.rd_addr_dout1   (rd_addr_dout1),
			.wr_addr_dout1   (wr_addr_dout1),
			.wr_dstate2      (wr_dstate2),
			.rd_addr_dstate2 (rd_addr_dstate2),
			.wr_addr_dstate2 (wr_addr_dstate2),
			.wr_dstate1      (wr_dstate1),
			.rd_addr_dstate1 (rd_addr_dstate1),
			.wr_addr_dstate1 (wr_addr_dstate1),
			.rd_layr2_wa     (rd_layr2_wa),
			.rd_layr2_wi     (rd_layr2_wi),
			.rd_layr2_wf     (rd_layr2_wf),
			.rd_layr2_wo     (rd_layr2_wo),
			.rd_layr2_ua     (rd_layr2_ua),
			.rd_layr2_ui     (rd_layr2_ui),
			.rd_layr2_uf     (rd_layr2_uf),
			.rd_layr2_uo     (rd_layr2_uo),
			.rd_layr1_ua     (rd_layr1_ua),
			.rd_layr1_ui     (rd_layr1_ui),
			.rd_layr1_uf     (rd_layr1_uf),
			.rd_layr1_uo     (rd_layr1_uo),
			.rd_layr1_a      (rd_layr1_a),
			.rd_layr1_i      (rd_layr1_i),
			.rd_layr1_f      (rd_layr1_f),
			.rd_layr1_o      (rd_layr1_o),
			.rd_layr1_state  (rd_layr1_state),
			.rd_layr2_a      (rd_layr2_a),
			.rd_layr2_i      (rd_layr2_i),
			.rd_layr2_f      (rd_layr2_f),
			.rd_layr2_o      (rd_layr2_o),
			.rd_layr2_state  (rd_layr2_state),
			.rd_layr2_t      (rd_layr2_t),
			.rd_layr2_h      (rd_layr2_h)
		);

initial
begin
	
	// STATE 0
	clk = 1;
	rst <= 1;
	rst_2 <= 1;
	acc_x_1 <=0;
	acc_h_1 <=0;
	acc_x_2 <=0;
	acc_h_2 <=0;
	lstm <= 12'd0;
	lstm_2 <= 12'd0;
	timestep <=12'd0;
	addr_x1 <= 12'd0; 
	wr_addr_h1 <= 12'd0; 
	wr_addr_c1 <= 12'd0;
	rd_addr_w_1 <= 12'd0;
	rd_addr_b_1 <= 12'd0;
	rd_addr_u_1 <= 12'd0;
	wr_addr_h2 <= 12'd0; 
	wr_addr_c2 <= 12'd0;
	rd_addr_w_2 <= 12'd0;
	rd_addr_b_2 <= 12'd0;
	rd_addr_u_2 <= 12'd0;
	wr_c1 <=0;
	#100;

	// STATE 1
	rst <=0;
	rst_2 <=0;
	#100

	//repeat until 7 time step

	repeat (7)
	begin
		timestep <= timestep +1 ;
		rd_addr_w_1 <= 12'd0;
		rd_addr_b_1 <= 12'd0;
		rd_addr_u_1 <= 12'd0;
		//wr_addr_h1 <= (timestep-1)*53;
		addr_x1 <= (timestep)*53;
		//rd_addr_h1 <= 12'd0; 
		//wr_addr_h1 <= 12'd0; 
		lstm <= 12'd0;
		lstm_2 <= 12'd0;
		acc_x_2 <=0;
		acc_h_2 <=0;
		//rd_addr_h2 <= 12'd0; 
		//rd_addr_c2 <= 12'd0;
		//wr_addr_h2 <= 12'd0; 
		//wr_addr_c2 <= 12'd0;
		rd_addr_w_2 <= 12'd0;
		rd_addr_b_2 <= 12'd0;
		rd_addr_u_2 <= 12'd0;
		//STATE 2
		rst_2 <=0;
		rst <= 0;
		#200

		// calculating h and c on 1 time step on first layer
		repeat (53)
		begin
			lstm <= lstm +1;

			
			// obtaining h on each cell
			repeat (52)
			begin
				addr_x1 <= addr_x1+1;
				rd_addr_w_1 <= rd_addr_w_1+1;
				rd_addr_u_1 <= rd_addr_u_1+1;
				wr_addr_h1 <= wr_addr_h1+1;
				acc_x_1 <=1;
				acc_h_1 <=1;
				#100;
			end

			acc_x_1 <=1;
			acc_h_1 <=1;
			addr_x1 <=(timestep-1)*53;
			#100;

			acc_x_1<=0;
			acc_h_1<=0;

			#100

			//enable write h
			wr_h1 <=1;
			wr_addr_h1 <= (53*timestep) +lstm-1; //write 

			//enable write state
			wr_c1 <= 1; 
			wr_addr_c1 <= (53*timestep) + lstm-1;
			
			// wr_x2 <= 1;
			// rd_addr_x2 <= 9'd0; wr_addr_x2 <= 9'd0;
			// wr_h2 <= 1; 
			// rd_addr_h2 <= 9'd0; wr_addr_h2 <= 9'd8;
			// wr_c2 <= 1;
			// rd_addr_c2 <= 9'd0; wr_addr_c2 <= 9'd8;
			#100;
			wr_h1 <=0;
			wr_c1 <=0;
			rst <=1;
			wr_addr_h1 <= (timestep-1)*53;
			wr_addr_c1 <= (timestep-1)*53 + lstm;
			rd_addr_b_1 <= lstm;
			rd_addr_w_1 <= rd_addr_w_1 + 1;
			rd_addr_u_1 <= rd_addr_u_1 + 1;
			#100
			rst <=0;
                       // h(i) and state(i) are stored here
		end


		rst_2 <=0;
		rst <=1;
		wr_addr_h1 <= (53*timestep); 
		wr_h2 <=0;
		lstm_2 <=0;
	    #100

		// calculating h and c on 1 time step on second layer
		repeat (8)
		begin
			lstm_2 <= lstm_2 +1;
			// obtaining h on each cell
			repeat (7)
			begin
				wr_addr_h1 <= wr_addr_h1+1;
				rd_addr_w_2 <= rd_addr_w_2+1;
				rd_addr_u_2 <= rd_addr_u_2+1;
				wr_addr_h2 <= wr_addr_h2+1;
				acc_x_2 <=1;
				acc_h_2 <=1;
				#100;
			end

			acc_x_2<=1;
			wr_addr_h1 <= wr_addr_h1+1;
			rd_addr_w_2 <= rd_addr_w_2+1;
			acc_h_2<=1;
			#100

			repeat (44)
			begin
				wr_addr_h1 <= wr_addr_h1+1;
				rd_addr_w_2 <= rd_addr_w_2+1;
				acc_x_2 <=1;
				acc_h_2 <=0;
				#100;
			end

			acc_x_2 <=1;
			wr_addr_h1 <=timestep*53;
			#100;

			acc_x_2<=0;
			acc_h_2<=0;

			#100

			//enable write h
			wr_h2 <=1;
			wr_addr_h2 <= (53*timestep) +lstm_2-1; //write 

			//enable write state
			wr_c2 <= 1; 
			wr_addr_c2 <= (53*timestep) + lstm_2-1;
			
			// wr_x2 <= 1;
			// rd_addr_x2 <= 9'd0; wr_addr_x2 <= 9'd0;
			// wr_h2 <= 1; 
			// rd_addr_h2 <= 9'd0; wr_addr_h2 <= 9'd8;
			// wr_c2 <= 1;
			// rd_addr_c2 <= 9'd0; wr_addr_c2 <= 9'd8;
			
			#100;
			wr_h2 <=0;
			wr_c2 <=0;
			rst_2 <=1;
			wr_addr_h2 <= (timestep-1)*53;
			wr_addr_c2 <= (timestep-1)*53 + lstm_2;
			rd_addr_b_2 <= lstm_2;
			wr_addr_h1 <= timestep*53 ;
			rd_addr_w_2 <= rd_addr_w_2 + 1;
			rd_addr_u_2 <= rd_addr_u_2 + 1;
			#100;
			rst_2 <=0;
			#100;	
                       // h(i) and state(i) are stored here
		end


	end

	// repeat(52)
	// begin
	// 	wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 	wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 	wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 	rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
	// 	rd_addr_layr2 <= 9'd0;
	// 	#100;
	// end

	// addr_x1 <= 9'd53;	
	// rd_addr_h1 <= 9'd53;
	// rd_addr_c1 <= 9'd53;
	// rd_addr_x2 <= 9'd0;
	// rd_addr_h2 <= 9'd0;
	// rd_addr_c2 <= 9'd0;

	// wr_addr_h2 <= 9'd8;
	// wr_addr_c2 <= 9'd8;

	// wr_addr_x2 <= 9'd53;
	// wr_addr_h1 <= 9'd106;
	// wr_addr_c1 <= 9'd106;
	// rd_addr_layr1 <= 9'd0;
	// rd_addr_layr2 <= 9'd0;
	// #100;

	// repeat(45)
	// begin
	// 	wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 	wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 	wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 	rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
	// 	rd_addr_layr2 <= 9'd0;
	// 	#100;
	// end

	// repeat(7)
	// begin
	// 	wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 	wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 	wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 	rd_addr_layr1 <= rd_addr_layr1 + 9'd1;

	// 	wr_addr_h2 <= wr_addr_h2 + 9'd1;
	// 	wr_addr_c2 <= wr_addr_c2 + 9'd1;
	// 	rd_addr_layr2 <= rd_addr_layr2 + 9'd1;
	// 	#100;
	// end

	// repeat(6)
	// begin
	// 	addr_x1 <= addr_x1 + 9'd53;
	// 	rd_addr_h1 <= rd_addr_h1 + 9'd53;
	// 	rd_addr_c1 <= rd_addr_c1 + 9'd53;
	// 	rd_addr_x2 <= rd_addr_x2 + 9'd53;
	// 	rd_addr_h2 <= rd_addr_h2 + 9'd8;
	// 	rd_addr_c2 <= rd_addr_c2 + 9'd8;
		
	// 	wr_addr_h2 <= wr_addr_h2 + 9'd1;
	// 	wr_addr_c2 <= wr_addr_c2 + 9'd1;
		
	// 	wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 	wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 	wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 	rd_addr_layr1 <= 9'd0;
	// 	rd_addr_layr2 <= 9'd0;
	// 	#100;

	// 	repeat(45)
	// 	begin
	// 		wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 		wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 		wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 		rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
	// 		rd_addr_layr2 <= 9'd0;
	// 		#100;
	// 	end

	// 	repeat(7)
	// 	begin
	// 		wr_addr_x2 <= wr_addr_x2 + 9'd1;
	// 		wr_addr_h1 <= wr_addr_h1 + 9'd1;
	// 		wr_addr_c1 <= wr_addr_c1 + 9'd1;
	// 		rd_addr_layr1 <= rd_addr_layr1 + 9'd1;

	// 		wr_addr_h2 <= wr_addr_h2 + 9'd1;
	// 		wr_addr_c2 <= wr_addr_c2 + 9'd1;
	// 		rd_addr_layr2 <= rd_addr_layr2 + 9'd1;
	// 		#100;
	// 	end
	// end

	////////////////////////////////////////////////////
	///////////////////////////////////////////////////
	////////////////// RESET //////////////////////////////
	// CLOCK 0
	clk = 1;
	rst <= 1;
	rst_acc <= 1;

	sel_dgate <= 2'b00;
	sel_wghts2 <= 3'b000;
	sel_wghts1 <= 2'b00;
	sel_wght <= 1'b0;
	acc_mac <= 1'b0;

	rd_layr2_wa <= 9'd0;
	rd_layr2_wi <= 9'd0;
	rd_layr2_wf <= 9'd0;
	rd_layr2_wo <= 9'd0;
	rd_layr2_ua <= 6'd0;
	rd_layr2_ui <= 6'd0;
	rd_layr2_uf <= 6'd0;
	rd_layr2_uo <= 6'd0;

	rd_layr1_ua <= 6'd0;
	rd_layr1_ui <= 6'd0;
	rd_layr1_uf <= 6'd0;
	rd_layr1_uo <= 6'd0;

	rd_addr_dstate2 <= 4'd0;
	rd_addr_dout2 <= 4'd0;

	rd_addr_dx2 <= 9'd0;
	rd_addr_dout1 <= 7'd0;
	
	rd_addr_dstate1 <= 7'd0;

	wr_dx2 <= 1'b0;
	wr_addr_dx2 <= 9'd0;
	wr_addr_dout2 <= 4'd0;
	wr_addr_dout1 <= 7'd0;

	wr_addr_da2 <= 6'd48;
	wr_addr_di2 <= 6'd48;
	wr_addr_df2 <= 6'd48;
	wr_addr_do2 <= 6'd48;
	wr_addr_dstate2 <= 4'd8;

	wr_addr_da1 <= 9'd318;
	wr_addr_di1 <= 9'd318;
	wr_addr_df1 <= 9'd318;
	wr_addr_do1 <= 9'd318;
	wr_addr_dstate1 <= 7'd53;

	tstep <= 3'd0;

	rd_layr2_t <= 6'd48;	
	rd_layr2_h <= 6'd48;	
	rd_layr2_a <= 6'd48;	
	rd_layr2_i <= 6'd48;
	rd_layr2_o <= 6'd48;

	rd_layr2_f <= 6'd56;
	rd_layr2_state <= 6'd56;

	rd_layr1_a <= 9'd318;
	rd_layr1_i <= 9'd318;
	rd_layr1_o <= 9'd318;

	rd_layr1_f <= 9'd371;
	rd_layr1_state <= 9'd371;		
	#100;

	repeat(7)
	begin
		/////////////// START LAYER 2 DELTA ///////////////////
		////////////// 1 ST  CELL ////////////////////////////
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
		#100;

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
		#100;

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
		#100;

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

		// rd_layr2_f <= rd_layr2_f - 6'd8;
		#100;

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
		#100;

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
		#100;

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
		rd_layr2_f <= rd_layr2_f - 6'd8;
		#100;
		// $display("dot <= %h \n", o_dgate);

		// CLOCK 7
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
		#100;
		
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
		#100;
		// $display("dat <= %h \n", o_dgate);

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
		#100;
		// $display("dit <= %h \n", o_dgate);


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
		#100;

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
		#100;
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL ///////////////////////
		repeat(8-1)
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
			#100;

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
			#100;

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
			#100;

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

			// rd_layr2_f <= rd_layr2_f - 6'd8;
			#100;

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
			#100;

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
			#100;

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
			
			rd_layr2_f <= rd_layr2_f - 6'd8;
			rd_layr2_state <= rd_layr2_state - 6'd8;
			#100;
			// $display("dot <= %h \n", o_dgate);

			// CLOCK 7
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
			#100;
			
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
			#100;
			// $display("dat <= %h \n", o_dgate);

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
			#100;
			// $display("dit <= %h \n", o_dgate);


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

			rst_mac_bp <= 1'b1;
			#100;

			wr_da2 <= 1'b0;
			wr_di2 <= 1'b0;
			wr_df2 <= 1'b1;
			wr_do2 <= 1'b0;
			wr_dstate2 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

			rst_mac_bp <= 1'b0;
			acc_mac <= 1'b1;

			rd_layr2_t <= rd_layr2_t + 6'd1;
			rd_layr2_h <= rd_layr2_h + 6'd1;
			rd_layr2_a <= rd_layr2_a + 6'd1;
			rd_layr2_i <= rd_layr2_i + 6'd1;
			rd_layr2_o <= rd_layr2_o + 6'd1;

			rd_layr2_f <= rd_layr2_f + 6'd9;
			rd_layr2_state <= rd_layr2_state + 6'd9;
			#100;

		end 
		////////////////// END LAYER 2 DELTA ///////////////////////////

		///////////////// START  CALCULATE dX2 /////////////////////////
		repeat(53-1)
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

			rst_mac_bp = 1'b0;
			wr_dx2 <= 1'b0;
			
			#100;

			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b010;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b011;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b000;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b1;

			rd_layr2_wa <= rd_layr2_wa + 9'd1;
			rd_layr2_wi <= rd_layr2_wi + 9'd1;
			rd_layr2_wf <= rd_layr2_wf + 9'd1;
			rd_layr2_wo <= rd_layr2_wo + 9'd1;
			#100;	

			rst_mac_bp = 1'b1;
			wr_dx2 <= 1'b0;
			wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
			#100;
		end

		// Last Repeat to change mux on last cycle
		sel_dgate <= 2'b01;
		sel_wghts2 <= 3'b001;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		rst_mac_bp = 1'b0;
		wr_dx2 <= 1'b0;	
		#100;

		sel_dgate <= 2'b10;
		sel_wghts2 <= 3'b010;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b0;
		#100;

		sel_dgate <= 2'b11;
		sel_wghts2 <= 3'b011;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b0;
		#100;
		
		sel_dgate <= 2'b00;
		sel_wghts2 <= 3'b000;
		sel_wght <= 1'b0;
		acc_mac <= 1'b1;

		wr_dx2 <= 1'b1;

		rd_layr2_wa <= rd_layr2_wa + 9'd1;
		rd_layr2_wi <= rd_layr2_wi + 9'd1;
		rd_layr2_wf <= rd_layr2_wf + 9'd1;
		rd_layr2_wo <= rd_layr2_wo + 9'd1;	
		#100;	

		rst_mac_bp = 1'b1;
		wr_dx2 <= 1'b0;
		wr_addr_dx2 <= wr_addr_dx2 + 9'd1;
		sel_wghts2 <= 3'b100;
		#100;
		
		///////////////// START  CALCULATE dOut2 /////////////////////////
		repeat(8)
		begin
			sel_dgate <= 2'b01;
			sel_wghts2 <= 3'b101;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			rst_mac_bp = 1'b0;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;		
			#100;

			sel_dgate <= 2'b10;
			sel_wghts2 <= 3'b110;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts2 <= 3'b111;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts2 <= 3'b100;
			sel_wght <= 1'b0;
			acc_mac <= 1'b1;

			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b1;

			rd_layr2_ua <= rd_layr2_ua + 6'd1;
			rd_layr2_ui <= rd_layr2_ui + 6'd1;
			rd_layr2_uf <= rd_layr2_uf + 6'd1;
			rd_layr2_uo <= rd_layr2_uo + 6'd1;
			#100;	
		
			rst_mac_bp = 1'b1;
			wr_dx2 <= 1'b0;
			wr_dout2 <= 1'b0;	
			wr_addr_dout2 <= wr_addr_dout2 + 4'd1;
			#100;
		end

		///////////////// START  CALCULATE LAYER 1 DELTA /////////////////////////
		//////////////// 1 ST CELL //////////////////////////////////////////////
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
		#100;

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
		#100;

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
		#100;

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

		// rd_layr1_f <= rd_layr1_f - 9'd53;
		#100;

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
		#100;

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
		#100;

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

		rd_layr1_f <= rd_layr1_f - 9'd53;
		rd_layr1_state <= rd_layr1_state - 9'd53;
		#100;
		// $display("dot <= %h \n", o_dgate);

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
		#100;
		
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
		#100;
		// $display("dat <= %h \n", o_dgate);

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
		#100;
		// $display("dit <= %h \n", o_dgate);


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
		#100;

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
		#100;
		// $display("dft = %h \n", o_dgate);

		//////////////// 2 ND TO LAST CELL //////////////////////
		repeat(53-1)
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
			#100;

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
			#100;

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
			#100;

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

			// rd_layr1_f <= rd_layr1_f - 9'd53;
			#100;

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
			#100;

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
			#100;

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

			rd_layr1_f <= rd_layr1_f - 9'd53;
			rd_layr1_state <= rd_layr1_state - 9'd53;
			#100;
			// $display("dot <= %h \n", o_dgate);

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
			#100;
			
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
			#100;
			// $display("dat <= %h \n", o_dgate);

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
			#100;
			// $display("dit <= %h \n", o_dgate);


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

			rst_mac_bp <= 1'b1;
			#100;

			wr_da1 <= 1'b0;
			wr_di1 <= 1'b0;
			wr_df1 <= 1'b1;
			wr_do1 <= 1'b0;
			wr_dstate1 <= 1'b1;
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b1;
			acc_do <= 1'b0;

			rst_mac_bp <= 1'b0;
			acc_mac <= 1'b1;
			rd_addr_dx2 <= rd_addr_dx2 + 9'd1;

			rd_layr1_a <= rd_layr1_a + 9'd1;
			rd_layr1_i <= rd_layr1_i + 9'd1;
			rd_layr1_o <= rd_layr1_o + 9'd1;
			
			rd_layr1_f <= rd_layr1_f + 9'd54;
			rd_layr1_state <= rd_layr1_state + 9'd54;
			#100;

		end 
		////////////////// END LAYER 1 DELTA ///////////////////////////

		///////////////// START  CALCULATE dOut2 /////////////////////////
		repeat(53)
		begin
			acc_da <= 1'b0;
			acc_di <= 1'b0;
			acc_df <= 1'b0;
			acc_do <= 1'b0;

			sel_dgate <= 2'b01;
			sel_wghts1 <= 2'b01;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			rst_mac_bp = 1'b0;
			wr_dout1 <= 1'b0;
			wr_df1 <= 1'b0;		
			#100;

			sel_dgate <= 2'b10;
			sel_wghts1 <= 2'b10;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
			#100;

			sel_dgate <= 2'b11;
			sel_wghts1 <= 2'b11;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b0;
			#100;
			
			sel_dgate <= 2'b00;
			sel_wghts1 <= 2'b00;
			sel_wght <= 1'b1;
			acc_mac <= 1'b1;

			wr_dout1 <= 1'b1;

			rd_layr1_ua <= rd_layr1_ua + 6'd1;
			rd_layr1_ui <= rd_layr1_ui + 6'd1;
			rd_layr1_uf <= rd_layr1_uf + 6'd1;
			rd_layr1_uo <= rd_layr1_uo + 6'd1;
			#100;	
		
			rst_mac_bp = 1'b1;
			wr_dout1 <= 1'b0;	
			wr_addr_dout1 <= wr_addr_dout1 + 4'd1;
			#100;
		end

		//// CONDITIONING FOR NEXT TIME STEP
		rst <= 1;
		rst_acc <= 1;

		sel_dgate <= 2'b00;
		sel_wghts2 <= 3'b000;
		sel_wghts1 <= 2'b00;
		sel_wght <= 1'b0;
		acc_mac <= 1'b0;

		rd_layr2_wa <= 9'd0;
		rd_layr2_wi <= 9'd0;
		rd_layr2_wf <= 9'd0;
		rd_layr2_wo <= 9'd0;
		rd_layr2_ua <= 6'd0;
		rd_layr2_ui <= 6'd0;
		rd_layr2_uf <= 6'd0;
		rd_layr2_uo <= 6'd0;

		rd_layr1_ua <= 6'd0;
		rd_layr1_ui <= 6'd0;
		rd_layr1_uf <= 6'd0;
		rd_layr1_uo <= 6'd0;

		if (tstep[0] == 1'b1) 
		begin
			rd_addr_dstate2 <= 4'd0;
			rd_addr_dstate1 <= 7'd0;

			wr_addr_dstate2 <= 4'd8;
			wr_addr_dstate1 <= 7'd53;
		end
		else 
		begin
			rd_addr_dstate2 <= 4'd8;
			rd_addr_dstate1 <= 7'd53;

			wr_addr_dstate2 <= 4'd0;
			wr_addr_dstate1 <= 7'd0;
		end

		wr_dx2 <= 1'b0;

		rd_addr_dx2 <= 9'd0;
		rd_addr_dout2 <= 4'd0;
		rd_addr_dout1 <= 7'd0;

		wr_addr_dx2 <= 9'd0;
		wr_addr_dout2 <= 4'd0;
		wr_addr_dout1 <= 7'd0;

		wr_addr_da2 <= wr_addr_da2 - 6'd15;
		wr_addr_di2 <= wr_addr_di2 - 6'd15;
		wr_addr_df2 <= wr_addr_df2 - 6'd15;
		wr_addr_do2 <= wr_addr_do2 - 6'd15;

		wr_addr_da1 <= wr_addr_da1 - 9'd105;
		wr_addr_di1 <= wr_addr_di1 - 9'd105;
		wr_addr_df1 <= wr_addr_df1 - 9'd105;
		wr_addr_do1 <= wr_addr_do1 - 9'd105;

		tstep <= tstep + 3'd1;

		rd_layr2_t <= rd_layr2_t - 6'd16;
		rd_layr2_h <= rd_layr2_h - 6'd16;
		rd_layr2_a <= rd_layr2_a - 6'd16;
		rd_layr2_i <= rd_layr2_i - 6'd16;
		rd_layr2_o <= rd_layr2_o - 6'd16;

		rd_layr2_f <= rd_layr2_f - 6'd16;
		rd_layr2_state <= rd_layr2_state - 6'd16;

		rd_layr1_a <= rd_layr1_a - 9'd106;
		rd_layr1_i <= rd_layr1_i - 9'd106;
		rd_layr1_o <= rd_layr1_o - 9'd106;

		rd_layr1_f <= rd_layr1_f - 9'd106;
		rd_layr1_state <= rd_layr1_state - 9'd106;
		#100;

	end
end

always
begin
	#50;
	clk = !clk;
end

endmodule