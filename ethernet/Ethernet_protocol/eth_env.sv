class eth_env extends uvm_env;
	`uvm_component_utils(eth_env)
	`NEW_COMP

//instantiate subclass
eth_magent magt_h;
eth_sagent sagt_h_1;
eth_sagent sagt_h_2;
eth_sbd  sbd_h;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	magt_h = eth_magent::type_id::create("magt_h",this);
	sagt_h_1 = eth_sagent::type_id::create("sagt_h_1",this);
	sagt_h_2 = eth_sagent::type_id::create("sagt_h_2",this);
	sbd_h  = eth_sbd::type_id::create("sbd_h",this);


//setting slave-1 mac
uvm_config_db #(bit[47:0])::set(this,
								"sagt_h_1.smon_h",
								"my_mac",
								48'hAAAAAAAAAAAA);
//setting slave-2 mac
uvm_config_db #(bit[47:0])::set(this,
								"sagt_h_2.smon_h",
								"my_mac",
								48'hBBBBBBBBBBBB);

endfunction


function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	sagt_h_1.smon_h.mon_ap_h.connect(sbd_h.analysis_imp);
	sagt_h_2.smon_h.mon_ap_h.connect(sbd_h.analysis_imp);
endfunction

endclass

