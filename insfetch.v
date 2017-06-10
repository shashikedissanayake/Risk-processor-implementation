module stimulus; 

reg clock;
wire [15:0]ins_out;
reg load;
reg [15:0]ins_load;
reg [3:0]l_addr;
reg [3:0]pc_addr; 

initial
	clock = 1'b0;
always  
	#5 clock = ~clock;



insmemory   myfetch(ins_out,ins_load,l_addr,pc_addr,load,clock);


initial
  begin
     #5 ins_load=16'b1100110011001100; l_addr=16'b0000; load=1;  
     #5 $display("output: %b",ins_load);
     #5 pc_addr=16'b0000;   
     #5 $display("output: %b",ins_out);
     #5 ins_load=16'b1111000011110000; l_addr=16'b0010; load=1;  
     #5 $display("output: %b",ins_load);
     #5 pc_addr=16'b0010;   
     #5 $display("output: %b",ins_out);
     #5 pc_addr=16'b0000;   
     #5 $display("output: %b",ins_out);

end  

endmodule

//-------------------Instruction Memory Module-------------------//
module insmemory(ins_out,ins_load,l_addr,pc_addr,load,clock);

input  clock,load;
input  [15:0]ins_load;  //16bit instruction
input  [3:0]l_addr;     //load address
input  [3:0]pc_addr;    //PC address
output reg[15:0]ins_out;   //instruction output 16'bit
reg [7:0]reg_file[64:0];   //Instruction fetch registor

reg[7:0]r1,r2;

//Load
always @(posedge clock&load)
begin
    reg_file[l_addr]=ins_load[15:8];
    reg_file[l_addr+1]=ins_load[7:0];
     
end

//Out
always @(posedge clock)
begin
     r1=reg_file[pc_addr];  
     r2=reg_file[pc_addr+1];
     ins_out={ r1,r2 };
end

endmodule
//--------------------------------------------------------------//