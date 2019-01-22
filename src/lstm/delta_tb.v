module delta_tb();

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// register
reg clk, rst;
reg [WIDTH-1:0] at, it, ft, ot, h, t, state, d_state, d_out;
reg [1:0] sel_in1;
reg [1:0] sel_in2;
reg sel_in3;
reg [1:0] sel_in4;
reg [2:0] sel_in5;
reg [1:0] sel_x1_1;
reg sel_x1_2;
reg [1:0] sel_x2_2;
reg sel_as_1;
reg [1:0] sel_as_2;
reg sel_addsub;
reg [1:0] sel_temp;


// wires
wire [WIDTH-1:0] o_dgate;

delta #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_delta (
		.clk        (clk),
		.rst        (rst),
		.sel_in1    (sel_in1),
		.sel_in2    (sel_in2),
		.sel_in3    (sel_in3),
		.sel_in4    (sel_in4),
		.sel_in5    (sel_in5),
		.sel_x1_1   (sel_x1_1),
		.sel_x1_2   (sel_x1_2),
		.sel_x2_2   (sel_x2_2),
		.sel_as_1   (sel_as_1),
		.sel_as_2   (sel_as_2),
		.sel_addsub (sel_addsub),
		.sel_temp	(sel_temp),
		.at         (at),
		.it         (it),
		.ft         (ft),
		.ot         (ot),
		.h          (h),
		.t          (t),
		.state      (state),
		.d_state    (d_state),
		.d_out      (d_out),
		.o_dgate    (o_dgate)
	);


initial
begin
	// CLOCK 0
	clk = 1;
	rst <= 1;
	#100;

	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00000000;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 1
	rst <= 0;
	sel_in1 <= 2'h0;
	sel_in2 <= 2'h0;
	sel_in3 <= 1'h0;
	sel_in4 <= 2'h0;
	sel_in5 <= 3'h0;
	sel_x1_1 <= 2'h0;
	sel_x1_2 <= 1'h0;
	sel_x2_2 <= 2'h0;
	sel_as_2 <= 2'h0;
	sel_as_1 <= 1'h0;
	sel_addsub <= 1'h0;
	sel_temp   <= 2'h0;
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00000000;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 2
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00000000;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 3
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00000000;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 4
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 5
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;

	// CLOCK 6
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h0184816f;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;
	$display("dot <= %h \n", o_dgate);

	// CLOCK 7
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h00c924f2;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;
	
	// CLOCK 8
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h00c924f2;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;
	$display("dat <= %h \n", o_dgate);

	// CLOCK 9
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h00c924f2;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#100;
	$display("dit <= %h \n", o_dgate);


	// CLOCK 10
	rst <= 0;
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
	at <= 32'h00d98c7e;
	it <= 32'h00fb2e9c;
	ft <= 32'h00decbfb;
	ot <= 32'h00d99503;
	h  <= 32'h00c59fd3;
	t  <= 32'h01400000;
	state <= 32'h00c924f2;
	d_state <= 32'h00000000;
	d_out   <= 32'h00000000;
	#200;
	$display("dft = %h \n", o_dgate);

end

always 
begin
	#50;
	clk = !clk;
end

endmodule