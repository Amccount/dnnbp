////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Module
// File Name        : delta.v
// Version          : 2.0
// Description      : Calculate delta with 2 multiplier and one add/sub
//
//
////////////////////////////////////////////////////////////////////////////////

module delta(clk, rst, sel_in1, sel_in2, sel_in3, sel_in4, sel_in5,
			 sel_x1_1, sel_x1_2, sel_x2_2, sel_as_1, sel_as_2, sel_addsub, sel_temp, 
			 at, it, ft, ot, h, t, state, d_state, d_out, o_dgate, o_d_state);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports
//-------- LEGEND ----------
// d_state 	= δstate
// d_out	= Δout
// h 		= output
// t 		= label
//--------------------------
input clk, rst;
input [WIDTH-1:0] at, it, ft, ot, h, t, state, d_state, d_out;

// control ports
input [1:0] sel_in1;
input [1:0] sel_in2;
input sel_in3;
input [1:0] sel_in4;
input [2:0] sel_in5;

input [1:0] sel_x1_1;
input sel_x1_2;
input [1:0] sel_x2_2;
input sel_as_1;
input [1:0] sel_as_2;
input sel_addsub;
input [1:0] sel_temp;

// output ports
output [WIDTH-1:0] o_dgate;
output [WIDTH-1:0] o_d_state;

// wires
wire [WIDTH-1:0] o_mux_in1, o_mux_in2, o_mux_in3, o_mux_in4;
wire [WIDTH-1:0] o_mux_in_x1_1, o_mux_in_x1_2, o_mux_in_x2_2;
wire [WIDTH-1:0] o_mux_in_as_1, o_mux_in_as_2;
wire [WIDTH-1:0] o_mux_temp;
wire [WIDTH-1:0] o_mul1, o_mul2, o_addsub;
wire [WIDTH-1:0] o_tanh, o_tanh2;

// registers
reg [WIDTH-1:0] o_mux_in5;
reg [WIDTH-1:0] in1, in2, in3, in4, in5;
reg [WIDTH-1:0] temp;
reg [WIDTH-1:0] o_x1, o_x2, o_as;


// multiplexer for input register
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in1 (.i_a(at), .i_b(it), .i_c(d_state), .i_d(ft), .sel(sel_in1), .o(o_mux_in1));
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in2 (.i_a(at), .i_b(state), .i_c(o_tanh), .i_d(ft), .sel(sel_in2), .o(o_mux_in2));
multiplexer 	 #(.WIDTH(WIDTH)) inst_mux_in3 (.i_a(ot), .i_b(it), .sel(sel_in3), .o(o_mux_in3));
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in4 (.i_a(d_out),
												.i_b(h),
												.i_c(24'h100000),
												.i_d({(WIDTH){1'b0}}),
												.sel(sel_in4),
												.o(o_mux_in4));

// multiplexer for multiplier and addsub
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in_x1_1 (.i_a(in1), .i_b(o_x2), .i_c(temp), .i_d({(WIDTH){1'b0}}), .sel(sel_x1_1), .o(o_mux_in_x1_1));
multiplexer 	 #(.WIDTH(WIDTH)) inst_mux_in_x1_2 (.i_a(in2), .i_b(o_x1), .sel(sel_x1_2), .o(o_mux_in_x1_2));
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in_x2_2 (.i_a(in3), .i_b(o_x1), .i_c(o_x2), .i_d(o_as), .sel(sel_x2_2), .o(o_mux_in_x2_2));
multiplexer 	 #(.WIDTH(WIDTH)) inst_mux_in_as_1 (.i_a(in4), .i_b(o_x2), .sel(sel_as_1), .o(o_mux_in_as_1));
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in_as_2 (.i_a(in5), .i_b(o_x1), .i_c(temp), .i_d(o_as), .sel(sel_as_2), .o(o_mux_in_as_2));

// multiplier for temporary register
multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_in_reg (.i_a(o_mul1), .i_b(o_addsub), .i_c(temp), .i_d({(WIDTH){1'b0}}), .sel(sel_temp), .o(o_mux_temp));

// Multiplexer - in_5
always@(sel_in5 or t or o_tanh2 or it or ft or ot)
begin
	if (sel_in5 == 3'b000)
	begin
		o_mux_in5 <= t;
	end
	else if (sel_in5 == 3'b001)
	begin
		o_mux_in5 <= o_tanh2;
	end
	else if (sel_in5 == 3'b010)
	begin
		o_mux_in5 <= it;
	end
	else if (sel_in5 == 3'b011)
	begin
		o_mux_in5 <= ft;
	end
	else if (sel_in5 == 3'b100)
	begin
		o_mux_in5 <= ot;
	end
	else
	begin
		o_mux_in5 <= {(WIDTH){1'b0}};
	end
end

// Tanh and Tanh^2
tanh #(.WIDTH(WIDTH)) inst_tanh (.i(state), .o(o_tanh));
tanh_qdrt #(.WIDTH(WIDTH)) inst_tanh_qdrt (.i(state), .o(o_tanh2));

// Multipliers
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_1 (.i_a(o_mux_in_x1_1), .i_b(o_mux_in_x1_2), .o(o_mul1));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_2 (.i_a(o_as), .i_b(o_mux_in_x2_2), .o(o_mul2));

// Adder
addsub #(.WIDTH(WIDTH)) addsub (.i_a(o_mux_in_as_1), .i_b(o_mux_in_as_2), .sel(sel_addsub), .o(o_addsub));

// Handle registers
always@(posedge(clk) or posedge(rst))
begin
	if (rst)
	begin
		in1 <= {(WIDTH){1'b0}};
		in2 <= {(WIDTH){1'b0}};
		in3 <= {(WIDTH){1'b0}};
		in4 <= {(WIDTH){1'b0}};
		in5 <= {(WIDTH){1'b0}};
		o_x1 <= {(WIDTH){1'b0}};
		o_x2 <= {(WIDTH){1'b0}};
		o_as <= {(WIDTH){1'b0}};
		temp <= {(WIDTH){1'b0}};
	end
	else
	begin
		in1 <= o_mux_in1;
		in2 <= o_mux_in2;
		in3 <= o_mux_in3;
		in4 <= o_mux_in4;
		in5 <= o_mux_in5;
		o_x1 <= o_mul1;
		o_x2 <= o_mul2;
		o_as <= o_addsub;
		temp <= o_mux_temp;
	end
end

assign o_dgate = o_x2;
assign o_d_state = temp;

endmodule