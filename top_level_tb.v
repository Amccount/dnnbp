module top_level_tb();

// parameters
parameter WIDTH = 24;

// registers
reg clk, /*rst,*/ rst_fsm;

// wires
wire signed [WIDTH-1:0] o_cost;

top_level #(.WIDTH(WIDTH)) inst_top_level ( .clk(clk), /*.rst(rst),*/ .rst_fsm(rst_fsm), .o_cost(o_cost)	);

initial
begin
	clk <= 1;
	// rst <= 1;
	rst_fsm <= 1;
	#100;
	// rst <= 0;
	rst_fsm <= 0;
end

always
begin
	#50;
	clk = !clk;
end

endmodule