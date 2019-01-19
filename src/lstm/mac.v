////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Multiply and Accumulate Module
// File Name        : mac.v
// Version          : 1.0
// Description      : 
//
//
//
////////////////////////////////////////////////////////////////////////////////

module mac (clk, rst, acc, i_x, i_m, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input acc;		// acc = 1 -> accumulate, else do nothing

// input ports
input signed [WIDTH-1:0] i_x;
input signed [WIDTH-1:0] i_m;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] o_mul;

// register
reg signed [WIDTH-1:0] o_reg;
reg signed [WIDTH-1:0] o_mux;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_mult_2in (.i_a(i_x), .i_b(i_m), .o(o_mul));
adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(o_reg), .i_b(o_mux), .o(o_add));

// Multiplexing
always@(acc or i_x or i_m)
begin
	if (acc)
	begin
		o_mux <= o_mul;
	end
	else
	begin
		o_mux <= {(WIDTH){1'b0}};
	end
end

// Handle output register
always@(posedge(clk) or posedge(rst))
begin
	if(rst)
	begin
		o_reg <= {(WIDTH){1'b0}};
	end
	else
	begin
		o_reg <= o_add;
	end
end

// Assign output wire to output register
assign o = o_reg;

endmodule