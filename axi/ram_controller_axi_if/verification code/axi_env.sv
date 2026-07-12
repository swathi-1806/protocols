class axi_env extends uvm_env;

    `uvm_component_utils(axi_env)

    //--------------------------------------------------
    // Components
    //--------------------------------------------------

    axi_agent      agent;
    axi_scoreboard scb;

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name = "axi_env",
                 uvm_component parent);

        super.new(name, parent);

    endfunction

    //--------------------------------------------------
    // Build Phase
    //--------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        agent = axi_agent::type_id::create("agent", this);
        scb   = axi_scoreboard::type_id::create("scb", this);

    endfunction

    //--------------------------------------------------
    // Connect Phase
    //--------------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        agent.mon.ap.connect(scb.item_collected_export);

    endfunction

endclass

