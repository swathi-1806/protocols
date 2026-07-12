class axi_env extends uvm_env;
`uvm_component_utils(axi_env)
`NEW_COMP

axi_magent magt_h;
axi_sagent sagt_h;
axi_sbd sbd_h;


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	magt_h = axi_magent::type_id::create("magt_h",this);
	sagt_h = axi_sagent::type_id::create("sagt_h",this);
	sbd_h  = axi_sbd::type_id::create("sbd_h",this);
endfunction

//TODO
function void connect_phase(uvm_phase phase);
      magt_h.mon_h.mon_ap_h.connect(sbd_h.analysis_export);		
endfunction

endclass
