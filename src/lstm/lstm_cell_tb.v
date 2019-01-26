module lstm_cell_tb();

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// registers
reg clk, rst;
reg acc_x, acc_h;

reg signed [WIDTH-1:0] i_x;
reg signed [WIDTH-1:0] i_h;
reg signed [WIDTH-1:0] i_prev_state;

reg signed [WIDTH-1:0] i_w_a;
reg signed [WIDTH-1:0] i_w_i;
reg signed [WIDTH-1:0] i_w_f;
reg signed [WIDTH-1:0] i_w_o;

reg signed [WIDTH-1:0] i_u_a;
reg signed [WIDTH-1:0] i_u_i;
reg signed [WIDTH-1:0] i_u_f;
reg signed [WIDTH-1:0] i_u_o;

reg signed [WIDTH-1:0] i_b_a;
reg signed [WIDTH-1:0] i_b_i;
reg signed [WIDTH-1:0] i_b_f;
reg signed [WIDTH-1:0] i_b_o;

// wires
wire signed [WIDTH-1:0] o_c;
wire signed [WIDTH-1:0] o_h;
wire signed [WIDTH-1:0] o_a;
wire signed [WIDTH-1:0] o_i;
wire signed [WIDTH-1:0] o_o;
wire signed [WIDTH-1:0] o_f;
wire signed [WIDTH-1:0] o_mul_1;
wire signed [WIDTH-1:0] o_mul_2;
wire signed [WIDTH-1:0] o_mul_3;
wire signed [WIDTH-1:0] o_mul_4;
wire signed [WIDTH-1:0] o_mul_5;
wire signed [WIDTH-1:0] o_mul_6;
wire signed [WIDTH-1:0] o_mul_7;
wire signed [WIDTH-1:0] o_mul_8;


lstm_cell #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_lstm_cell (
		.clk          (clk),
		.rst          (rst),
		.acc_x        (acc_x),
		.acc_h        (acc_h),
		.i_x          (i_x),
		.i_h          (i_h),
		.i_prev_state (i_prev_state),
		.i_w_a        (i_w_a),
		.i_w_i        (i_w_i),
		.i_w_f        (i_w_f),
		.i_w_o        (i_w_o),
		.i_u_a        (i_u_a),
		.i_u_i        (i_u_i),
		.i_u_f        (i_u_f),
		.i_u_o        (i_u_o),
		.i_b_a        (i_b_a),
		.i_b_i        (i_b_i),
		.i_b_f        (i_b_f),
		.i_b_o        (i_b_o),
		.o_mul_1      (o_mul_1),
		.o_mul_2      (o_mul_2),
		.o_mul_3      (o_mul_3),
		.o_mul_4      (o_mul_4),
		.o_mul_5      (o_mul_5),
		.o_mul_6      (o_mul_6),
		.o_mul_7      (o_mul_7),
		.o_mul_8      (o_mul_8),
		.o_a          (o_a),
		.o_i          (o_i),
		.o_f          (o_f),
		.o_o          (o_o),
		.o_c          (o_c),
		.o_h          (o_h)
	);



initial begin
	clk = 1;
	rst = 1;
	acc_x = 0;
	acc_h = 0;

	i_x = 32'h00000000;
	i_h = 32'h00000000;
	i_prev_state = 32'h00000000;

	#100;
	rst = 0;
	acc_x = 1;
	acc_h = 1;

	i_x = 32'h01000000;
	i_h = 32'h00000000;
	i_prev_state = 32'h00000000;

	i_w_a = 32'h00733333;
	i_w_i = 32'h00f33333;
	i_w_f = 32'h00b33333;
	i_w_o = 32'h00999999;

	i_u_a = 32'h00266666;
	i_u_i = 32'h00cccccc;
	i_u_f = 32'h00199999;
	i_u_o = 32'h00400000;

	i_b_a = 32'h00333333;
	i_b_i = 32'h00a66666;
	i_b_f = 32'h00266666;
	i_b_o = 32'h00199999;


	#100;
	acc_h = 0;
	acc_x = 1;
	i_x = 32'h02000000;
	i_w_a = 32'h00400000;
	i_w_i = 32'h00cccccc;
	i_w_f = 32'h00733333;
	i_w_o = 32'h00666666;

	#100;
	acc_x = 0;
	
end

always begin
	#50
	clk = !clk;
end

endmodule