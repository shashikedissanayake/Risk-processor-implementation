module demux;

	// Declare variables to be connected
	// to inputs
	reg IN;
	reg S1, S0;
	
	// Declare output wire
	wire OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3;
	
	// Instantiate the de-multiplexer
	DEMUX my1(OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3,IN, S1, S0);
	
	// Define the demux module (no ports)
	initial
	begin
		// set input lines
		IN = 1;
		 $display("IN= %b\n",IN);
		// choose out0
		#10 S1 = 0; S0 = 0;
		#10 $display("S1 = %b, S0 = %b, OUTPUT0 = %b  OUTPUT1 = %b OUTPUT2 = %b  OUTPUT3 = %b \n", S1, S0, OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3);
		// choose out1
		#20 S1 = 0; S0 = 1;
		#20 $display("S1 = %b, S0 = %b, OUTPUT0 = %b  OUTPUT1 = %b  OUTPUT2 = %b  OUTPUT3 = %b \n", S1, S0, OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3);
		// choose out2
		#30 S1 = 1; S0 = 0;
		#30 $display("S1 = %b, S0 = %b, OUTPUT0 = %b  OUTPUT1 = %b  OUTPUT2 = %b  OUTPUT3 = %b \n", S1, S0, OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3);
		// choose out3
		#40 S1 = 1; S0 = 1;
		#40 $display("S1 = %b, S0 = %b, OUTPUT0 = %b  OUTPUT1 = %b  OUTPUT2 = %b  OUTPUT3 = %b \n", S1, S0, OUTPUT0,OUTPUT1,OUTPUT2,OUTPUT3);
	end
	
endmodule

module DEMUX(out0,out1,out2,out3,i,s1, s0);
	
	// Port declarations from the I/O diagram
	output out0,out1,out2,out3;
	input i;
	input s1, s0;
	
	//De-multiplexer output declaration 
	assign out0 = i &( ~s1) & (~s0);
	assign out1 = i & (~s1) & s0;
	assign out2 = i & s1 & (~s0);	
	assign out3 = i & s1 & s0;

endmodule