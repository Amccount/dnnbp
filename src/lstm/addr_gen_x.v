module addr_gen_x (clk, rst, en, o_addr_x);

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
		o_addr_x <= {ADDR_WIDTH{1'b0}};
		buffer   <= {ADDR_WIDTH{1'b0}};
	end
	else if (en == 1)
	begin
		if (o_addr_c != STOP  && buffer!= DELAY)
		begin 
			o_addr_x <= o_addr_x +1;
			
		end
		else if (buffer!= DELAY)
		begin
			buffer <= buffer +1;
		end
		else if(o_addr_c != STOP  && buffer== DELAY)
		begin
			o_addr_x <=  {ADDR_WIDTH{1'b0}};
		end
	end
end

endmodule