class eth_sbd extends uvm_scoreboard;

   `uvm_component_utils(eth_sbd)
   `NEW_COMP

   // Analysis implementation
   uvm_analysis_imp #(eth_tx, eth_sbd) analysis_imp;

      // Build Phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      analysis_imp = new("analysis_imp", this);
   endfunction

     // Write Method
      function void write(eth_tx tx);

      `uvm_info(get_type_name(),
$sformatf("\n================================\nDestination MAC : %012h\nSource MAC : %012h\nEtherType : %04h\nPayload Size : %0d\nCRC : %08h\n================================",
tx.dst_mac,
tx.src_mac,
tx.ether_type,
tx.payload.size(),
tx.crc),
UVM_LOW)

		foreach(tx.payload[i])
         `uvm_info("PAYLOAD",
                   $sformatf("payload[%0d] = %02h",
                             i,
                             tx.payload[i]),
                   UVM_NONE)
	  

   endfunction

endclass

