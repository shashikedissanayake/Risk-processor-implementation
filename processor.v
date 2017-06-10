//----------processor-GROUP1--------------//
//---------Simulation duration 1000 time units--------//

module processor;
//Inputs and outputs
wire [15:0] pc_old,out_alu1,out_alu2,out_m3,out_m2,out_jump,A,B,w_extend,out_m0,out_alu0;
wire [15:0] mem_read,insout,out_m1,i2,i3;
reg clk,load,clear,CLK;
wire cout,lt,eq,gt,of,s0,c_m2,c_m3,eqbit,c_m0,c_read,c_write,c_m1,lt1,eq1,gt1,of1,cout1;
reg [15:0]laddr,insload;
wire [2:0]c_alu;

	//Components that are use in processor
	controller control({c_m2,c_m1,c_m0},c_m3,c_alu,c_read,c_write,c_load,insout[15:12]);
	
	pc progcounter(pc_old,out_m2,CLK);
	
	alu ALU1(out_alu1,cout,lt,eq,gt,of,pc_old,16'd2,1'b0,3'b010);
	alu ALU2(out_alu2,cout1,lt1,eq1,gt1,of1,out_alu1,w_extend,1'b0,3'b010);
	
	MUX M3(out_m3, out_alu1, out_alu2, i2, i3, 1'b0, s0);
	MUX M2(out_m2, out_m3, out_jump, i2, i3, 1'b0, c_m2);
	
	and m3(s0,c_m3,~eqbit);
	
	insmemory instrucmem(insout,insload,laddr,pc_old,load,clk);
	
	registerfile regfile(A,B,insout[11:8],insout[7:4],insout[3:0],out_m1,c_load,clear,clk);
	
	signextender signword(w_extend,{1'b0,insout[3:0]});
	
	MUX M0(out_m0,B,w_extend, i2, i3, 1'b0, c_m0);
	
	alu ALU0(out_alu0,cout,lt,eqbit,gt,of,A,out_m0,1'b0,c_alu);
	
	memory datamem(mem_read,out_alu0,B,c_read,c_write,clk);

	MUX M1(out_m1,mem_read,out_alu0, i2, i3, 1'b0, c_m1);
	
	jump jumpaddr(out_jump,insout[11:0],pc_old[15:13]);
	
//clock module (time period is 10 time units)
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end
//clock module (time period is 60 time units)
	initial
		CLK = 1'b0;
	always
	begin
	#30 CLK = ~CLK;
	end


endmodule

//-------------------Instruction Memory Module-------------------//
module insmemory(ins_out,ins_load,l_addr,pc_addr,load,clock);

input  clock,load;
input  [15:0]ins_load;  //16bit instruction
input  [15:0]l_addr;     //load address
input  [15:0]pc_addr;    //PC address
output reg[15:0]ins_out;   //instruction output 16'bit
reg [7:0]mem_file[64:0];   //Instruction fetch registor

//Load
initial
begin
	mem_file[0] =  8'b0010_0000;
	mem_file[1] =  8'b0001_0011;

	mem_file[2] =  8'b0000_0000;
	mem_file[3] =  8'b0001_0100;
	
	mem_file[4] =  8'b0001_0000;
	mem_file[5] =  8'b0001_0101;
	
	mem_file[6] =  8'b0110_0000;
	mem_file[7] =  8'b0001_0110;
	
	mem_file[8] =  8'b0111_0000;
	mem_file[9] =  8'b0001_0111;
	
	mem_file[10] =  8'b1010_0000;
	mem_file[11] =  8'b0011_0101;
	
	mem_file[12] =  8'b1000_0110;
	mem_file[13] =  8'b1101_1111;
	
	mem_file[14] =  8'b1110_0000;
	mem_file[15] =  8'b0001_1000;
	
	mem_file[16] =  8'b1000_0110;
	mem_file[17] =  8'b0011_1101;
	
	mem_file[18] =  8'b0010_0000;
	mem_file[19] =  8'b0011_0001;
	
	mem_file[20] =  8'b0000_0000;
	mem_file[21] =  8'b0100_0001;
	
	mem_file[22] =  8'b0001_0000;
	mem_file[23] =  8'b0101_0001;
	
	mem_file[24] =  8'b0010_0000;
	mem_file[25] =  8'b0001_1101;
	
	mem_file[26] =  8'b1111_0000;
	mem_file[27] =  8'b0001_0000;
	
	mem_file[28] =  8'b0110_0000;
	mem_file[29] =  8'b0110_0001;
	
	mem_file[30] =  8'b0111_0000;
	mem_file[31] =  8'b0111_0001;
	
	mem_file[32] =  8'b0000_0000;
	mem_file[33] =  8'b0001_1110;


end

always @(posedge clock&load)
begin
    mem_file[l_addr]=ins_load[15:8];
    mem_file[l_addr+1]=ins_load[7:0];
     
end

//Out
always @(pc_addr)
begin
     ins_out[15:0]={mem_file[pc_addr],mem_file[pc_addr+1]};
end

endmodule
//--------------------------------------------------------------//
	
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
initial
begin
	reg_file[0] = 16'd11;
	reg_file[1] = 16'd10;

end
//clear register files using asynchronous,negative clear signal 
always @(negedge clear)
begin
	for ( count=0; count < 16; count = count + 1)
		begin
			reg_file[count] = 16'd0; 
		end
end

//make register write and read as positive edge triggers 
always @(posedge clock & load)
begin
	// if load = 1 then load word in C to register address in Caddr
	
		reg_file[Caddr]	= C;
end
always @(Aaddr,Baddr)
begin
		//read registry file in every positive edge
		A = reg_file[Aaddr];
		B = reg_file[Baddr];
	end
endmodule
//------------------------------------------------------------------//

//-------------------Multiplexer Module-------------------//
module MUX(out, i0, i1, i2, i3, s1, s0);
	
	// Port declarations from the I/O diagram
	output [15:0]out;
	input [15:0]i0, i1, i2, i3;
	input s1, s0;
	//store tempary values
	reg [15:0]tempout;
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
			
		endcase

	end	
	
	assign out=tempout;
	
endmodule
//---------------------------------------------------------//


//-------------------Sign Extender Module-------------------//
module signextender(out,in);
//Use 5bit because offset is a unsigned number with 4bits
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
		//AND operation when control signal is 0
		3'd0:	z = x & y;
		
		//OR operation when control signal is 1
		3'd1:	z = x | y;
		
		//UNSIGNED ADDITION operation when control signal is 2
		3'd2:	begin
				{c_out,z} = x + y + c_in; 	
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
           {c_out,z} = x + y + c_in ;
		   overflow = z[15]; 
           end  
		
		//two numbers are negative   
        else if (x[15]==1 && y[15]==1)

           begin
           {c_out,overflow,z[14:0]} = x[14:0] + y[14:0] + c_in;
		   z[15] = 1'b1;  
           end  
		   
		//x positive and y negative   
        else if(x[15]==0 && y[15]==1)

           begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b1,y[14:0] - x[14:0] + c_in};
                   end  
                else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0 + c_in;
		  end
		else
                   begin 
                   z = {1'b0,x[14:0] - y[14:0] + c_in};
                   end                       
           end
		   
		//y positive and x negative   
		else  if(x[15]==1 && y[15]==0)

           begin
                if(y[14:0] > x[14:0])   
                  begin 
                   z = {1'b0,y[14:0] - x[14:0] + c_in};
                   end 
		else if(y[14:0] == x[14:0])
		  begin
			z = 16'd0 + c_in;
		  end 
                else
                   begin 
                   z = {1'b1,x[14:0] - y[14:0] + c_in};
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
                {c_out,overflow,z[14:0]} = x[14:0] + y[14:0];   
				z[15] = 1'b0;
           end
		   
		//y positive and x negative   
		else  if(x[15]==1 && y[15]==0)

           begin
                {c_out,overflow,z[14:0]} = x[14:0] + y[14:0];   
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
	
end
endmodule 
//----------------------------------------------------------//

//---------------Data Memory Module-----------------------//
module memory(read,addr,write,memread,memwrite,clock);
//define I/O ports
input [15:0] addr,write;
input memread,memwrite,clock;

output reg [15:0] read;

//declare 32 memory_files
reg [15:0]reg_file[32:0];

//make memory write and read as positive edge triggers 
always @(posedge clock)
begin
	// if load = 1 then load word in C to register address in Caddr
	if(memwrite == 1)
		begin
		reg_file[addr]	= write;
		end
	else if(memread == 1)
		begin
		read = reg_file[addr];
		end
end

endmodule
//------------------------------------------------------------------//

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

//-------------------JUMP Module-------------------//
module jump(out,offset,pc);
//Declare I/O ports
input [11:0] offset;
input [2:0] pc;
output reg [15:0] out;

always @(offset)
begin
	out = {pc,offset,1'b0};
end
endmodule
//-------------------------------------------------//

//-------------------Controller Module-------------------//
module controller(muxinput,inputofand,aluinput,memread,memwrite,regload,opcode);
//Declare input/outputs
input [3:0] opcode;

output reg [2:0] muxinput;	//Multiplexers selection input
output reg inputofand,memread,memwrite,regload;	//input of and gate connected M3,memory read & write selections,reg_file load respectively
output reg [2:0] aluinput;	//Operation selection bits for ALU0

//Make controller as positive edge triggered device 
always @(opcode)
begin
	case(opcode)
	//OPCODE 0000 : AND INSTRUCTION
	4'd0:	begin
				regload = 1;
				memread = 0;
				memwrite = 0;
				inputofand = 0;
				aluinput = 3'd0;
				muxinput[0] = 0;
				muxinput[1] = 1;
				muxinput[2] = 0;
			end
			
	//OPCODE 0001 : OR INSTRUCTION		
	4'd1:	begin
				regload = 1;
				memread = 0;
				memwrite = 0;
				inputofand = 0;
				aluinput = 3'd1;
				muxinput[0] = 0;
				muxinput[1] = 1;
				muxinput[2] = 0;
			end
	
	//OPCODE 0010 : ADD INSTRUCTION
	4'd2:	begin
				regload = 1;
				memread = 0;
				memwrite = 0;
				inputofand = 0;
				aluinput = 3'd4;
				muxinput[0] = 0;
				muxinput[1] = 1;
				muxinput[2] = 0;
			end
	
	//OPCODE 0110 : SUB INSTRUCTION
	4'd6:	begin
				regload = 1;
				memread = 0;
				memwrite = 0;
				inputofand = 0;
				aluinput = 3'd5;
				muxinput[0] = 0;
				muxinput[1] = 1;
				muxinput[2] = 0;
			end
	
	//OPCODE 0111 : SLT INSTRUCTION
	4'd7:	begin
				regload = 1;
				memread = 0;
				memwrite = 0;
				inputofand = 0;
				aluinput = 3'd7;
				muxinput[0] = 0;
				muxinput[1] = 1;
				muxinput[2] = 0;
			end
	
	//OPCODE 1000 : LW INSTRUCTION
	4'd8:	begin
				regload = 1;
				inputofand = 0;
				aluinput = 3'd2;
				memread = 1;
				memwrite = 0;
				muxinput[0] = 1;
				muxinput[1] = 0;
				muxinput[2] = 0;
			end

	//OPCODE 1010 : SW INSTRUCTION
	4'd10:	begin
				regload = 0;
				inputofand = 0;
				aluinput = 3'd2;
				memread = 0;
				memwrite = 1;
				muxinput[0] = 1;
				muxinput[2] = 0;
			end
			
	//OPCODE 1110 : BNE INSTRUCTION
	4'd14:	begin
				regload = 0;
				inputofand = 1;
				aluinput = 3'd7;
				memread = 0;
				memwrite = 0;
				muxinput[0] = 0;
				muxinput[2] = 0;
			end		
	
	//OPCODE 1111 : JUMP INSTRUCTION
	4'd15:	begin
				regload = 0;
				memread = 0;
				memwrite = 0;
				muxinput[2] = 1;
			end	
	
	endcase
end
endmodule
//---------------------------------------------------------//