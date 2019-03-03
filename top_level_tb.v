module top_level_tb();

// parameters
parameter WIDTH = 24;

// registers
reg clk, /*rst,*/ rst_fsm, i_start;

// wires
wire signed [WIDTH-1:0] o_cost;
wire signed o_stop;


top_level #(.WIDTH(WIDTH)) inst_top_level ( .clk(clk), /*.rst(rst),*/ .rst_fsm(rst_fsm),  .i_start(i_start), .o_stop (o_stop),.o_cost(o_cost)	);

initial
begin
	clk <= 1;
	// rst <= 1;
	rst_fsm <= 1;
	#100;
	// rst <= 0;
	rst_fsm <= 0;
	i_start <=1;
end

always
begin
	#50;
	clk = !clk;
end

endmodule