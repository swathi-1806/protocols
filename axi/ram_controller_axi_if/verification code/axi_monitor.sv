class axi_monitor extends uvm_monitor;

    `uvm_component_utils(axi_monitor)

    //--------------------------------------------------
    // Virtual Interface
    //--------------------------------------------------

    virtual axi_if axi_vif;

    //--------------------------------------------------
    // Analysis Port
    //--------------------------------------------------

  uvm_analysis_port #(axi_tx) ap;

    //--------------------------------------------------
    // Transaction Handle
    //--------------------------------------------------

    axi_tx tx;

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name = "axi_monitor",
                 uvm_component parent);

        super.new(name,parent);

        ap = new("ap",this);

    endfunction

    //--------------------------------------------------
    // Build Phase
    //--------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(virtual axi_if)::get(this,
                                                "",
                                                "vif",
                                                axi_vif))
        begin
            `uvm_fatal("MONITOR","Cannot get virtual interface")
        end

    endfunction

    //--------------------------------------------------
    // Run Phase
    //--------------------------------------------------

    task run_phase(uvm_phase phase);

        forever
        begin

            @(posedge axi_vif.aclk);

            //--------------------------------------
            // Write Transaction
            //--------------------------------------

            if(axi_vif.awvalid && axi_vif.awready)
            begin

                tx = axi_tx::type_id::create("tx");
                tx.write   = 1;
                tx.awid    = axi_vif.awid;
                tx.awaddr  = axi_vif.awaddr;
                tx.awlen   = axi_vif.awlen;
                tx.awsize  = axi_vif.awsize;
                tx.awburst = axi_vif.awburst;

                //----------------------------------

                wait(axi_vif.wvalid && axi_vif.wready);

                tx.wdata = axi_vif.wdata;
                tx.wstrb = axi_vif.wstrb;
                tx.wlast = axi_vif.wlast;

                //----------------------------------

                wait(axi_vif.bvalid);

                tx.bresp = axi_vif.bresp;

                ap.write(tx);

            end

            //--------------------------------------
            // Read Transaction
            //--------------------------------------

            if(axi_vif.arvalid && axi_vif.arready)
            begin

                tx = axi_tx::type_id::create("tx");

                tx.write   = 0;
                tx.arid    = axi_vif.arid;
                tx.araddr  = axi_vif.araddr;
                tx.arlen   = axi_vif.arlen;
                tx.arsize  = axi_vif.arsize;
                tx.arburst = axi_vif.arburst;

                //----------------------------------

                wait(axi_vif.rvalid);

                tx.rdata = axi_vif.rdata;
                tx.rresp = axi_vif.rresp;

                ap.write(tx);

            end

        end

    endtask

endclass

