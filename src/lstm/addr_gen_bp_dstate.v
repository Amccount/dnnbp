////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_bp_dstate.v Module
// File Name        : addr_gen_bp_dstate.v
// Version          : 1.0
// Description      : Read address generator for dstate
//					  Used in delta calculation
//
////////////////////////////////////////////////////////////////////////////////

module addr_gen_bp_dstate(clk, rst, en, o_addr_rd, o_addr_wr);

// parameters
parameter ADDR_WIDTH = 12;
parameter NUM_CELL = 8;
parameter DELAY = 20;
parameter DELTA_TIME = 12;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr_rd;
output [ADDR_WIDTH-1:0] o_addr_wr;

// registers
reg [ADDR_WIDTH-1:0] o_addr_rd;
reg [ADDR_WIDTH-1:0] o_addr_wr;
reg [ADDR_WIDTH-1:0] offset_h;
reg [ADDR_WIDTH-1:0] offset_c;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;
reg [ADDR_WIDTH-1:0] count3;
reg flag;

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr_rd<= 0;
		o_addr_wr<= NUM_CELL;
		offset_h <= {ADDR_WIDTH{1'b0}};
		offset_c <= {ADDR_WIDTH{1'b0}};
		count1   <= {ADDR_WIDTH{1'b0}};
		count2   <= {ADDR_WIDTH{1'b0}};
		count3   <= {ADDR_WIDTH{1'b0}};
		flag	 <= 1'b0;
	end
	else if (en == 1)
	begin
		if (count2 != NUM_CELL-1)
		begin			
			if (count1 != DELTA_TIME-1)
			begin
				count1 <= count1 + 1;
			end
			else
			begin
				count1 <= 0;
				count2 <= count2 + 1;
				if (o_addr_rd != NUM_CELL*2-1)
				begin
					o_addr_rd <= o_addr_rd + 1;	
				end
				else
				begin
					o_addr_rd <= 0;
				end
				if (o_addr_wr != NUM_CELL*2-1)
				begin
					o_addr_wr <= o_addr_wr + 1;
				end
				else
				begin
					o_addr_wr <= 0;
				end	
			end
		end
		else
		begin
			if (count3 != DELAY-1)
			begin
				count3 <= count3 + 1;
			end
			else
			begin
				count2 <= 0;
				count3 <= 0;
				if (o_addr_rd != NUM_CELL*2-1)
				begin
					o_addr_rd <= o_addr_rd + 1;	
				end
				else
				begin
					o_addr_rd <= 0;
				end
				if (o_addr_wr != NUM_CELL*2-1)
				begin
					o_addr_wr <= o_addr_wr + 1;
				end
				else
				begin
					o_addr_wr <= 0;
				end
			end	
		end
	end
end

endmodule