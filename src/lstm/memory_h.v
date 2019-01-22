module memory_h1(clk, rst, wr, rd_addr, wr_addr, i, o);

// parameters
parameter WIDTH = 32;
parameter NUM_LSTM = 53;
parameter TIMESTEP = 7;
parameter FILENAME = "memory_h.list";

// common ports
input clk, rst;

// control ports
input wr;
input [11:0] rd_addr, wr_addr;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output reg signed [WIDTH-1:0] o;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM_LSTM*(TIMESTEP+1)-1];

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		// Reset
		$readmemh(FILENAME, memory);
	end
	else if (wr)
	begin
		// Add 1 last output Value
		memory[wr_addr] = i;
	end
	else begin
		o <= memory [rd_addr];
	end
end




endmodule

module memory_h2(clk, rst, wr, rd_addr, wr_addr, i, o);

// parameters
parameter WIDTH = 32;
parameter NUM_LSTM = 8;
parameter TIMESTEP = 7;
parameter FILENAME = "memory_h.list";

// common ports
input clk, rst;

// control ports
input wr;
input [11:0] rd_addr, wr_addr;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output reg signed [WIDTH-1:0] o;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM_LSTM*(TIMESTEP+1)-1];

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		// Reset
		$readmemh(FILENAME, memory);
	end
	else if (wr)
	begin
		// Add 1 last output Value
		memory[wr_addr] = i;
	end
	else begin
		o <= memory [rd_addr];
	end
end



endmodule