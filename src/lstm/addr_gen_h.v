module addr_gen_h (clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;
parameter STOP = 371;
parameter TRIG = 53;
parameter DELAY = 1;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr;

// registers
reg [ADDR_WIDTH-1:0] o_addr;
reg [ADDR_WIDTH-1:0] buffer;
reg [ADDR_WIDTH-1:0] offset;

always@(posedge(clk) or posedge(rst))
begin
	if (rst)
	begin
		o_addr <= {ADDR_WIDTH{1'b0}};
		offset <= {ADDR_WIDTH{1'b0}};
	end
	else if (en == 1)
	begin
		if (o_addr != STOP)
		begin
			if (buffer == TRIG + DELAY)
			begin
				buffer <= buffer + 1;
				offset <= offset + 1;
				o_addr <= offset + TRIG;
			end
			if (buffer < TRIG + DELAY)
			begin
				buffer <= buffer + 1;
				if (o_addr != TRIG)
				begin
					o_addr <= o_addr + 1;
				end
			end
			else
			begin
				o_addr <= TRIG + offset;
				buffer <= 0;
			end
		end
	end
end
endmodule