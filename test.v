module test;
// Declare variables to be connected
	//Declare inputs
	reg [15:0] w_word;
	reg [3:0] A_addr,B_addr,C_addr;
	reg load,clear;
	reg clk;
	reg [15:0] instruction = 16'b0001000100100011;
	// Declare output wire
	wire [15:0] A_read,B_read;
	// Declare variables to be connected
	// to inputs
	reg [15:0] X,Y;
	reg c_in1;
	reg [2:0] c1;

	// Declare output wire
	wire c_out1,lt1,eq1,gt1,overflow1;
	wire [15:0] z1;
	
	// Declare register_file to simulate 
	registerfile reg0(A_read,B_read,A_addr,B_addr,C_addr,w_word,load,clear,clk);
	alu my(z1,c_out1,lt1,eq1,gt1,overflow1,A_read,B_read,c_in1,c1);
	//clock module (time period is 10 time units)
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end
	initial 
	begin 
		#5 load =1;C_addr = instruction[11:8];w_word = 16'b0000000000001111;
		#10 load =1;C_addr = instruction[7:4];w_word = 16'b0000000000001011;
		#10 load =1;A_addr=instruction[11:8];B_addr =instruction[7:4];c1=010;c_in1 = 0;
		#10 load=1;C_addr = instruction[3:0];w_word=z1;
		#10 A_addr = instruction[3:0];
		#2	$display("load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",load,A_addr,B_addr,A_read,B_read);
	end
	


endmodule




//---------------Register File Module-----------------------//
module registerfile(A,B,Aaddr,Baddr,Caddr,C,load,clear,clock);
//define I/O ports
input [3:0] Aaddr,Baddr,Caddr;
input [15:0]C;
input load,clear,clock;

output reg [15:0] A,B;

//declare 16 register_file
reg [15:0]reg_file[15:0];

//declare count variable for for loop
integer count;

//clear register files using asynchronous,negative clear signal 
always @(negedge clear)
begin
	for ( count=0; count < 16; count = count + 1)
		begin
			reg_file[count] = 16'b0000000000000000; 
		end
end

//make register write and read as positive edge triggers 
always @(posedge clock)
begin
	// if load = 1 then load word in C to register address in Caddr
	if(load)
		reg_file[Caddr]	= C;
end
always @(posedge clock)
begin
		//read registry file in every positive edge
		A = reg_file[Aaddr];
		B = reg_file[Baddr];
	end
endmodule




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
			end
				
		3'd3:	z = x - y;

		3'd7:	
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
				else 
					begin
					lt = 0;
					gt = 0;
					eq = 1;
					end
			end
	endcase

end
endmodule 