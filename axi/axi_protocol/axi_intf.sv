interface axi_intf(input logic aclk,arst);
bit wr_rd;

//====================================================
//write addr channel signals
//====================================================
bit [3:0] awid;
bit [`ADDR_WIDTH-1:0] awaddr;
bit [3:0] awlen;
bit [2:0] awsize;
bit [1:0] awburst;
bit [1:0] awlock;
bit awvalid;
bit awready;

//====================================================
//write data channel signals
//====================================================
bit [3:0] wid;
bit [`DATA_WIDTH-1:0] wdata;
bit [`DATA_WIDTH/8-1:0]wstrb;
bit wlast;
bit wvalid;
bit wready;

//====================================================
//write response channel signals
//====================================================
bit [3:0]bid;
bit [1:0]bresp;
bit bvalid;
bit bready;

//====================================================
 // READ ADDRESS CHANNEL (AR)
 //====================================================
bit [3:0]arid;
bit [`ADDR_WIDTH-1:0] araddr;
bit [3:0]arlen;
bit [2:0]arsize;
bit [1:0]arburst;
bit [1:0]arlock;
bit arvalid;
bit arready;

//====================================================
// READ DATA CHANNEL (R)
//====================================================
bit [3:0]rid;
bit [`DATA_WIDTH-1:0] rdata;
bit rlast;
bit rvalid;
bit rready;
bit [1:0]rresp;

//====================================================
//(master drv clocking block)
//====================================================
clocking bfm_cb@(posedge aclk);
	default input #0 output #0;
	
	output awid ,awaddr,awlen,awsize,awburst,awlock,awvalid;
	input arst,awready;
	
	output wid,wdata,wstrb,wlast,wvalid;
	input wready;
	
	input bid,bresp,bvalid;
	output bready;
	
	output arid,araddr,arlen,arsize,arburst,arlock,arvalid;
	input arready;
	
	input rid,rdata,rlast,rvalid,rresp;
	output #0 rready;
endclocking

//====================================================
//(monitor clocking block)
//====================================================

clocking mon_cb@(posedge aclk);
	default input #1;
	input arst,awid,awaddr,awlen,awsize,awburst,awlock,awvalid,awready;
	input wid,wdata,wstrb,wlast,wvalid,wready;
	input bid,bresp,bvalid,bready;
	input arid,araddr,arlen,arsize,arburst,arlock,arvalid,arready;	
	input rid,rdata,rlast,rvalid,rresp,rready;
endclocking

//====================================================
//(slave drv clocking block)
//====================================================

clocking responder_cb@(posedge aclk);
	default input #1 output #0;
	
	input arst,awid,awaddr,awlen,awsize,awburst,awlock,awvalid;
	output awready,wready;
	input wid,wdata,wstrb,wlast,wvalid;
	output bid,bresp,bvalid;
	input bready;
	
	input arid,araddr,arlen,arsize,arburst,arlock,arvalid;
	output arready;
	output rid,rdata,rlast,rvalid,rresp;
	input rready;
endclocking

endinterface 

