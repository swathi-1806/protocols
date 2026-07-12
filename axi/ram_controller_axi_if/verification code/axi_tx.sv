class axi_tx extends uvm_sequence_item;

    //=================================================
    // Write Address Channel
    //=================================================

    rand bit [3:0]  awid;
    rand bit [31:0] awaddr;
    rand bit [3:0]  awlen;
    rand bit [2:0]  awsize;
    rand bit [1:0]  awburst;
    rand bit        awlock;
    rand bit [3:0]  awcache;
    rand bit [2:0]  awprot;

    //=================================================
    // Write Data Channel
    //=================================================

    rand bit [31:0] wdata;
    rand bit [3:0]  wstrb;
    rand bit        wlast;

    //=================================================
    // Read Address Channel
    //=================================================

    rand bit [3:0]  arid;
    rand bit [31:0] araddr;
    rand bit [3:0]  arlen;
    rand bit [2:0]  arsize;
    rand bit [1:0]  arburst;
    rand bit        arlock;
    rand bit [3:0]  arcache;
    rand bit [2:0]  arprot;

    //=================================================
    // Read Data
    //=================================================

    bit [31:0] rdata;

    //=================================================
    // Responses
    //=================================================

    bit [1:0] bresp;
    bit [1:0] rresp;

    //=================================================
    // Transaction Type
    //=================================================

    rand bit write;//write=1-->write tx ; write =0 -->read tx

    //=================================================
    // Constraints
    //=================================================

    constraint c_single_transfer
    {
        awlen == 0;
        arlen == 0;

        wlast == 1;

        awsize == 3'b010;
        arsize == 3'b010;

        awburst == 2'b01;
        arburst == 2'b01;
    }

    //=================================================
    // Factory Registration
    //=================================================

  `uvm_object_utils(axi_tx)

    //=================================================
    // Constructor
    //=================================================

  function new(string name="axi_tx");
        super.new(name);
    endfunction

endclass

