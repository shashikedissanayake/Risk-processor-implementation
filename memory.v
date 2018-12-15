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