////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Tanh Function 
// File Name        : tanh.v
// Version          : 1.0
// Description      : perceptron-like module with tanh activation
//
////////////////////////////////////////////////////////////////////////////////

module tanh_qdrt(i, o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output[WIDTH-1:0] o;


wire sel_coef_1;
wire sel_coef_2;
wire sel_sign;
wire sel_region; 
wire sel_result;
wire [WIDTH-1:0] out_mux_coef_1;
wire [WIDTH-1:0] out_mux_coef_2;

wire [WIDTH-1:0] out_mux_const;
wire [WIDTH-1:0] out_mux_region;
wire [WIDTH-1:0] out_add_sub_1;
wire [WIDTH-1:0] out_add_sub_2;
wire [WIDTH-1:0] abs_input;
wire [WIDTH-1:0] quarter_input;
wire [WIDTH-1:0] half_input;
wire [WIDTH-1:0] eight_input;
reg [WIDTH-1:0] temp;


assign abs_input = i[WIDTH-1] ? (~i + 1) : i; // choosing positive value
assign half_input = {1'b0, temp[WIDTH-1:1]};
assign quarter_input = {2'b00, temp[WIDTH-1:2]};
assign eight_input = {3'b000, temp[WIDTH-1:3]};

multiplexer #(.WIDTH(WIDTH)) mux_coef_1 (.i_a(half_input), .i_b(eight_input), .sel(sel_coef_1), .o(out_mux_coef_1));

multiplexer #(.WIDTH(WIDTH)) mux_coef_2 (.i_a(quarter_input), .i_b(32'h00000000), .sel(sel_coef_2), .o(out_mux_coef_2));

addsub #(.WIDTH(WIDTH)) inst_addsub_1 (.i_a(out_mux_coef_1), .i_b(out_mux_coef_2), .sel(1'b1), .o(out_add_sub_1));
addsub #(.WIDTH(WIDTH)) inst_addsub_2 (.i_a(out_add_sub_1), .i_b(out_mux_const), .sel(sel_sign), .o(out_add_sub_2));

multiplexer_4to1 #(.WIDTH(WIDTH)) inst_mux_const (.i_a(32'h000_26666), .i_b(32'd0), .i_c(32'h004_00000), .i_d(32'h000_AE147), .sel({sel_coef_1, sel_coef_2}), .o(out_mux_const));

multiplexer #(.WIDTH(WIDTH)) mux_region (.i_a(32'h00000000), .i_b(32'h001_00000), .sel(sel_region), .o(out_mux_region));
multiplexer #(.WIDTH(WIDTH)) mux_result (.i_a(out_mux_region), .i_b(out_add_sub_2), .sel(sel_result), .o(o));

assign sel_coef_1 = abs_input>32'h001_00000;
assign sel_coef_2 = abs_input>32'h001_B851E; //1.72
assign sel_sign = abs_input> 32'h001_00000; 
assign sel_result = abs_input<32'h002_8f5c2 && abs_input > 32'h000_33333;
assign sel_region = abs_input >32'h000_33333; //0.2

always @(i or abs_input)
begin
	temp <=abs_input;
end

endmodule
