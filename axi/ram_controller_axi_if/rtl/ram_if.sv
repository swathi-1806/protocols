//==========================================================================
//ram interface
//==========================================================================
interface ram_if(input logic clk);

logic wr_rd;
logic [31:0]addr;
logic [31:0]wdata;
logic [31:0]rdata;

endinterface

