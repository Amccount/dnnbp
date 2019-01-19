////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Perceptron Module
// File Name        : perceptron.v
// Version          : 3.0
// Description      : Perceptron with NUM inputs, NUM weight, and 1 bias.
//                    Giving output of activation and weight value for
//					  backpropagation purpose.
//
////////////////////////////////////////////////////////////////////////////////

module lstm_cell (clk, rst, acc_x, acc_h, i_x, i_h, i_prev_state,
i_w_a, i_w_i, i_w_f, i_w_o,
i_u_a, i_u_i, i_u_f, i_u_o,  
i_b_a, i_b_i, i_b_f, i_b_o,
o_a, o_i, o_f, o_o, o_c, o_h);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input acc_x, acc_h;

// input ports
input signed [WIDTH-1:0] i_x;
input signed [WIDTH-1:0] i_h;
input signed [WIDTH-1:0] i_prev_state;

input signed [WIDTH-1:0] i_w_a;
input signed [WIDTH-1:0] i_w_i;
input signed [WIDTH-1:0] i_w_f;
input signed [WIDTH-1:0] i_w_o;

input signed [WIDTH-1:0] i_u_a;
input signed [WIDTH-1:0] i_u_i;
input signed [WIDTH-1:0] i_u_f;
input signed [WIDTH-1:0] i_u_o;

input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;

// output ports
output signed [WIDTH-1:0] o_c;
output signed [WIDTH-1:0] o_h;
output signed [WIDTH-1:0] o_a;
output signed [WIDTH-1:0] o_i;
output signed [WIDTH-1:0] o_f;
output signed [WIDTH-1:0] o_o;

// wires
wire signed [WIDTH-1:0] temp_a;
wire signed [WIDTH-1:0] temp_i;
wire signed [WIDTH-1:0] temp_f;
wire signed [WIDTH-1:0] temp_o;
wire signed [WIDTH-1:0] temp_h;

wire signed [WIDTH-1:0] mul_ai;
wire signed [WIDTH-1:0] mul_fc;
wire signed [WIDTH-1:0] state_t;
wire signed [WIDTH-1:0] tanh_state_t;

// Input activation
act_tanh #(
			.WIDTH(WIDTH),
			.FRAC(FRAC)
		) inst_act_tanh (
			.clk (clk),
			.rst (rst),
			.acc_x (acc_x),
			.acc_h (acc_h),
			.i_x (i_x),
			.i_w (i_w_a),
			.i_h (i_h),
			.i_u (i_u_a),
			.i_b (i_b_a),
			.o   (temp_a)
		);

// Input gate
act_sigmoid #(
			.WIDTH(WIDTH),
			.FRAC(FRAC)
		) inst_perceptron_i (
			.clk (clk),
			.rst (rst),
			.acc_x (acc_x),
			.acc_h (acc_h),
			.i_x (i_x),
			.i_w (i_w_i),
			.i_h (i_h),
			.i_u (i_u_i),
			.i_b (i_b_i),
			.o   (temp_i)
		);

// Forget gate
act_sigmoid #(
			.WIDTH(WIDTH),
			.FRAC(FRAC)
		) inst_perceptron_f (
			.clk (clk),
			.rst (rst),
			.acc_x (acc_x),
			.acc_h (acc_h),
			.i_x (i_x),
			.i_w (i_w_f),
			.i_h (i_h),
			.i_u (i_u_f),
			.i_b (i_b_f),
			.o   (temp_f)
		);

// Output gate
act_sigmoid #(
			.WIDTH(WIDTH),
			.FRAC(FRAC)
		) inst_perceptron_o (
			.clk (clk),
			.rst (rst),
			.acc_x (acc_x),
			.acc_h (acc_h),
			.i_x (i_x),
			.i_w (i_w_o),
			.i_h (i_h),
			.i_u (i_u_o),
			.i_b (i_b_o),
			.o   (temp_o)
		);


// a(t) * i(t)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_mult_2in (.i_a(temp_a), .i_b(temp_i), .o(mul_ai));

// f(t) * c(t-1)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst2_mult_2in (.i_a(temp_f), .i_b(i_prev_state), .o(mul_fc));

//state_t = a(t) * i(t) + f(t) * c(t-1)
adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(mul_ai), .i_b(mul_fc), .o(state_t));

// o_h = tanh(state(t)) * o
tanh #(.WIDTH(WIDTH)) inst_tanh (.i(state_t), .o(tanh_state_t));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst3_mult_2in (.i_a(tanh_state_t), .i_b(temp_o), .o(temp_h));

assign o_c = state_t;
assign o_a = temp_a;
assign o_i = temp_i;
assign o_f = temp_f;
assign o_o = temp_o;
assign o_h = temp_h;

endmodule
