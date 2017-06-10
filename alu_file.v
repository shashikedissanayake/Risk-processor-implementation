module alutest;
// Declare variables to be connected
	// to inputs
	reg [15:0] X,Y;
	reg c_in1;
	reg [2:0] c1;

	// Declare output wire
	wire c_out1,lt1,eq1,gt1,overflow1;
	wire [15:0] z1;

 alu my(z1,c_out1,lt1,eq1,gt1,overflow1,X,Y,c_in1,c1);
initial
	begin
	#1 X = 16'b0000000000000001;Y = 16'b1000000000000001;c1 = 3'b101;
	#1 $display("z = %b, c_out = %b\n",z1,c_out1);
	#1 X = 16'b0000000000000001;Y = 16'b1000000000000001;c1 = 3'b100;
	#1 $display("z = %b, c_out = %b\n",z1,c_out1);
	#1 Y = 16'b0000000000000001;X = 16'b1000000000000001;c1 = 3'b101;
	#1 $display("z = %b, c_out = %b\n",z1,c_out1);
	#1 Y = 16'b0000000000000001;X = 16'b1000000000000001;c1 = 3'b100;
	#1 $display("z = %b, c_out = %b\n",z1,c_out1);
	#1 X = 16'b111;Y = 16'b11;c1 = 3'b011;c_in1 = 0;
	#1 $display("z = %b, c_out = %b\n",z1,c_out1);
	#1 X = 16'b111;Y = 16'b101;c_in1 = 0;c1 = 3'b010;
	#1 $display("c in =%b,z = %b, c_out = %b\n",c_in1,z1,c_out1);
	#1 X = 16'b111;Y = 16'b111;c_in1 = 1;c1 = 3'b010;
	#1 $display("c in =%b,z = %b, c_out = %b\n",c_in1,z1,c_out1);
	#1 X = 16'b11;Y = 16'b1111;c_in1 = 0;c1 = 3'b111;
	#1 $display("c in =%b,z = %b, c_out = %b\n",c_in1,z1,c_out1);
	
	
	

	end

endmodule

//-------------------ALU Module-------------------//
module alu(z,c_out,lt,eq,gt,overflow,x,y,c_in,c);

//declare inputs & outputs

input [2:0] c;
input [15:0]x,y;

output reg c_in;
output reg [15:0] z;
output reg c_out,lt,eq,gt,overflow;

always @(c_in,c,x,y)
begin
	case(c)
		//AND operation when control signal is 0
		3'd0:	z = x & y;
		
		//OR operation when control signal is 1
		3'd1:	z = x | y;
		
		//UNSIGNED ADDITION operation when control signal is 2
		3'd2:	begin
				{c_out,z} = x + y; 	
				overflow = c_out;
			end
		
		//UNSIGNED SUBSTRACTION operation when control signal is 3		
		3'd3:	z = x - y;
		
		//SIGNED ADDITION operation when control signal is 4
		3'd4:
		begin
		//two numbers are positive 
        if(x[15]==0 && y[15]==0)
           
		   begin
           {c_in,z} = x + y;
		   overflow = z[15]; 
           end  
		
		//two numbers are negative   
        else if (x[15]==1 && y[15]==1)

           begin
           {c_in,overflow,z[14:0]} = x[14:0] + y[14:0];
		   z[15] = 1'b1;  
           end  
		   
		//x positive and y negative   
        else if(x[15]==0 && y[15]==1)

           begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b1,y[14:0] - x[14:0]};
                   end  
                else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0;
		  end
		else
                   begin 
                   z = {1'b0,x[14:0] - y[14:0]};
                   end                       
           end
		   
		//y positive and x negative   
		else  if(x[15]==1 && y[15]==0)

           begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b0,y[14:0] - x[14:0]};
                   end 
		else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0;
		  end 
                else
                   begin 
                   z = {1'b1,x[14:0] - y[14:0]};
                   end                      
            end   
  
		end
		
		//SIGNED SUBSTRACTION operation when control signal is 5
		3'd5:
		begin
		//two numbers are positive 
        if(x[15]==0 && y[15]==0)
           
		   begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b1,x[14:0] - y[14:0]};
                   end 
		else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0;
		  end 
                else
                   begin 
                   z = {1'b0,x[14:0] - y[14:0]};
                   end                       
           end 
		
		//two numbers are negative   
        else if (x[15]==1 && y[15]==1)

           begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b0,x[14:0] - y[14:0]};
                   end 
		else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0;
		  end 
                else
                   begin 
                   z = {1'b1,x[14:0] - y[14:0]};
                   end                       
           end 
		   
		//x positive and y negative   
        else if(x[15]==0 && y[15]==1)

           begin
                {c_in,overflow,z[14:0]} = x[14:0] + y[14:0];   
				z[15] = 1'b0;
           end
		   
		//y positive and x negative   
		else  if(x[15]==1 && y[15]==0)

           begin
                {c_in,overflow,z[14:0]} = x[14:0] + y[14:0];   
				z[15] = 1'b1;                    
            end   
  
		end
		
		//SLT operation when control signal is 7
		3'd7:	
			begin
				if(x < y)
					begin
					z = 16'd1;
					end
				else if(x > y)
					begin
					z = 16'd0;
					end
			end
		default : $display("Invalid signal");	
	endcase

end

//Less than, Greater than, Equal bit change whenever input changes
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