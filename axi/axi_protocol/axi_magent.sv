class axi_magent extends uvm_agent;
`uvm_component_utils(axi_magent)
`NEW_COMP

axi_driver drv_h;
axi_monitor mon_h;
axi_coverage cov_h;
axi_sqr sqr_h;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	drv_h = axi_driver::type_id::create("drv_h",this);
	mon_h = axi_monitor::type_id::create("mon_h",this);
	cov_h = axi_coverage::type_id::create("cov_h",this);
	sqr_h = axi_sqr::type_id::create("sqr_h",this);
endfunction

function void connect_phase(uvm_phase phase);
	drv_h.seq_item_port.connect(sqr_h.seq_item_export);
	mon_h.mon_ap_h.connect(cov_h.analysis_export);
endfunction

endclass

