////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_fwd_aifo.v Module
// File Name        : addr_gen_fwd_aifo.v
// Version          : 1.0
// Description      : Write address generator for activation result
//					  Used in forward propagation
//
////////////////////////////////////////////////////////////////////////////////
module addr_gen_fwd_aifo (clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;
parameter NUM_CELL = 8;
parameter NUM_INPUT = 53;
parameter TIMESTEP = 7;
parameter DELAY = 2;

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
reg [ADDR_WIDTH-1:0] count3;
reg flag;

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr <= {ADDR_WIDTH{1'b0}};
		offset <= {ADDR_WIDTH{1'b0}};
		count1 <= {ADDR_WIDTH{1'b0}};
		count2 <= {ADDR_WIDTH{1'b0}};
		count3 <= {ADDR_WIDTH{1'b0}};
		flag   <= 1'b0;
	end
	else if (en == 1)
	begin
		if (o_addr != NUM_CELL*TIMESTEP-1 || count1 != NUM_CELL-1 || count2 != 0)
		begin
			// Addressing through each feature then over timestep
			if (count1 == NUM_INPUT-1 && count2 != DELAY)
			begin
				count2 <= count2 + 1;
			end
			else if (count2 == DELAY)
			begin
				count1 <= 0;
				count2 <= 0;
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