class axi_driver extends uvm_driver #(axi_tx);

    `uvm_component_utils(axi_driver)

    // Virtual Interface
    virtual axi_if axi_vif;

    // Transaction Handle

    axi_tx tx;

    // Constructor

    function new(string name = "axi_driver",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    // Build Phase

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(virtual axi_if)::get(this,
                                                 "",
                                                 "vif",
                                                 axi_vif))
        begin
            `uvm_fatal("DRIVER","Unable to get Virtual Interface")
        end

    endfunction

    //--------------------------------------------------
    // Run Phase
    //--------------------------------------------------

    task run_phase(uvm_phase phase);
		reset_signals();
        wait(axi_vif.arst);
      
        forever begin

            seq_item_port.get_next_item(tx);

            if(tx.write)
                drive_write();

            else
                drive_read();

            seq_item_port.item_done();

        end

    endtask

    //--------------------------------------------------
    // Write Task
    //--------------------------------------------------

    task drive_write();

        //-----------------------------------------
        // Write Address Channel
        //-----------------------------------------

        @(posedge axi_vif.aclk);

        axi_vif.awid     <= tx.awid;
        axi_vif.awaddr   <= tx.awaddr;
        axi_vif.awlen    <= tx.awlen;
        axi_vif.awsize   <= tx.awsize;
        axi_vif.awburst  <= tx.awburst;
        axi_vif.awlock   <= tx.awlock;
        axi_vif.awcache  <= tx.awcache;
        axi_vif.awprot   <= tx.awprot;

        axi_vif.awvalid  <= 1'b1;

        wait(axi_vif.awready);

        @(posedge axi_vif.aclk);

        axi_vif.awvalid <= 1'b0;

        //-----------------------------------------
        // Write Data Channel
        //-----------------------------------------

        axi_vif.wdata   <= tx.wdata;
        axi_vif.wstrb   <= tx.wstrb;
        axi_vif.wlast   <= tx.wlast;

        axi_vif.wvalid  <= 1'b1;

        wait(axi_vif.wready);

        @(posedge axi_vif.aclk);

        axi_vif.wvalid <= 1'b0;

        //-----------------------------------------
        // Write Response
        //-----------------------------------------

        axi_vif.bready <= 1'b1;

        wait(axi_vif.bvalid);

        tx.bresp = axi_vif.bresp;

        @(posedge axi_vif.aclk);

        axi_vif.bready <= 1'b0;

    endtask

	    //--------------------------------------------------
    // Read Task
    //--------------------------------------------------

    task drive_read();

        //-----------------------------------------
        // Read Address Channel
        //-----------------------------------------

        @(posedge axi_vif.aclk);

        axi_vif.arid     <= tx.arid;
        axi_vif.araddr   <= tx.araddr;
        axi_vif.arlen    <= tx.arlen;
        axi_vif.arsize   <= tx.arsize;
        axi_vif.arburst  <= tx.arburst;
        axi_vif.arlock   <= tx.arlock;
        axi_vif.arcache  <= tx.arcache;
        axi_vif.arprot   <= tx.arprot;

        axi_vif.arvalid  <= 1'b1;

        wait(axi_vif.arready);

        @(posedge axi_vif.aclk);

        axi_vif.arvalid <= 1'b0;

        //-----------------------------------------
        // Read Data Channel
        //-----------------------------------------

        axi_vif.rready <= 1'b1;

        wait(axi_vif.rvalid);

        tx.rdata = axi_vif.rdata;
        tx.rresp = axi_vif.rresp;

        @(posedge axi_vif.aclk);

        axi_vif.rready <= 1'b0;

    endtask

    //--------------------------------------------------
    // Reset Driver Outputs
    //--------------------------------------------------

    task reset_signals();

        axi_vif.awvalid <= 0;
        axi_vif.wvalid  <= 0;
        axi_vif.bready  <= 0;

        axi_vif.arvalid <= 0;
        axi_vif.rready  <= 0;

        axi_vif.awid    <= '0;
        axi_vif.awaddr  <= '0;
        axi_vif.awlen   <= '0;
        axi_vif.awsize  <= '0;
        axi_vif.awburst <= '0;
        axi_vif.awlock  <= '0;
        axi_vif.awcache <= '0;
        axi_vif.awprot  <= '0;

        axi_vif.wdata   <= '0;
        axi_vif.wstrb   <= '0;
        axi_vif.wlast   <= '0;

        axi_vif.arid    <= '0;
        axi_vif.araddr  <= '0;
        axi_vif.arlen   <= '0;
        axi_vif.arsize  <= '0;
        axi_vif.arburst <= '0;
        axi_vif.arlock  <= '0;
        axi_vif.arcache <= '0;
        axi_vif.arprot  <= '0;

    endtask

endclass

