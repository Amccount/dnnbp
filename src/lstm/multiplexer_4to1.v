module multiplexer_4to1 (i_a, i_b, i_c, i_d, sel, o);             
 
// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_a;
input signed [WIDTH-1:0] i_b;
input signed [WIDTH-1:0] i_c;
input signed [WIDTH-1:0] i_d;

// control ports
input [1:0] sel;

// output ports
output signed [WIDTH-1:0] o;

// registers
reg signed [WIDTH-1:0] o;

always@*
begin
    case(sel)
        2'b00 : o = i_a;
        2'b01 : o = i_b;
        2'b10 : o = i_c;
        2'b11 : o = i_d;
        default : o = {(WIDTH){1'b0}};
	endcase
end
endmodule