module addr_gen_c (clk, rst, en, o_addr_h, o_addr_c);

// parameters
parameter ADDR_WIDTH = 12;
parameter STOP = 371;
parameter TRIG = 53;
parameter DELAY = 1;
parameter TIMESTEP = 7;


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
reg [ADDR_WIDTH-1:0] buffer;
reg [ADDR_WIDTH-1:0] offset;
reg [ADDR_WIDTH-1:0] offset2;
reg [6:0] count;

always @(posedge (clk) or posedge (rst))
begin
	if (rst)
	begin
		o_addr_h <= {ADDR_WIDTH{1'b0}};
		o_addr_c <= {ADDR_WIDTH{1'b0}};
		buffer   <= {ADDR_WIDTH{1'b0}};
		offset   <= {ADDR_WIDTH{1'b0}};
		offset2  <= {ADDR_WIDTH{1'b0}};
		count	 <= {6{1'b0}};
	end
	else if (en == 1)
	begin
		if (o_addr_c != STOP)
		begin 
			if (buffer == TRIG-1 + DELAY)
			begin
				buffer <= buffer + 1;
				offset <= offset + 1;
				o_addr_c <= TRIG + offset;
				o_addr_h <= TRIG + offset;				
				if (offset-offset2 == TRIG-1)
				begin
					offset2 <= offset2 + TRIG;
				end
			end
			else if (buffer < TRIG-1 + DELAY)
			begin
				buffer <= buffer + 1;
				o_addr_c <= offset;
				o_addr_h <= o_addr_h + 1;
			end
			else
			begin
				buffer <= 0;
				o_addr_c <= offset;
				o_addr_h <= offset2;
			end
		end
	end
end

endmodule