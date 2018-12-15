module signtest;

reg [4:0] X;
wire [15:0]out;

signextender signex(out,X);
initial
begin
#1 X = 5'b01010;
#1 $display("input = %b , output = %b",X,out);

#1 X = 5'b11010;
#1 $display("input = %b , output = %b",X,out);


end
endmodule

//-------------------Sign Extender Module-------------------//
module signextender(out,in);
input [4:0]in;
output reg [15:0] out;

always @(in)
begin
	case(in[4])
		1'd0 : 	out = {11'b0,in};
		
		1'd1 :	out = {11'b11111111111,in};

	endcase	
end

endmodule
//-------------------------------------------------------//