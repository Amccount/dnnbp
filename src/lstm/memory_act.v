// Dual-Port Block RAM with Two Write Ports
// File: HDL_Coding_Techniques/rams/rams_16.v
module v_rams_16 (clk,wea,addra,addrb,dia,dib,doa,dob);

input clk,wea;
input [8:0] addra,addrb;
input [31:0] dia,dib;
output [31:0] doa,dob;
reg[31:0] ram [0:53*8-1];
reg[31:0] doa,dob;

always @(posedge clk) 
begin
 if (wea)
 begin
 	ram[addra] <= dia;
 	doa <= ram[addra];
 end
end

always @(posedge clk)
begin
 dob <= ram[addrb];
 
end

endmodule