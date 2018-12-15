//----------Project-Milestone 1-GROUP1--------------//
//---------Simulation duration 125 time units--------//

module shiftregister;

	// Declare variables to be connected
	// to inputs
	reg PIN[3:0];
	reg serialinr,serialinl;
	reg enable;
	reg S1, S0;
	reg clk;
	// Declare output wire
	wire outserialr,outseriall;
	wire [3:0] outparallel;
	// Declare shiftregister 
	shiftreg4bit mysr(outserialr,outseriall,outparallel,serialinr,serialinl,{PIN[3],PIN[2],PIN[1],PIN[0]},S0,S1,enable,clk);
	
	//clock module time period 10 time units
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end
	
	initial
	begin
		// set input lines
		 PIN = 4'b1010;
		//test load
		#5 enable = 1;S0=1;S1=1;
		// test hold
		#7 enable = 1; S1 = 0; S0 = 0;
		// test enable signal
		#12 enable = 0; S1 = 0; S0 = 1;
		// test enable signal
		#10 enable = 0; S1 = 0; S0 = 1;
		// test shift right without serial-right-shift input
		#10 enable = 1; S1 = 0; S0 = 1;
		// test shift left without serial-left-shift input
		#9 enable = 1; S1 = 1; S0 = 0;
		// test shift right with serial-right-shift input
		#10 enable = 1; S1 = 0; S0 = 1;serialinr = 1;
		// test shift right with serial-right-shift input
		#10 enable = 1; S1 = 0; S0 = 1;serialinr = 0;
		// test shift left with serial-left-shift input
		#10 enable = 1; S1 = 1; S0 = 0;serialinl = 1;
		// test shift left with serial-left-shift input
		#10 enable = 1; S1 = 1; S0 = 0;serialinl = 0;
		PIN = 4'b0101;
		//test load
		#10 enable = 1;S0=1;S1=1;
		// test hold
		#10 enable = 1; S1 = 0; S0 = 0;
		// test enable signal
		#10 enable = 0; S1 = 0; S0 = 1;
	end
	
endmodule



//------------4-bit Shift Register Module----------------//
module shiftreg4bit(serialoutr,serialoutl,parallelout,serialinr,serialinl,parallelin,s0,s1,enable,clock);
//Port declaration
input enable,clock,s0,s1,serialinl,serialinr;
input  [3:0] parallelin;

output  serialoutr,serialoutl;
output [3:0] parallelout;

//registers to tempoery store the results values
reg [3:0] shiftreg;
reg temp0;
reg temp1;

//Make serial right & left out change any change of shift register
always @(shiftreg)
begin
	temp0 = shiftreg[0];
	temp1 = shiftreg[3];
end

//Make shift register as positive edge-triggered
always @(posedge clock&enable)

begin
	begin
	case({s1,s0}) 
		// if selections 00 remain same
		2'd0 :	shiftreg = shiftreg;	

		//if selections 01 shift right
		2'd1 : 
		begin
			//check weather have a signal in serial-shift-right-input 
			if((serialinr == 1'b0)|(serialinr == 1'b1))		
			shiftreg = {serialinr,shiftreg[3:1]};
			else
			shiftreg = shiftreg>>1;
		end

		// if selection 10 shift left
		2'd2 :
		begin
			//check weather have a signal in serial-shift-left-input 
			if((serialinl ==1'b0)|(serialinl==1'b1))		
			shiftreg = {shiftreg[2:0],serialinl};
			else
			shiftreg = shiftreg<<1;
		end
		
		// if selection 11 parallel loading
		2'd3 :	shiftreg = parallelin[3:0];

	default :	$display("Invalid signal");
	
	endcase
	end

end

// assign outputs
assign parallelout[3:0] = shiftreg;
assign serialoutr = temp0;
assign serialoutl = temp1;
 
endmodule
