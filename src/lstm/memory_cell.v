
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//            
///////////////////////////////////////////////////////////////////////////////
module memory_cell(clk, rst, wr_a, addr_a, addr_b, i_a, o_a, o_b);

// parameters
parameter ADDR = 12;
parameter WIDTH = 32;
parameter NUM = 53;
parameter TIMESTEP = 1;
parameter FILENAME = "layer_act.list";

// common ports
input clk, rst, wr_a;

// control ports
input [ADDR-1:0] addr_a;
input [ADDR-1:0] addr_b;
input [WIDTH-1:0] i_a;

// output ports
output reg signed [WIDTH-1:0] o_a;
output reg signed [WIDTH-1:0] o_b;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM*TIMESTEP-1];
initial 
begin
    $readmemh(FILENAME, memory);
end

always @(posedge clk) 
begin
    if (wr_a)
	begin
		memory[addr_a]<=i_a;
		o_a <= memory[addr_a];
	end
	else 
	begin
		o_a <= memory[addr_a];
	end
	
end

always @(posedge clk)
begin
		o_b <= memory[addr_b];
end
	


endmodule



