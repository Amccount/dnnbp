////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Accumulator module
// File Name        : acc.v
// Version          : 1.0
// Description      : Accumulate input over time
//
////////////////////////////////////////////////////////////////////////////////

module acc (clk, rst, acc, i, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input acc;		// acc = 1 -> accumulate, else do nothing

// input ports
input signed [WIDTH-1:0] i;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [WIDTH-1:0] o_add, o_mux;

// register
reg signed [WIDTH-1:0] o_reg;

adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(o_reg), .i_b(o_mux), .o(o_add));

// Multiplexing
assign o_mux = acc ? i : {(WIDTH){1'b0}};

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