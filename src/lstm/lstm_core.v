////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : LSTM Core Module
// File Name        : lstm_core.v
// Version          : 1.0
// Description      : 
//
////////////////////////////////////////////////////////////////////////////////

module lstm_core (clk, rst, acc_x, acc_h, 
i_x1, i_w1, i_h1, i_u1,
i_x2, i_w2, i_h2, i_u2,
i_x3, i_w3, i_h3, i_u3,
i_x4, i_w4, i_h4, i_u4, 
i_prev_state,
i_b_a, i_b_i, i_b_f, i_b_o,
o_mac_1, o_mac_2, o_mac_3, o_mac_4,
o_mac_5, o_mac_6, o_mac_7, o_mac_8,
o_a, o_i, o_f, o_o, o_c, o_h);

// parameters
parameter WIDTH = 24;
parameter FRAC = 20;

// common ports
input clk, rst;

// control ports
input acc_x, acc_h;

// input ports
input signed [WIDTH-1:0] i_x1, i_x2, i_x3, i_x4;
input signed [WIDTH-1:0] i_h1, i_h2, i_h3, i_h4;
input signed [WIDTH-1:0] i_w1, i_w2, i_w3, i_w4;
input signed [WIDTH-1:0] i_u1, i_u2, i_u3, i_u4;
input signed [WIDTH-1:0] i_prev_state;

input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;

// output ports
output signed [WIDTH-1:0] o_mac_1;
output signed [WIDTH-1:0] o_mac_2;
output signed [WIDTH-1:0] o_mac_3;
output signed [WIDTH-1:0] o_mac_4;
output signed [WIDTH-1:0] o_mac_5;
output signed [WIDTH-1:0] o_mac_6;
output signed [WIDTH-1:0] o_mac_7;
output signed [WIDTH-1:0] o_mac_8;

output signed [WIDTH-1:0] o_c;
output signed [WIDTH-1:0] o_h;
output signed [WIDTH-1:0] o_a;
output signed [WIDTH-1:0] o_i;
output signed [WIDTH-1:0] o_f;
output signed [WIDTH-1:0] o_o;

// registers
// reg signed [WIDTH-1:0] reg_a;
// reg signed [WIDTH-1:0] reg_i;
// reg signed [WIDTH-1:0] reg_f;
// reg signed [WIDTH-1:0] reg_o;

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

wire signed [WIDTH-1:0] o_add_1;
wire signed [WIDTH-1:0] o_add_2;
wire signed [WIDTH-1:0] o_add_3;
wire signed [WIDTH-1:0] o_add_4;

/////////////////////////////////////
// MAC Array  //////////////////////
mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_x1 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_x),
		.i_x   (i_x1),
		.i_m   (i_w1),
		.o_mul (),
		.o_mac (o_mac_1)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_h1 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_h),
		.i_x   (i_h1),
		.i_m   (i_u1),
		.o_mul (),
		.o_mac (o_mac_2)
	);



mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_x2 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_x),
		.i_x   (i_x2),
		.i_m   (i_w2),
		.o_mul (),
		.o_mac (o_mac_3)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_h2 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_h),
		.i_x   (i_h2),
		.i_m   (i_u2),
		.o_mul (),
		.o_mac (o_mac_4)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_x3 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_x),
		.i_x   (i_x3),
		.i_m   (i_w3),
		.o_mul (),
		.o_mac (o_mac_5)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_h3 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_h),
		.i_x   (i_h3),
		.i_m   (i_u3),
		.o_mul (),
		.o_mac (o_mac_6)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_x4 (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_x),
		.i_x   (i_x4),
		.i_m   (i_w4),
		.o_mul (),
		.o_mac (o_mac_7)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_h (
		.clk   (clk),
		.rst   (rst),
		.acc   (acc_h),
		.i_x   (i_h4),
		.i_m   (i_u4),
		.o_mul (),
		.o_mac (o_mac_8)
	);

/////////////////////////////////////


/////////////////////////////////////
// Input activation  ///////////////
adder_3in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_adder_3in_1 (.i_a(o_mac_1), .i_b(o_mac_2), .i_c(i_b_a), .o(o_add_1));
tanh inst_tanh_1 (.i(o_add_1), .o(temp_a)); // Using tanh function for the Activation value


/////////////////////////////////////
// Input gate  /////////////////////
adder_3in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_adder_3in_2 (.i_a(o_mac_3), .i_b(o_mac_4), .i_c(i_b_i), .o(o_add_2));
sigmf sigmoid_2 (.i(o_add_2), .o(temp_i)); // Using sigmoid function for the Activation value


/////////////////////////////////////
// Forget gate  ////////////////////
adder_3in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_adder_3in_3 (.i_a(o_mac_5), .i_b(o_mac_6), .i_c(i_b_f), .o(o_add_3));
sigmf sigmoid_3 (.i(o_add_3), .o(temp_f)); // Using sigmoid function for the Activation value


/////////////////////////////////////
// Output gate  ////////////////////
adder_3in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_adder_3in_4 (.i_a(o_mac_7), .i_b(o_mac_8), .i_c(i_b_o), .o(o_add_4));
sigmf sigmoid_4 (.i(o_add_4), .o(temp_o)); // Using sigmoid function for the Activation value


// Pipeline register after activation
// always @(posedge clk) 
// begin
// 	reg_a <= temp_a;
// 	reg_i <= temp_i;
// 	reg_f <= temp_f;
// 	reg_o <= temp_o;
// end

// a(t) * i(t)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_mult_2in (.i_a(temp_a), .i_b(temp_i), .o(mul_ai));

// f(t) * c(t-1)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst2_mult_2in (.i_a(temp_f), .i_b(i_prev_state), .o(mul_fc));

//state_t = a(t) * i(t) + f(t) * c(t-1)
adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(mul_ai), .i_b(mul_fc), .o(state_t));

// o_h = tanh(state(t)) * o
tanh #(.WIDTH(WIDTH)) inst_tanh2 (.i(state_t), .o(tanh_state_t));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst3_mult_2in (.i_a(tanh_state_t), .i_b(temp_o), .o(temp_h));

assign o_c = state_t;
assign o_a = temp_a;
assign o_i = temp_i;
assign o_f = temp_f;
assign o_o = temp_o;
assign o_h = temp_h;

endmodule
