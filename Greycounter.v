module greycounter(countout,load, hold, countup,countdown,enable,clock);
input [3:0]load;
input hold,countup,countdown,enable,clock;
output [3:0]countout;



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


module MUX(out, i0, i1, i2, i3, s1, s0);
	
	// Port declarations from the I/O diagram
	output out;
	input i0, i1, i2, i3;
	input s1, s0;
	//store tempary values
	reg tempout;
	// Multiplexer output change for an input changes
	always @(s0,s1,i0,i1,i2,i3)
	begin	
	
		case ({s1,s0})
				//if selection 00 select output1
			2'd0 : tempout = i0;
				//if selection 01 select output1
			2'd1 : tempout = i1;
				//if selection 10 select output2
			2'd2 : tempout = i2;
				//if selection 11 select output3
			2'd3 : tempout = i3;
			
			default : $display("Invalid signal");	
		endcase
	

	end	
	
	assign out=tempout;
	
endmodule