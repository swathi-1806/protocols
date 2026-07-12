class eth_magent extends uvm_agent;
	`uvm_component_utils(eth_magent);
	`NEW_COMP

//instantiate subclasses
eth_driver mdrv_h;
eth_sqr    msqr_h;
eth_monitor mmon_h;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	mdrv_h = eth_driver::type_id::create("mdrv_h",this);
	msqr_h = eth_sqr::type_id::create("msqr_h",this);
	mmon_h = eth_monitor::type_id::create("mmon_h",this);
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	mdrv_h.seq_item_port.connect(msqr_h.seq_item_export);
endfunction

endclass

