module addr_gen_bp_dgates(clk, rst, en, o_addr);

// parameters
parameter ADDR_WIDTH = 12;

// common ports
input clk, rst;

// control ports
input en;

// output ports
output [ADDR_WIDTH-1:0] o_addr;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		
	end
	else
	begin
		
	end
end

endmodule
