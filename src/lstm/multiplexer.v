module multiplexer (i_a, i_b, sel, o);             
 
// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_a;
input signed [WIDTH-1:0] i_b;

// control ports
input sel;

// output ports
output reg signed [WIDTH-1:0] o;

always @*
begin
    if (sel==1'b1) 
        o <= i_b;
    else
        o <= i_a;
end

 
endmodule
 