
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : addr_gen_bp_dout.v Module
// File Name        : addr_gen_bp_dout.v
// Version          : 1.0
// Description      : Read Write address generator for dout
//					  Used in delta calculation and backprop 
//
////////////////////////////////////////////////////////////////////////////////

module addr_gen_bp_dxdout(clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;
parameter NUM_CELL = 8;
parameter DELAY_RD = 3;
parameter DELAY_WR = 2;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr;

// registers
reg [ADDR_WIDTH-1:0] o_addr;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;
reg [ADDR_WIDTH-1:0] delay;
reg rd;

always @(posedge clk or posedge rst)
begin
	if (rst) begin
		o_addr   <= 0;
		count1   <= {ADDR_WIDTH{1'b0}};
		count2   <= {ADDR_WIDTH{1'b0}};
		rd		 <= 1'b0;
	end
	else if (en == 1)
	begin
		if(count2 == NUM_CELL-1 && count1 == delay)
		begin
			rd <= !rd;
			count1 <= 0;
			count2 <= 0;
		end
		else
		begin
			if(count1 != delay)
			begin
				count1 <= count1 + 1;
			end
			else
			begin
				count1 <= 0;
				count2 <= count2 + 1;
				if (o_addr != NUM_CELL-1)
				begin
					o_addr <= o_addr + 1;
				end
				else
				begin
					o_addr <= 0;
				end
			end
		end
	end
end

always @(posedge clk)
begin
	if(rd)
	begin
		delay <= DELAY_RD;
	end
	else
	begin
		delay <= DELAY_WR;
	end
end

endmodule