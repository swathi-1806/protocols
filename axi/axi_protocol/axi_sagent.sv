class axi_sagent extends uvm_agent;
axi_responder rsp_h;
axi_monitor mon_h;

`uvm_component_utils(axi_sagent)
`NEW_COMP

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	rsp_h = axi_responder::type_id::create("rsp_h",this);
	mon_h = axi_monitor::type_id::create("mon_h",this);
endfunction

endclass

