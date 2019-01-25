module datapath(clk, rst, rst_2, acc_x_1, acc_h_1, acc_x_2, acc_h_2, wr_h1, wr_h2, wr_c1, wr_c2, wr_x2, 
	            addr_x1, rd_addr_x2, wr_addr_x2, wr_addr_act_1, 
	            wr_act_1, wr_addr_act_2, wr_act_2, wr_addr_w_1, 
	            wr_w_1, rd_addr_w_1, wr_addr_u_1, wr_u_1, rd_addr_u_1, 
	            wr_addr_b_1, wr_b_1, rd_addr_b_1, wr_addr_w_2,wr_w_2, 
	            rd_addr_w_2, wr_addr_b_2, wr_b_2, 
	            rd_addr_b_2, wr_addr_u_2, wr_u_2, rd_addr_u_2,
                rd_addr_h1, rd_addr_h2, rd_addr_c1, rd_addr_c2,
                wr_addr_h1, wr_addr_h2, wr_addr_c1, wr_addr_c2);

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
// // This holds weights & biases
// parameter LAYR1_A = "layer1_a.list";
// parameter LAYR1_I = "layer1_i.list";
// parameter LAYR1_F = "layer1_f.list";
// parameter LAYR1_O = "layer1_o.list";

parameter LAYR2_X = "layer2_x.list";
parameter LAYR2_H = "layer2_h.list";
parameter LAYR2_C = "layer2_c.list";

// common ports
input clk, rst, rst_2;

input acc_x_1, acc_h_1, acc_x_2, acc_h_2;
// control ports
input [11:0] addr_x1;
input [11:0] rd_addr_x2, wr_addr_x2;

input wr_h1;
input [11:0] rd_addr_h1;
input [11:0] wr_addr_h1;
input wr_c1;
input [11:0] rd_addr_c1;
input [11:0] wr_addr_c1;

input [11:0] wr_addr_act_1;
input wr_act_1;

input [11:0] wr_addr_act_2;
input wr_act_2;

input wr_w_1;
input [11:0] wr_addr_w_1;
input [11:0] rd_addr_w_1;

input wr_b_1;
input [11:0] wr_addr_b_1;
input [11:0] rd_addr_b_1;

input wr_u_1;
input [11:0] wr_addr_u_1;
input [11:0] rd_addr_u_1;

input wr_w_2;
input [11:0] wr_addr_w_2;
input [11:0] rd_addr_w_2;

input wr_b_2;
input [11:0] wr_addr_b_2;
input [11:0] rd_addr_b_2;

input wr_u_2;
input [11:0] wr_addr_u_2;
input [11:0] rd_addr_u_2;

input wr_x2;
input wr_h2;
input [11:0] rd_addr_h2;
input [11:0] wr_addr_h2;

input wr_c2;
input [11:0] rd_addr_c2;
input [11:0] wr_addr_c2;

// registers
reg signed [WIDTH-1:0] reg_c1, reg_c2;
reg signed [WIDTH-1:0] reg_h1, reg_h2;


// wires
wire signed [WIDTH-1:0] data_x1;

wire signed [WIDTH-1:0] prev_c1, prev_c2;
wire signed [WIDTH-1:0] i_mem_h1, i_mem_x2, i_mem_h2;
wire signed [WIDTH-1:0] i_mem_c1, i_mem_c2;
wire signed [WIDTH-1:0] o_mem_c1, o_mem_c2;
wire signed [WIDTH-1:0] o_mem_h1_a, o_mem_h1_b, o_mem_x2;
wire signed [WIDTH-1:0] o_mem_h2_a, o_mem_h2_b;
wire signed [WIDTH-1:0] o_mem_a1, o_mem_a2;
wire signed [WIDTH-1:0] o_mem_i1, o_mem_i2;
wire signed [WIDTH-1:0] o_mem_f1, o_mem_f2;
wire signed [WIDTH-1:0] o_mem_o1, o_mem_o2;

wire signed [WIDTH-1:0] data_x2;

wire signed [WIDTH-1:0] w_a_1;
wire signed [WIDTH-1:0] w_i_1;
wire signed [WIDTH-1:0] w_f_1;
wire signed [WIDTH-1:0] w_o_1;
wire signed [WIDTH-1:0] u_a_1;
wire signed [WIDTH-1:0] u_i_1;
wire signed [WIDTH-1:0] u_f_1;
wire signed [WIDTH-1:0] u_o_1;
wire signed [WIDTH-1:0] b_a_1;
wire signed [WIDTH-1:0] b_i_1;
wire signed [WIDTH-1:0] b_f_1;
wire signed [WIDTH-1:0] b_o_1;
wire signed [WIDTH-1:0] w_a_2;
wire signed [WIDTH-1:0] w_i_2;
wire signed [WIDTH-1:0] w_f_2;
wire signed [WIDTH-1:0] w_o_2;
wire signed [WIDTH-1:0] u_a_2;
wire signed [WIDTH-1:0] u_i_2;
wire signed [WIDTH-1:0] u_f_2;
wire signed [WIDTH-1:0] u_o_2;
wire signed [WIDTH-1:0] b_a_2;
wire signed [WIDTH-1:0] b_i_2;
wire signed [WIDTH-1:0] b_f_2;
wire signed [WIDTH-1:0] b_o_2;
wire signed [WIDTH-1:0] c1, c2;
wire signed [WIDTH-1:0] h1, h2;
wire signed [WIDTH-1:0] a1, a2;
wire signed [WIDTH-1:0] i1, i2;
wire signed [WIDTH-1:0] f1, f2;
wire signed [WIDTH-1:0] o1, o2;




// Input Memory
// out: data (53*WIDTH)

memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_INPUT),
			.TIMESTEP(TIMESTEP),
			.FILENAME(LAYR1_X)
		) mem_x1(
			.clk    (clk),
			.rst    (rst),
			.wr_a   (),
			.addr_a (),
			.addr_b (addr_x1),
			.i_a    (),
			.o_a    (),
			.o_b    (data_x1)
);


// LAYER 1 Output Memory
// in: i (WIDTH)
// out: o (53*WIDTH)

memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME(LAYR1_H)
		) inst_memory_h1 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_h1),
			.addr_a (wr_addr_h1),
			.addr_b (rd_addr_h1),
			.i_a    (i_mem_h1),
			.o_a    (o_mem_h1_a),
			.o_b    (o_mem_h1_b)
);


//LAYER 1 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_a.list")
	) inst_memory_cell_w_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (),
		.o_a    (),
		.o_b    (w_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_i.list")
	) inst_memory_cell_w_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (),
		.o_a    (),
		.o_b    (w_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_f.list")
	) inst_memory_cell_w_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (),
		.o_a    (),
		.o_b    (w_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_w_o.list")
	) inst_memory_cell_w_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_1),
		.addr_b (rd_addr_w_1),
		.i_a    (),
		.o_a    (),
		.o_b    (w_o_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_a.list")
	) inst_memory_cell_u_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_1),
		.addr_b (rd_addr_u_1),
		.i_a    (),
		.o_a    (),
		.o_b    (u_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_i.list")
	) inst_memory_cell_u_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_1),
		.addr_b (rd_addr_u_1),
		.i_a    (),
		.o_a    (),
		.o_b    (u_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_f.list")
	) inst_memory_cell_u_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_1),
		.addr_b (rd_addr_u_1),
		.i_a    (),
		.o_a    (),
		.o_b    (u_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR1_INPUT),
		.TIMESTEP(1),
		.FILENAME("layer1_u_o.list")
	) inst_memory_cell_u_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_1),
		.addr_b (rd_addr_u_1),
		.i_a    (),
		.o_a    (),
		.o_b    (u_o_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_a.list")
	) inst_memory_cell_b_a (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (),
		.o_a    (),
		.o_b    (b_a_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_i.list")
	) inst_memory_cell_b_i (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (),
		.o_a    (),
		.o_b    (b_i_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_f.list")
	) inst_memory_cell_b_f (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (),
		.o_a    (),
		.o_b    (b_f_1)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(1),
		.FILENAME("layer1_b_o.list")
	) inst_memory_cell_b_o (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_1),
		.addr_b (rd_addr_b_1),
		.i_a    (),
		.o_a    (),
		.o_b    (b_o_1)
	);






// LAYER 1 Input Pipeline Register
// in: data (106*WIDTH)
// out: conc_x (106*WIDTH)
// always @(posedge clk) 
// begin
// 	layr1_in <= conc_x1;
// end

// LAYER 1 State Memory
// in: i (WIDTH)
// out: o (WIDTH)



	memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR1_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME("layer1_c.list")
		) inst_mem_c (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_c1),
			.addr_a (wr_addr_c1),
			.addr_b (rd_addr_c1),
			.i_a    (i_mem_c1),
			.o_a    (prev_c1),
			.o_b    ()
		);


// LAYER 1 State Pipeline Register
// in: data (WIDTH)
// out: prev_c (WIDTH)
// always @(posedge clk) 
// begin
// 	prev_c1 <= o_mem_c1;
// end

// LAYER 1 LSTM CELL
// in: conc_x (106*WIDTH), prev_c (WIDTH) 
// out: o_a, o_i, o_f, o_o, o_c, o_h (WIDTH)

lstm_cell #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_cell (
		.clk          (clk),
		.rst          (rst),
		.acc_x        (acc_x_1),
		.acc_h        (acc_h_1),
		.i_x          (data_x1),
		.i_h          (o_mem_h1_a),
		.i_prev_state (prev_c1),
		.i_w_a        (w_a_1),
		.i_w_i        (w_i_1),
		.i_w_f        (w_f_1),
		.i_w_o        (w_o_1),
		.i_u_a        (u_a_1),
		.i_u_i        (u_i_1),
		.i_u_f        (u_f_1),
		.i_u_o        (u_o_1),
		.i_b_a        (b_a_1),
		.i_b_i        (b_i_1),
		.i_b_f        (b_f_1),
		.i_b_o        (b_o_1),
		.o_a          (a1),
		.o_i          (i1),
		.o_f          (f1),
		.o_o          (o1),
		.o_c          (c1),
		.o_h          (h1)
	);


// Write a1 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_a1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (),
		.i_a    (a1),
		.o_a    (o_mem_a1),
		.o_b    ()
	);

// Write f1 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_f1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (),
		.i_a    (f1),
		.o_a    (o_mem_f1),
		.o_b    ()
	);

// Write i1 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_i1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (),
		.i_a    (i1),
		.o_a    (o_mem_i1),
		.o_b    ()
	);

// Write o1 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_o1 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_1),
		.addr_a (wr_addr_act_1),
		.addr_b (),
		.i_a    (o1),
		.o_a    (o_mem_o1),
		.o_b    ()
	);



// LAYER 1 Output Pipeline Register
// in: clk, h (WIDTH)
// out: h (WIDTH)

assign i_mem_h1 = h1; // Loop to write LAYER 1 Output Memory
assign i_mem_c1 = c1; // Loop to write LAYER 1 State Memory



//////////////////////////////////////////////////////////////////////

// Write LAYER 2 Input Memory
assign data_x2 = o_mem_h1_a; 

// LAYER 2 Input Memory
// memory_h1 #(
// 		.WIDTH(WIDTH),
// 		.NUM_LSTM(LAYR1_CELL),
// 		.TIMESTEP(TIMESTEP),
// 		.FILENAME(LAYR2_X)
// 	) mem_x2 (
// 		.clk     (clk),
// 		.rst     (rst),
// 		.wr      (wr_x2),
// 		.rd_addr (rd_addr_x2),
// 		.wr_addr (wr_addr_x2),
// 		.i       (i_mem_x2),
// 		.o       (o_mem_x2)
//	);

//LAYER 2 WEIGHT MEMORY
//LAYER 1 WEIGHT MEMORY
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_a.list")
	) inst_memory_cell_w_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (),
		.o_b    (w_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_i.list")
	) inst_memory_cell_w_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (),
		.o_b    (w_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_f.list")
	) inst_memory_cell_w_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (),
		.o_b    (w_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_w_o.list")
	) inst_memory_cell_w_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_w_2),
		.addr_b (rd_addr_w_2),
		.i_a    (),
		.o_a    (),
		.o_b    (w_o_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_a.list")
	) inst_memory_cell_u_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (),
		.o_b    (u_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_i.list")
	) inst_memory_cell_u_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (),
		.o_b    (u_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_f.list")
	) inst_memory_cell_u_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (),
		.o_b    (u_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL*LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_u_o.list")
	) inst_memory_cell_u_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_u_2),
		.addr_b (rd_addr_u_2),
		.i_a    (),
		.o_a    (),
		.o_b    (u_o_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_a.list")
	) inst_memory_cell_b_a_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_a_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_i.list")
	) inst_memory_cell_b_i_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_i_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_f.list")
	) inst_memory_cell_b_f_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_f_2)
	);

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(1),
		.FILENAME("layer2_b_o.list")
	) inst_memory_cell_b_o_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (),
		.addr_a (wr_addr_b_2),
		.addr_b (rd_addr_b_2),
		.i_a    (),
		.o_a    (),
		.o_b    (b_o_2)
	);


// LAYER 2 Output Memory
// in: clk, rst, wr, rd_addr, wr_addr, i (WIDTH)
// out: o (8*WIDTH)

memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR2_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME("layer2_h.list")
		) inst_memory_h2 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_h2),
			.addr_a (wr_addr_h2),
			.addr_b (rd_addr_h2),
			.i_a    (i_mem_h2),
			.o_a    (o_mem_h2_a),
			.o_b    (o_mem_h2_b)
);



// LAYER 2 Input Pipeline Register
// in: clk, data (61*WIDTH)
// out: conc_x (61*WIDTH)
// always @(posedge clk) 
// begin
// 	layr2_in <= conc_x2;
// end

// LAYER 2 State Memory
// in: i (WIDTH)
// out: o (WIDTH)
memory_cell #(
			.WIDTH(WIDTH),
			.NUM(LAYR2_CELL),
			.TIMESTEP(TIMESTEP+1),
			.FILENAME("layer2_c.list")
		) inst_mem_c2 (
			.clk    (clk),
			.rst    (rst),
			.wr_a   (wr_c2),
			.addr_a (wr_addr_c2),
			.addr_b (rd_addr_c2),
			.i_a    (i_mem_c2),
			.o_a    (prev_c2),
			.o_b    ()
		);

// LAYER 2 State Pipeline Register
// in: data (WIDTH)
// out: prev_c (WIDTH)
// always @(posedge clk)
// begin
// 	prev_c2 <= o_mem_c2;
// end

// LAYER 2 LSTM CELL
// in: clk, rst, sel, wr, i_x(conc_x), i_prev_state(prev_c), 
//     i_w_a, i_w_i, i_w_f, i_w_o, i_b_a, i_b_i,  i_b_f, i_b_o
// out: o_a, o_i, o_f, o_o, o_c, o_h,
//      o_w_a, o_w_i,  o_w_f, o_w_o,  o_b_a, o_b_i, o_b_f, o_b_o,  
lstm_cell #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_cell_2 (
		.clk          (clk),
		.rst          (rst_2),
		.acc_x        (acc_x_2),
		.acc_h        (acc_h_2),
		.i_x          (data_x2),
		.i_h          (o_mem_h2_a),
		.i_prev_state (prev_c2),
		.i_w_a        (w_a_2),
		.i_w_i        (w_i_2),
		.i_w_f        (w_f_2),
		.i_w_o        (w_o_2),
		.i_u_a        (u_a_2),
		.i_u_i        (u_i_2),
		.i_u_f        (u_f_2),
		.i_u_o        (u_o_2),
		.i_b_a        (b_a_2),
		.i_b_i        (b_i_2),
		.i_b_f        (b_f_2),
		.i_b_o        (b_o_2),
		.o_a          (a2),
		.o_i          (i2),
		.o_f          (f2),
		.o_o          (o2),
		.o_c          (c2),
		.o_h          (h2)
	);


assign i_mem_h2 = h2; // Loop to write LAYER 2 Output Memory
assign i_mem_c2 = c2; // Loop to write LAYER 2 State Memory

// Write a2 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_a1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (),
 		.i_a    (a2),
		.o_a    (o_mem_a2),
		.o_b    ()
	);

// Write f2 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_f1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (),
		.i_a    (f2),
		.o_a    (o_mem_f2),
		.o_b    ()
	);

// Write i2 to memory

memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_i1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (),
		.i_a    (i2),
		.o_a    (o_mem_i2),
		.o_b    ()
	);

// Write o2 to memory
memory_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP)
	) inst_memory_cell_o1_2 (
		.clk    (clk),
		.rst    (rst),
		.wr_a   (wr_act_2),
		.addr_a (wr_addr_act_2),
		.addr_b (),
		.i_a    (o2),
		.o_a    (o_mem_o2),
		.o_b    ()
	);



endmodule