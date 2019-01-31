//Sigmoid function approach using partial linearization
//with 3 gradient value 0,1/4, and 1/8

module sigmf(i,o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output[WIDTH-1:0] o;

wire [WIDTH-1:0] outmux0, outmux1, outmux2, outmux3;
wire [WIDTH-1:0] result;
wire slc0, slc1, slc4; //slc12=slc1 ; slc3 = slc0
wire [WIDTH-1:0] eight_input;
wire [WIDTH-1:0] quarter_input;

assign eight_input = i[WIDTH-1] ? {3'b111, i[WIDTH-1:3]} : {3'b000, i[WIDTH-1:3]};
assign quarter_input = i[WIDTH-1] ? {2'b11, i[WIDTH-1:2]} : {2'b00, i[WIDTH-1:2]};

//Linear region
//mux0 : Constant selector  y1 = 0.4 or y3 = 0.6
assign outmux0 = slc0 ? 32'h000_66666 : 32'h000-99999;
//mux1 : Constant selector outmux1 = c (outmux0 or 0.5)
assign outmux1 = slc1 ? outmux0 : 32'h000_80000;
//mux2 : Gradien selector mx (x/8) or (x/4) 
assign outmux2 = slc1 ? eight_input : quarter_input;
//adder to calculate output function
assign result = outmux2 + outmux1; //mx + c

//Saturation
//mux3 : Saturation selector (0 or 1)
assign outmux3 = slc0 ? 32'h0 : 32'h00100000;
//mux4 : Output selector
assign o = slc4 ? outmux3 : result;

//Select wire assignment
assign slc0 = i[WIDTH-1];                           // slc0 : 1 if negative
assign slc1 = (i<32'hFFF_33334)&&(i>32'h000_CCCCC); // slc1 = (in<-0.8)||(in>0.8)
assign slc4 = (i<32'hFFC_CCCCD)&&(i>32'h003_33333); // slc4 = (in<-3.2)||(in>3.2)
endmodule