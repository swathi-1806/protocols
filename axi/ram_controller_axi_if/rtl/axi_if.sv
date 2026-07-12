interface axi_if(input logic aclk,input logic arst);

//write address channed
logic [3:0]awid;
logic [31:0]awaddr;
logic [3:0]awlen;
logic [2:0]awsize;
logic [1:0]awburst;
logic awlock;
logic [3:0]awcache;
logic [2:0]awprot;
logic awvalid;
logic awready;


//write data channel
logic [31:0]wdata;
logic [3:0]wstrb; //logic [(DATA_WIDTH/8)-1:0] WSTRB;
logic wlast;
logic wvalid;
logic wready;

//write response channel
logic [3:0]bid;
logic [1:0]bresp;
logic bvalid;
logic bready;

//read address channel
logic [3:0]arid;
logic [31:0]araddr;
logic [3:0]arlen;
logic [2:0]arsize;
logic [1:0]arburst;
logic arlock;
logic [3:0]arcache;
logic [2:0]arprot;
logic arvalid;
logic arready;

//read data channel
logic [3:0]rid;
logic [31:0]rdata;
logic [1:0]rresp;
logic rlast;  
logic rvalid;
logic rready;

endinterface

