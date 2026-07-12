
class eth_driver extends uvm_driver #(eth_tx);
	`uvm_component_utils(eth_driver)
	`NEW_COMP

//interface declaration
virtual eth_if vif;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual eth_if)::get(this,
										 "",
										 "vif"
										 ,vif))
	 `uvm_info("DRV","virtual interface retrive is failed",UVM_NONE)
endfunction

task run_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(req);
		drive_frame(req);
		seq_item_port.item_done();
	end
endtask

task drive_frame(eth_tx tx);
	drive_preamble();
	drive_sof();
	drive_dst_mac(tx);
	drive_src_mac(tx);
	drive_ether_type(tx);
	drive_payload(tx);
	drive_crc(tx);
	drive_idle();
endtask

task drive_byte(bit [7:0]byte_data , bit last_byte =0);
	@(vif.drv_cb);
	vif.drv_cb.valid <= 1'b1;
	vif.drv_cb.data  <= byte_data;
	vif.drv_cb.last <= last_byte;
	vif.drv_cb.error <= 1'b0;
endtask

//If we don't clear valid, it remains high forever, and the monitor will think more data is coming.
//So after the frame is complete, we need an idle cycle.

task drive_idle();
	@(vif.drv_cb);
	 vif.drv_cb.valid <= 1'b0;
   	 vif.drv_cb.data  <= '0;
   	 vif.drv_cb.last  <= 1'b0;
     vif.drv_cb.error <= 1'b0;
endtask

task drive_preamble();
	repeat(7)begin
		drive_byte(8'h55);
	end
endtask

task drive_sof();
	drive_byte(8'hD5);
endtask

task drive_dst_mac(eth_tx tx);
	drive_byte(tx.dst_mac[47:40]);
	drive_byte(tx.dst_mac[39:32]);
	drive_byte(tx.dst_mac[31:24]);
	drive_byte(tx.dst_mac[23:16]);
	drive_byte(tx.dst_mac[15:8]);
	drive_byte(tx.dst_mac[7:0]);
endtask

task drive_src_mac(eth_tx tx);
   drive_byte(tx.src_mac[47:40]);
   drive_byte(tx.src_mac[39:32]);
   drive_byte(tx.src_mac[31:24]);
   drive_byte(tx.src_mac[23:16]);
   drive_byte(tx.src_mac[15:8]);
   drive_byte(tx.src_mac[7:0]);
endtask

task drive_ether_type(eth_tx tx);
   drive_byte(tx.ether_type[15:8]);
   drive_byte(tx.ether_type[7:0]);
endtask

task drive_payload(eth_tx tx);
	foreach(tx.payload[i])
		drive_byte(tx.payload[i]);
endtask

task drive_crc(eth_tx tx);
	drive_byte(tx.crc[31:24]);
	drive_byte(tx.crc[23:16]);
	drive_byte(tx.crc[15:8]);
	drive_byte(tx.crc[7:0],1'b1);//last byte of the frame = 1 to indicate that the end of the frame
endtask

endclass

