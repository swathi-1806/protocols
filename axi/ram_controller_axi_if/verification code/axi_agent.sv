<<<<<<< HEAD
class axi_agent extends uvm_agent;

    `uvm_component_utils(axi_agent)

    //----------------------------------------------------
    // Components
    //----------------------------------------------------

    axi_driver    drv;
    axi_monitor   mon;
    axi_sequencer seqr;

    //----------------------------------------------------
    // Constructor
    //----------------------------------------------------

    function new(string name = "axi_agent",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //----------------------------------------------------
    // Build Phase
    //----------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        drv  = axi_driver   ::type_id::create("drv", this);
        mon  = axi_monitor  ::type_id::create("mon", this);
        seqr = axi_sequencer::type_id::create("seqr", this);

    endfunction

    //----------------------------------------------------
    // Connect Phase
    //----------------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass

=======
class axi_agent extends uvm_agent;

    `uvm_component_utils(axi_agent)

    //----------------------------------------------------
    // Components
    //----------------------------------------------------

    axi_driver    drv;
    axi_monitor   mon;
    axi_sequencer seqr;

    //----------------------------------------------------
    // Constructor
    //----------------------------------------------------

    function new(string name = "axi_agent",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //----------------------------------------------------
    // Build Phase
    //----------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        drv  = axi_driver   ::type_id::create("drv", this);
        mon  = axi_monitor  ::type_id::create("mon", this);
        seqr = axi_sequencer::type_id::create("seqr", this);

    endfunction

    //----------------------------------------------------
    // Connect Phase
    //----------------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);

    endfunction

endclass

>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
