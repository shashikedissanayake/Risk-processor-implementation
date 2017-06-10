//----------Lab01-GROUP1--------------//
//--------Simulation duration 120 time units--------//


//---------Test bench------------------------------//
module shiftregister;

	// Declare variables to be connected 
	// to inputs
	reg [7:0] PIN;
	reg serialinr,serialinl;
	reg enable;
	reg S1, S0;
	reg clk;
	// Declare output wire
	wire [7:0]outparallel;
	// Declare shiftregister 
	shiftreg8bit sr8bit(outparallel,serialinr,serialinl,{PIN[7],PIN[6],PIN[5],PIN[4],PIN[3],PIN[2],PIN[1],PIN[0]},S0,S1,enable,clk);
	
	//clock module time period 10 time units
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end
	
	initial
	begin
		
		//test load
		#5 enable = 1;S0=1;S1=1;PIN = 8'b10101010;
		#1 $display("PIN = %b, parallel_out = %b\n",PIN,outparallel);
		// test hold
		#8 enable = 1; S1 = 0; S0 = 0;
		#2 $display("enable= %b,S1= %b,S0= %b,parallel_out = %b\n",enable,S1,S0,outparallel);
		// test enable signal
		#8 enable = 0; S1 = 0; S0 = 1;serialinr = 0;
		#2 $display("enable= %b,S1= %b,S0= %b,parallel_out = %b\n",enable,S1,S0,outparallel);
		// test enable signal
		#8 enable = 0; S1 = 0; S0 = 1;serialinr = 0;
		#3 $display("enable= %b,S1= %b,S0= %b,serial_inr =%b,parallel_out = %b\n",enable,S1,S0,serialinr,outparallel);
		// test shift right with serial-right-shift input
		#8 enable = 1; S1 = 0; S0 = 1;serialinr = 1;
		#1 $display("enable= %b,S1= %b,S0= %b,serial_inr =%b,parallel_out = %b\n",enable,S1,S0,serialinr,outparallel);
		// test shift right with serial-right-shift input
		#9 enable = 1; S1 = 0; S0 = 1;serialinr = 0;
		#2 $display("enable= %b,S1= %b,S0= %b,serial_inr =%b,parallel_out = %b\n",enable,S1,S0,serialinr,outparallel);
		// test shift left with serial-left-shift input
		#8 enable = 1; S1 = 1; S0 = 0;serialinl = 1;
		#2 $display("enable= %b,S1= %b,S0= %b,serial_inl =%b,parallel_out = %b\n",enable,S1,S0,serialinl,outparallel);
		// test shift left with serial-left-shift input
		#8 enable = 1; S1 = 1; S0 = 0;serialinl = 0;
		#2 $display("enable= %b,S1= %b,S0= %b,serial_inl =%b,parallel_out = %b\n",enable,S1,S0,serialinl,outparallel);
		//test load		
		#8 enable = 1;S0=1;S1=1;PIN = 8'b01010101;
		#2 $display("PIN = %b, parallel_out = %b\n",PIN,outparallel);
		// test hold
		#8 enable = 1; S1 = 0; S0 = 0;
		#2 $display("enable= %b,S1= %b,S0= %b,parallel_out = %b\n",enable,S1,S0,outparallel);
		
	end
	
endmodule
//--------------------------------------------------------------//

//---------------8-bit Shift Register Module--------------------//
module shiftreg8bit(parallelout,serialinr,serialinl,parallelin,s0,s1,enable,clock);

//Port declaration
input enable,clock,s0,s1,serialinl,serialinr;
input  [7:0] parallelin;

output [7:0] parallelout;

//Call 4bit shift register Module twice for make 8bit shift register
shiftreg4bit first4bitsr(parallelout[7:4],serialinr,parallelout[3],{parallelin[7],parallelin[6],parallelin[5],parallelin[4]},s0,s1,enable,clock);
shiftreg4bit second4bitsr(parallelout[3:0],parallelout[4],serialinl,{parallelin[3],parallelin[2],parallelin[1],parallelin[0]},s0,s1,enable,clock);
endmodule
//---------------------------------------------------------//


//------------4-bit Shift Register Module----------------//
module shiftreg4bit(parallelout,serialinr,serialinl,parallelin,s0,s1,enable,clock);
//Port declaration
input enable,clock,s0,s1,serialinl,serialinr;
input  [3:0] parallelin;

output reg [3:0] parallelout;

//make shift register as change output any of input changes 
always @(clock)
if(enable) 
	begin
	case({s1,s0}) 
		// if selections 00 remain same
		2'd0 :	parallelout = parallelout;	

		//if selections 01 shift right
		2'd1 :	parallelout = {serialinr,parallelout[3:1]};

		// if selection 10 shift left
		2'd2 :	parallelout = {parallelout[2:0],serialinl};
		
		// if selection 11 parallel loading
		2'd3 :	parallelout = parallelin[3:0];

	default :	$display("Invalid signal");
	
	endcase
	end
	
endmodule

//---------------------------------------------------------//
