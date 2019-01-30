////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_dgates_bp.v Module
// File Name        : addr_gen_dgates_bp.v
// Version          : 1.0
// Description      : Read address generator for δgates and W/U 
//					  Use only in BP when calculating δx and Δout
//
////////////////////////////////////////////////////////////////////////////////

module addr_gen_bp_dwu(clk, rst, en, o_addr_d, o_addr_w);

// parameters
parameter ADDR_WIDTH = 12;
parameter TIMESTEP  = 7;
parameter NUM_CELL  = 8;
// parameter NUM_INPUT = 53;
parameter NUM_INPUT = 53;
parameter DELAY     = 3;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr_d;
output [ADDR_WIDTH-1:0] o_addr_w;

// registers
reg [ADDR_WIDTH-1:0] o_addr_d;
reg [ADDR_WIDTH-1:0] o_addr_w;
reg [ADDR_WIDTH-1:0] offset_d;
reg [ADDR_WIDTH-1:0] offset_w;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;
reg [ADDR_WIDTH-1:0] count3;
reg flag;

/*
	count1 is the length of continous counting
	count2 is for delay
	count3 is for number of counting repeat before changing offset

	offset_w == count3
*/


always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr_d <= NUM_CELL*(TIMESTEP-1);
		o_addr_w <= {ADDR_WIDTH{1'b0}}; 
		offset_d <= NUM_CELL*(TIMESTEP-1);
		offset_w <= {ADDR_WIDTH{1'b0}}; 
		count1   <= {ADDR_WIDTH{1'b0}};
		count2   <= {ADDR_WIDTH{1'b0}};
		count3   <= {ADDR_WIDTH{1'b0}};
		flag	 <= 1'b0;
	end
	else if (en == 1)
	begin
		if (o_addr_d != NUM_CELL-1 || count1 != NUM_CELL-1 || count2 != 0 || count3 != NUM_INPUT-1)
		begin
			// Addressing by same timestep over cell number
 			if 	(count1 == NUM_CELL-1 && count2 != DELAY)
			begin
				count2 <= count2 + 1;
				if (count3 == NUM_INPUT - 1)
				begin
					count3 <= 0;
					offset_d <= offset_d - NUM_CELL;
					offset_w <= 0;
					flag <= 1;	
				end
				else if (count2 == DELAY - 1)
				begin
					if(flag && DELAY>1)
					begin
						flag <= 0;
					end
					else
					begin
						count3 <= count3 + 1;
						offset_w <= offset_w + 1;
					end
				end
			end
			else if (count2 == DELAY)
			begin
				count1 <= 0;
				count2 <= 0;
				o_addr_d <= offset_d;
				o_addr_w <= offset_w;
			end
			else
			begin
				count1 <= count1 + 1;
				o_addr_d <= o_addr_d + 1;
				o_addr_w <= o_addr_w + NUM_INPUT;
			end
		end
	end
end

endmodule