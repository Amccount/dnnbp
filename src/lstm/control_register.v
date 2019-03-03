module control_register (clk, i, o);

// common ports
input clk;
input [2:0] i;

output reg [2:0] o;

always @posedge(clk) 
begin
	o <= i;
end

endmodule