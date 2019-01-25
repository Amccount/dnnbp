 ////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Adder-Substractor
// File Name        : addsub.v
// Version          : 1.0
// Description      : adder or substractor for activation function
//
////////////////////////////////////////////////////////////////////////////////

module addsub (i_a, i_b, sel, o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i_a;
input [WIDTH-1:0] i_b;

// output ports
output reg [WIDTH-1:0] o;

// control ports
input sel;

always @*
begin
    if (sel==1'b1)  
        o <= i_a+i_b;
    else
        o <= i_a-i_b;
end


endmodule

