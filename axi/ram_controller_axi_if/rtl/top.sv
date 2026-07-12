module top;

logic aclk;
logic arst;

//Clock Generation

initial begin
    aclk = 0;
end

always #5 aclk = ~aclk;


// Reset Generation
initial
begin
    arst = 0;

    #20;

    arst = 1;
end

// AXI Interface

axi_if axi_vif
(
    .aclk(aclk),
    .arst(arst)
);

// RAM Interface Signals

logic        wr_rd;
logic [31:0] ram_addr;
logic [31:0] ram_wdata;
logic [31:0] ram_rdata;

// DUT
ram_controller dut
(

.aclk(aclk),
.arst(arst),

//----------------------------
// Write Address
//----------------------------
.awid     (axi_vif.awid),
.awaddr   (axi_vif.awaddr),
.awlen    (axi_vif.awlen),
.awsize   (axi_vif.awsize),
.awburst  (axi_vif.awburst),
.awlock   (axi_vif.awlock),
.awcache  (axi_vif.awcache),
.awprot   (axi_vif.awprot),
.awvalid  (axi_vif.awvalid),
.awready  (axi_vif.awready),

//----------------------------
// Write Data
//----------------------------
.wdata    (axi_vif.wdata),
.wstrb    (axi_vif.wstrb),
.wlast    (axi_vif.wlast),
.wvalid   (axi_vif.wvalid),
.wready   (axi_vif.wready),

//----------------------------
// Write Response
//----------------------------
.bid      (axi_vif.bid),
.bresp    (axi_vif.bresp),
.bvalid   (axi_vif.bvalid),
.bready   (axi_vif.bready),

//----------------------------
// Read Address
//----------------------------
.arid     (axi_vif.arid),
.araddr   (axi_vif.araddr),
.arlen    (axi_vif.arlen),
.arsize   (axi_vif.arsize),
.arburst  (axi_vif.arburst),
.arlock   (axi_vif.arlock),
.arcache  (axi_vif.arcache),
.arprot   (axi_vif.arprot),
.arvalid  (axi_vif.arvalid),
.arready  (axi_vif.arready),

//----------------------------
// Read Data
//----------------------------
.rid      (axi_vif.rid),
.rdata    (axi_vif.rdata),
.rresp    (axi_vif.rresp),
.rlast    (axi_vif.rlast),
.rvalid   (axi_vif.rvalid),
.rready   (axi_vif.rready),

//----------------------------
// RAM Interface
//----------------------------
.wr_rd      (wr_rd),
.ram_addr   (ram_addr),
.ram_wdata  (ram_wdata),
.ram_rdata  (ram_rdata)

);

// RAM Model

ram_model ram(.clk   (aclk),
				.wr_rd (wr_rd),
				.addr  (ram_addr),
				.wdata (ram_wdata),
				.rdata (ram_rdata));

endmodule

