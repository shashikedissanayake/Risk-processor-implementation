//----------Lab02-GROUP1--------------//
//---------Simulation duration 80 time units--------//

module test;
// Declare variables to be connected
	//Declare inputs
	reg [15:0] w_word;
	reg [3:0] A_addr,B_addr,C_addr;
	reg load,clear;
	reg clk;
	
	// Declare output wire
	wire [15:0] A_read,B_read;
	
	// Declare register_file to simulate 
	registerfile reg0(A_read,B_read,A_addr,B_addr,C_addr,w_word,load,clear,clk);
	
	//clock module (time period is 10 time units)
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end
	
	initial
	begin
		//test clear
		#1 clear = 0;
		#3 load = 0;A_addr = 4'b0010;B_addr = 4'b0011;
		#2 $display("clear = %b,load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",clear,load,A_addr,B_addr,A_read,B_read);
		//test load word
		#9 clear = 1;load = 1;C_addr = 4'b0010;w_word = 16'b1010101010101110;A_addr = 4'b0010;B_addr = 4'b0011;
		 $display("C_address = %b,load = %b,word = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",C_addr,load,w_word,A_addr,B_addr,A_read,B_read);
		// test read word A & B
		#9 load = 0;A_addr = 4'b0010;B_addr = 4'b0011;
		#2 $display("load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",load,A_addr,B_addr,A_read,B_read);
		//test load word
		#6 load = 1;C_addr = 4'b1111;w_word = 16'b1111000011100011;A_addr = 4'b0010;B_addr = 4'b0011;
		#2 $display("C_address = %b,load = %b,word = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",C_addr,load,w_word,A_addr,B_addr,A_read,B_read);
		// test read word A & B
		#10 load = 0;A_addr = 4'b1111;B_addr = 4'b0010;
		#3 $display("load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",load,A_addr,B_addr,A_read,B_read);
		// test read word in other reg address not initiallize earlier
		#6 load = 0;A_addr = 4'b0010;B_addr = 4'b0011;
		#4 $display("clear = %b,load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",clear,load,A_addr,B_addr,A_read,B_read);
		//test clear
		#8 clear = 0;
		  $display("clear = %b\n",clear);
		#10 clear = 1;load = 0;A_addr = 4'b0010;B_addr = 4'b0011;
		#1 $display("clear = %b,load = %b,A_address = %b,B_address = %b,A = %b,B = %b\n",clear,load,A_addr,B_addr,A_read,B_read);
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
//------------------------------------------------------------------//