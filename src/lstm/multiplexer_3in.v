module multiplexer_3in (i_a, i_b, i_c, sel, o);             
 
// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_a;
input signed [WIDTH-1:0] i_b;
input signed [WIDTH-1:0] i_c;

// control ports
input [1:0] sel;

// output ports
output reg signed [WIDTH-1:0] o;


always @(i_a or i_b or i_c or sel)
begin
	case (sel)
         2'b00 : o <= i_a;
         2'b10 : o <= i_b;
         2'b11 : o <= i_c;
     endcase
end
 
endmodule
 