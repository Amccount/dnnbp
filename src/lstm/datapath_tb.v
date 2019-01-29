module datapath_tb();

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
			.wr_addr_w_1     (),
			.wr_w_1          (wr_w_1),
			.rd_addr_w_1     (rd_addr_w_1),
			.wr_addr_u_1     (),
			.wr_u_1          (),
			.rd_addr_u_1     (rd_addr_u_1),
			.wr_addr_b_1     (),
			.wr_b_1          (),
			.rd_addr_b_1     (rd_addr_b_1),
			.wr_addr_w_2     (),
			.wr_w_2          (wr_w_2),
			.rd_addr_w_2     (rd_addr_w_2),
			.wr_addr_b_2     (),
			.wr_b_2          (),
			.rd_addr_b_2     (rd_addr_b_2),
			.wr_addr_u_2     (),
			.wr_u_2          (),
			.rd_addr_u_2     (rd_addr_u_2)
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
		rst_2 <=1;
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
			#100;
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
end

always
begin
	#50;
	clk = !clk;
end

endmodule