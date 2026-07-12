<<<<<<< HEAD
module ram_model(clk,wr_rd,addr,wdata,rdata);
input bit clk;
input bit wr_rd;
input bit [31:0]addr;
input bit [31:0]wdata;
output bit [31:0]rdata;

//memory declaration
bit [31:0] mem[0:15];

always_ff @(posedge clk)
		begin
			if(wr_rd==0)begin
				mem[addr[3:0]]<=wdata;
              $display("[%0t] WRITE addr=%0d data=%h",
                 $time, addr[3:0], wdata);
			end
			else begin
				rdata <= mem[addr[3:0]];
               $display("[%0t] READ addr=%0d mem=%h",
                 $time, addr[3:0], mem[addr[3:0]]);
			end
		end
endmodule

=======
module ram_model(clk,wr_rd,addr,wdata,rdata);
input bit clk;
input bit wr_rd;
input bit [31:0]addr;
input bit [31:0]wdata;
output bit [31:0]rdata;

//memory declaration
bit [31:0] mem[0:15];

always_ff @(posedge clk)
		begin
			if(wr_rd==0)begin
				mem[addr[3:0]]<=wdata;
              $display("[%0t] WRITE addr=%0d data=%h",
                 $time, addr[3:0], wdata);
			end
			else begin
				rdata <= mem[addr[3:0]];
               $display("[%0t] READ addr=%0d mem=%h",
                 $time, addr[3:0], mem[addr[3:0]]);
			end
		end
endmodule

>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
