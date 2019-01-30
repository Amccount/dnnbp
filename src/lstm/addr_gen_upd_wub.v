////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_upd_w.v Module
// File Name        : addr_gen_upd_w.v
// Version          : 1.0
// Description      : Write address generator for dW and dU
//					  Used in update parameter stage
//					  Use with three different instance for different delay
//
////////////////////////////////////////////////////////////////////////////////
module addr_gen_upd_wub (clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;
parameter NUM_CELL = 8;
parameter NUM_INPUT = 53;
parameter TIMESTEP = 7;
parameter DELAY = 7;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr;

// registers
reg [ADDR_WIDTH-1:0] o_addr;
reg [ADDR_WIDTH-1:0] offset;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr <= {ADDR_WIDTH{1'b0}};
		offset <= {ADDR_WIDTH{1'b0}};
		count1 <= {ADDR_WIDTH{1'b0}};
		count2 <= {ADDR_WIDTH{1'b0}};
	end
	else if (en == 1)
	begin
		if (o_addr != NUM_CELL*TIMESTEP-1)
		begin
			// Addressing through each feature then over timestep
			if (count1 == DELAY-1)
			begin
				count1 <= 0;
				o_addr <= o_addr + 1;
			end
			else
			begin
				count1 <= count1 + 1;
			end
		end
	end
end
endmodule