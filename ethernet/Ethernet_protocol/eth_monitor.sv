class eth_monitor extends uvm_monitor;
	`uvm_component_utils(eth_monitor)
	`NEW_COMP

//instantiate interface
virtual eth_if vif;

//analysis port
uvm_analysis_port #(eth_tx) mon_ap_h;

//for setting mac
bit [47:0] my_mac;

/*
function new(string name="eth_monitor",
                uvm_component parent);
      super.new(name,parent);
      mon_ap_h = new("mon_ap_h",this);
endfunction
*/

//retrieving virtual interface from uvm_config_db
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual eth_if)::get(this,
											 "",
											 "vif",
											 vif))
	`uvm_info("MON","virtual interface retrival is failed", UVM_NONE)

	 if(!uvm_config_db #(bit[47:0])::get(this,
                                       "",
                                       "my_mac",
                                       my_mac))
      `uvm_info("MON","MAC NOT FOUND",UVM_NONE)
   mon_ap_h = new("mon_ap_h",this);

endfunction

//functionality
task run_phase(uvm_phase phase);
	eth_tx tx;
	forever begin
		@(vif.mon_cb);
		if(vif.mon_cb.valid)begin
			tx=eth_tx::type_id::create("tx");
			collect_frame(tx);

			 // MAC Address Filtering
         if(tx.dst_mac == my_mac) begin
            `uvm_info(get_type_name(),"Frame Accepted",UVM_LOW)
            mon_ap_h.write(tx);
         end
         else begin
            `uvm_info(get_type_name(),
                      "Frame Dropped",
                      UVM_LOW)
         end
     end
   end
endtask

task collect_frame(eth_tx tx);
	byte frame_q[$];
	collect_preamble(tx);
	collect_sof(tx);
	collect_dst_mac(tx);
	collect_src_mac(tx);
	collect_ether_type(tx);
	collect_frame_data(frame_q);
	collect_payload(tx,frame_q);
	collect_crc(tx,frame_q);
endtask

task collect_preamble(eth_tx tx);
	repeat(7)begin
		tx.preamble = {tx.preamble[47:0],vif.mon_cb.data};
		@(vif.mon_cb);
	end
endtask

task collect_sof(eth_tx tx);
		tx.sof = vif.mon_cb.data;
		 @(vif.mon_cb);
endtask

task collect_dst_mac(eth_tx tx);
	repeat(6)begin
		tx.dst_mac = {tx.dst_mac[39:0],vif.mon_cb.data};
		 @(vif.mon_cb);
	end
endtask

task collect_src_mac(eth_tx tx);
	repeat(6)begin
		tx.src_mac = {tx.src_mac[39:0],vif.mon_cb.data};
		 @(vif.mon_cb);
	end
endtask

task collect_ether_type(eth_tx tx);
   tx.ether_type[15:8] = vif.mon_cb.data;
   @(vif.mon_cb);
   tx.ether_type[7:0] = vif.mon_cb.data;
   @(vif.mon_cb);
endtask

//below task collects all bytes after the ethertype
task collect_frame_data(ref byte frame_q[$]);
   frame_q.delete();
   forever begin
      frame_q.push_back(vif.mon_cb.data);
      if(vif.mon_cb.last)
         break;
      @(vif.mon_cb);
   end
endtask

//extracts the payload
task collect_payload(eth_tx tx, ref byte frame_q[$]);
   tx.payload = new[frame_q.size()-4];
   for(int i=0; i<frame_q.size()-4; i++)
      tx.payload[i] = frame_q[i];
endtask

//extracts the crc
task collect_crc(eth_tx tx, ref byte frame_q[$]);
   tx.crc = {
              frame_q[$-4],
              frame_q[$-3],
              frame_q[$-2],
              frame_q[$-1]
            };
endtask

endclass

