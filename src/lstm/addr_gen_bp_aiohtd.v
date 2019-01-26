module addr_gen_bp_aiohtd (clk, rst, en, o_addr_aioht, o_addr_dgates);

// parameters
parameter ADDR_WIDTH = 12;
parameter NUM_CELL   = 8;
parameter TIMESTEP   = 7;
parameter DELTA_TIME = 12;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr_aioht;
output [ADDR_WIDTH-1:0] o_addr_dgates;

// registers
reg [ADDR_WIDTH-1:0] o_addr_aioht;
reg [ADDR_WIDTH-1:0] o_addr_dgates;
reg [ADDR_WIDTH-1:0] count1;
reg [ADDR_WIDTH-1:0] count2;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		count1 <= {ADDR_WIDTH{1'b0}};
		count2 <= {ADDR_WIDTH{1'b0}};
		o_addr_aioht  <= (NUM_CELL * (TIMESTEP - 1));
	end
	else if (en == 1) 
	begin
		// if (count1 == DELTA_TIME - 1)
		// begin
		// 	count1 <=  0;
		// 	if (count2 == NUM_CELL - 1)
		// 	begin
		// 		count2 <= 0;
		// 		o_addr_aioht <= o_addr_aioht - (NUM_CELL * 2 - 1);
		// 	end
		// 	else
		// 	begin
		// 		count2 <= count2 + 1;
		// 		o_addr_aioht <= o_addr_aioht + 1;
		// 	end
		// end
		// else
		// begin
		// 	count1 <= count1 + 1;
		// end


		if (count1 == DELTA_TIME - 2)
		begin
			count1 <=  count1 + 1;
			if (count2 == NUM_CELL - 1)
			begin
				count2 <= 0;
				o_addr_aioht <= o_addr_aioht - (NUM_CELL * 2 - 1);
			end
			else
			begin
				count2 <= count2 + 1;
				o_addr_aioht <= o_addr_aioht + 1;
			end
		end
		else if (count1 == DELTA_TIME - 1)
		begin
			count1 <= 0;
		end
		else
		begin
			count1 <= count1 + 1;
		end
	end
end

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		o_addr_dgates <= (NUM_CELL * (TIMESTEP - 1));
	end
	else
	begin
		o_addr_dgates <= o_addr_aioht;	
	end
end
endmodule