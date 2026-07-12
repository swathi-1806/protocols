class eth_base_seq extends uvm_sequence #(eth_tx);
	`uvm_object_utils(eth_base_seq)
	`NEW_OBJ

	task pre_body();
      super.pre_body();
   endtask

   task post_body();
      super.post_body();
   endtask
endclass

class eth_unicast_slave1_seq extends eth_base_seq;
	`uvm_object_utils(eth_unicast_slave1_seq);
	`NEW_OBJ

	task body();
		//repeat(5)begin
			req = eth_tx::type_id::create("req");
			start_item(req);
				assert(req.randomize() with 
									{dst_mac == 48'hAAAAAAAAAAAA;
									src_mac == 48'h111111111111;
									ether_type == 16'h0800;
                                     
                                     payload.size() == 50;
						});
			finish_item(req);
		//end
	endtask

endclass

class eth_unicast_slave2_seq extends eth_base_seq;
	`uvm_object_utils(eth_unicast_slave2_seq);
	`NEW_OBJ

	task body();
		repeat(5)begin
			req = eth_tx::type_id::create("req");
			start_item(req);
				assert(req.randomize() with 
									{dst_mac == 48'hBBBBBBBBBBBB;
									src_mac == 48'h111111111111;
									ether_type == 16'h0800;
						});
			finish_item(req);
		end
	endtask

endclass
	


