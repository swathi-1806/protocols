class eth_sagent extends uvm_agent;
	`uvm_component_utils(eth_sagent);
	`NEW_COMP

//instantiate subclasses
eth_monitor smon_h;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	smon_h = eth_monitor::type_id::create("smon_h",this);
endfunction

endclass

