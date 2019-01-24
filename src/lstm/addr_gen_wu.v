module addr_gen_wu (clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;
parameter STOP = 2809;
parameter PAUSE_STR = 53;
parameter PAUSE_LEN = 2;

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

always@(posedge(clk) or posedge(rst))
begin
	if(rst)
	begin
		o_addr <= {ADDR_WIDTH{1'b0}};	
		count1 <= {ADDR_WIDTH{1'b0}};
		count2 <= {ADDR_WIDTH{1'b0}};
	end
	else if (en == 1'b1)
	begin
		if (o_addr != STOP)
		begin		
			if (count1 == PAUSE_STR - 1)
			begin
				if (count2 != PAUSE_LEN)
				begin
					count2 <= count2 + 1;
				end
				else 
				begin
					o_addr <= o_addr + 1;
					count1 <= count1 + 1;
					count1 <= 0;
					count2 <= 0;
				end
			end
			else
			begin
				o_addr <= o_addr + 1;
				count1 <= count1 + 1;
			end
		end
	end
end
endmodule