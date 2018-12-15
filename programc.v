module programco;
wire [15:0]pc_old;
wire [15:0]out;
reg clk;
wire cout,lt,eq,gt,of;
pc progcounter(pc_old,out,clk);
alu ALU0(out,cout,lt,eq,gt,of,pc_old,16'd2,1'b0,3'b010);
//clock module (time period is 10 time units)
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end

endmodule
//-------------------ALU Module-------------------//
module alu(z,c_out,lt,eq,gt,overflow,x,y,c_in,c);

//declare inputs & outputs
input c_in;
input [2:0] c;
input [15:0]x,y;

output reg [15:0] z;
output reg c_out,lt,eq,gt,overflow;

always @(c_in,c,x,y)
begin
	case(c)
		3'd0:	z = x & y;
		
		3'd1:	z = x | y;
		
		3'd2:	begin
				{c_out,z} = x + y + c_in ; 	
				overflow = c_out;
			end
				
		3'd3:	z = x - y;

		3'd7:	
			begin
				if(x < y)
					begin
					z = 16'd1;
					end
				else
					begin
						$display("Invalid signal");
					end
			end
		default : $display("Invalid signal");	
	endcase

end
always @(x,y)
begin
	if(x < y)
		begin
			lt = 1;
			gt = 0;
			eq = 0;
		end
	else if(x > y)
		begin
			lt = 0;
			gt = 1;
			eq = 0;
		end
	else if(x == y)
		begin
			lt = 0;
			gt = 0;
			eq = 1;
		end
	else
		begin
			$display("Invalid signal");
		end
end
endmodule 
//----------------------------------------------------------//

//-------------------Program Counter Module-------------------//
module pc(pc_old,pc_new,clock);
input clock;
input [15:0]pc_new;
output reg[15:0]pc_old;

initial
 pc_old=16'd0;

always@(posedge clock)
begin
   pc_old=pc_new; 
  end
endmodule
//---------------------------------------------------------//