
module mux;

	// Declare variables to be connected
	// to inputs
	reg IN0, IN1, IN2, IN3;
	reg S1, S0;
	
	// Declare output wire
	wire OUTPUT;
	
	// Instantiate the multiplexer
	MUX mymux(OUTPUT, IN0, IN1, IN2, IN3, S1, S0);

	// Define the De-multiplexer module (no ports)
	initial
	begin
		// set input lines
		#10 IN0 = 1; IN1 = 0; IN2 = 1; IN3 = 0;
		#1 $display("IN0= %b, IN1= %b, IN2= %b, IN3= %b\n",IN0,IN1,IN2,IN3);
		// choose IN0
		#20 S1 = 0; S0 = 0;
		#10 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
		// choose IN1
		#30 S1 = 0; S0 = 1;
		#20 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
		// choose IN2
		#40 S1 = 1; S0 = 0;
		#30 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
		// choose IN3
		#50 S1 = 1; S0 = 1;
		#40 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
	end
	
endmodule


//-------------------Multiplexer Module-------------------//
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
//---------------------------------------------------------//