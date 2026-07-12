class eth_tx extends uvm_sequence_item;

	 	 bit [55:0]preamble;
  		 bit [7:0] sof;

	rand bit [47:0] dst_mac;
	rand bit [47:0] src_mac;
	rand bit [15:0] ether_type;
	rand byte payload[];//dynamic array

	     bit [31:0]crc;

	//factory registration + field registration
	`uvm_object_utils_begin(eth_tx)
		`uvm_field_int(preamble , UVM_ALL_ON)
  `uvm_field_int(sof , UVM_ALL_ON)
		`uvm_field_int(dst_mac , UVM_ALL_ON)
		`uvm_field_int(src_mac , UVM_ALL_ON)
		`uvm_field_int(ether_type , UVM_ALL_ON)
		`uvm_field_array_int(payload , UVM_ALL_ON)
		`uvm_field_int(crc , UVM_ALL_ON)
	`uvm_object_utils_end
  
	`NEW_OBJ 

constraint payload_size_c {
  payload.size() inside {[46:1500]};
}

//Why post_randomize()? :- Because after randomization finishes, we assign the fixed values.
function void post_randomize();
   preamble = 56'h55555555555555;//010101.......
   sof = 8'hD5;//11010101
   crc = 32'h0;
endfunction

endclass

