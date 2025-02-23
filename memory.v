 module mem2 (
    input [31 : 0] S_cRAM_write__data,
    input [3 : 0] my_addr,
    input rw,
    output [31 : 0] S_cRAM_read__data
 );
    mem_1 mem_1 (.rw(rw), .addr(my_addr), .inp(S_cRAM_write__data), .out(S_cRAM_read__data));
 endmodule


 module mem_1 (
    input rw,
    input [3 : 0] addr,
    input [31 : 0] inp,
    output [31 : 0] out
 );
    reg [31:0] mem [0:7];

    always @(addr or inp or rw)
    begin
	if( ~rw ) begin
	    mem[addr] = inp;
	end
    end

    always @(addr or rw)
    begin
	if( rw ) begin
	    out = mem[addr];
	end
    end

 endmodule

