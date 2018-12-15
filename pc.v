module stimulus;

reg clock;
reg [15:0]pc_new;
wire [15:0]pc_old;

initial
	clock = 1'b0;
always  
	#5 clock = ~clock;
initial
	#100 $finish;

pc mypc(pc_old,pc_new);

initial
  begin
     #1  $display("PC: %b",pc_old);
     #1  pc_new=16'b0000000000000010;
     #1  $display("PC: %b",pc_old);
  end


endmodule

//-------------------Program Counter Module-------------------//
module pc(pc_old,pc_new,clock);
input clock
input [15:0]pc_new;
output reg[15:0]pc_old;

initial
   pc_old=16'b0;

always@(posedge clock)
   pc_old=pc_new; 
   
endmodule
//---------------------------------------------------------//