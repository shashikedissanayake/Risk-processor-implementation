//-------------------JUMP Module-------------------//
module jump(out,offset,pc);
//Declare I/O ports
input [11:0] offset;
input [2:0] pc;
output reg [15:0] out;

always @(offset)
begin
	out = {pc,offset,1'b0};
end
endmodule
//-------------------------------------------------//