////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_upd_xhd.v Module
// File Name        : addr_gen_upd_xhd.v
// Version          : 1.0
// Description      : Read address generator for X/H and dgates for dW dU calculation
//					  Used in update parameter stage
//
////////////////////////////////////////////////////////////////////////////////

module addr_gen_upd_xhd(clk, rst, en, o_addr_d, o_addr_x);

// parameters
parameter ADDR_WIDTH = 12;
parameter TIMESTEP  = 7;
parameter NUM_CELL  = 53;
parameter NUM_INPUT = 53;
parameter DELAY     = 1;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr_d;
output [ADDR_WIDTH-1:0] o_addr_x;

// registers
reg [ADDR_WIDTH-1:0] o_addr_d;
reg [ADDR_WIDTH-1:0] o_addr_x;
reg [ADDR_WIDTH-1:0] offset_d;
reg [ADDR_WIDTH-1:0] offset_x;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;
reg [ADDR_WIDTH-1:0] count3;
reg flag;

/*
	count1 is the length of continous counting
	count2 is for delay
	count3 is for number of counting repeat before changing offset

*/

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr_d <= {ADDR_WIDTH{1'b0}};
		o_addr_x <= {ADDR_WIDTH{1'b0}};
		offset_d <= {ADDR_WIDTH{1'b0}};
		offset_x <= {ADDR_WIDTH{1'b0}};
		count1	 <= {ADDR_WIDTH{1'b0}};
		count2	 <= {ADDR_WIDTH{1'b0}};
		count3	 <= {ADDR_WIDTH{1'b0}};
		flag  	 <= 1'b0;
	end
	else if (en == 1)
	begin
		if (o_addr_d != TIMESTEP*NUM_CELL-1 || count1 != TIMESTEP-1 || count2 != 0 || count3 != NUM_INPUT-1)
		begin
			// Addressing by the same cell over timestep
			if 	(count1 == TIMESTEP-1 && count2 != DELAY)
			begin
				count2 <= count2 + 1;
				if(count3 == NUM_INPUT - 1)
				begin
					count3 <= 0;
					offset_d <= offset_d + 1;
					offset_x <= 0;
					flag   <= 1;
				end
				else if (count2 == DELAY - 1)
				begin
					if(flag && DELAY > 1)
					begin
						flag <= 0;
					end
					else
					begin
						count3 <= count3 + 1;
						offset_x <= offset_x + 1;
					end
				end
			end
			else if (count2 == DELAY)
			begin
				count1 <= 0;
				count2 <= 0;
				o_addr_d <= offset_d;
				o_addr_x <= offset_x; 
			end
			else
			begin
				count1 <= count1 + 1;
				o_addr_d <= o_addr_d + NUM_CELL;
				o_addr_x <= o_addr_x + NUM_INPUT;
			end
		end
	end
end

endmodule