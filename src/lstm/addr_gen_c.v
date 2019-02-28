////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_c.v Module
// File Name        : addr_gen_c.v
// Version          : 2.0
// Description      : Read address generator for H and C
//					  Used only in forward propagation stage
//
////////////////////////////////////////////////////////////////////////////////

module addr_gen_c (clk, rst, en, o_addr_h, o_addr_c);

// parameters
parameter ADDR_WIDTH = 12;
parameter TIMESTEP = 7;
parameter NUM_CELL = 8;
parameter NUM_INPUT = 53;
parameter DELAY = 48;


// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr_h;
output [ADDR_WIDTH-1:0] o_addr_c;

// registers
reg [ADDR_WIDTH-1:0] o_addr_h;
reg [ADDR_WIDTH-1:0] o_addr_c;
reg [ADDR_WIDTH-1:0] offset_h;
reg [ADDR_WIDTH-1:0] offset_c;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;
reg [ADDR_WIDTH-1:0] count3;
reg flag;

/*
	count1 is the length of continous counting
	count2 is for delay
	count3 is for number of counting repeat before changing offset
*/

always @(posedge (clk) or posedge (rst))
begin
	if (rst)
	begin
		o_addr_h <= {ADDR_WIDTH{1'b0}};
		o_addr_c <= {ADDR_WIDTH{1'b0}};
		offset_h <= {ADDR_WIDTH{1'b0}};
		offset_c <= {ADDR_WIDTH{1'b0}};
		count1   <= {ADDR_WIDTH{1'b0}};
		count2   <= {ADDR_WIDTH{1'b0}};
		count3   <= {ADDR_WIDTH{1'b0}};
		flag	 <= 1'b0;
	end
	else if (en == 1)
	begin
		// Use timestep instead of timestep-1 because h and c need zeros in t = -1
		if (o_addr_c != NUM_CELL*(TIMESTEP+1)-1 || o_addr_h != NUM_CELL*(TIMESTEP+1)-1)
		begin
			// Addressing through each input then cell then over timestep
			if (count1 == NUM_CELL && count2 != DELAY)
			begin
				count2 <= count2 + 1;
				o_addr_h <= offset_c + NUM_CELL;
				o_addr_c <= offset_c + NUM_CELL;

				if (count3 ==  NUM_INPUT - 1)
				begin
					count3 <= 0;
					offset_h <= offset_h + NUM_CELL;
				end
				else if(count2 == DELAY - 1)
				begin
					count3 <= count3 + 1;
					offset_c <= offset_c + 1;
				end
			end
			else if (count2 == DELAY)
			begin
				count1 <= 0;
				count2 <= 0;
				o_addr_h <= offset_h;
				o_addr_c <= offset_c;
			end
			else
			begin
				count1 <= count1 + 1;
				o_addr_h <= o_addr_h + 1;
				o_addr_c <= offset_c;
			end
		end
	end
end

endmodule