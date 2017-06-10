//----------Lab03-GROUP1--------------//
//---------Simulation duration 80 time units--------//

module test;
// Declare variables to be connected
	//Declare inputs
	reg [3:0] op_code;
	reg clk;
	
	// Declare output wire
	wire [2:0] alu_op_select,mux_terminal_select;
	wire input_andgate,mem_read,mem_write,reg_load;
	
	// Declare Controller to simulate 
	controller test({mux_terminal_select[0],mux_terminal_select[1],mux_terminal_select[2]},input_andgate,alu_op_select,mem_read,mem_write,reg_load,op_code,clk);
	//mux_terminal_select input order changed because of that display M0,M1,M2 bits respectively
	//clock module (time period is 10 time units)
	initial
		clk = 1'b0;
	always
	begin
	#5 clk = ~clk;
	end

initial
	begin
		//test edge trigged
		#1 op_code = 4'b000;
		#1 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		//test AND OPERATION
		#3 op_code = 4'b000;
		#1 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test OR OPERATION
		#8 op_code = 4'b001;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test ADD OPERATION
		#8 op_code = 4'b010;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test SUB OPERATION
		#8 op_code = 4'b0110;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test SLT OPERATION
		#8 op_code = 4'b0111;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test LW OPERATION
		#8 op_code = 4'b1000;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test SW OPERATION
		#8 op_code = 4'b1010;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test BNE OPERATION
		#8 op_code = 4'b1110;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
		// test JUMP OPERATION
		#8 op_code = 4'b1111;
		#2 $display("op_code = %d,mux_input = %b,and_input = %b,ALU_input = %b,mem_read = %b,mem_write = %b,reg_load = %b\n",op_code,mux_terminal_select,input_andgate,alu_op_select,mem_read,mem_write,reg_load);
		
	end 
	
endmodule

//-------------------Controller Module-------------------//
module controller(muxinput,inputofand,aluinput,memread,memwrite,regload,opcode,clock);
//Declare input/outputs
input [3:0] opcode;
input clock;

output reg [2:0] muxinput;	//Multiplexers selection input
output reg inputofand,memread,memwrite,regload;	//input of and gate connected M3,memory read & write selections,reg_file load respectively
output reg [2:0] aluinput;	//Operation selection bits for ALU0

//Make controller as positive edge triggered device 
always @(posedge clock)
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
				aluinput = 3'd2;
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
				aluinput = 3'd3;
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