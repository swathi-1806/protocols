class axi_sequence extends uvm_sequence#(axi_tx);
	`uvm_object_utils(axi_sequence)
	`NEW_OBJ
/*	uvm_phase phase;
	task pre_body();
		phase=get_starting_phase();
		if(phase!=null)begin
			phase.raise_objection(this);
			phase.phase_done.set_drain_time(this,100);
		end
	endtask
	task post_body();
		if(phase!=null)begin
			phase.drop_objection(this);
		end
	endtask*/
endclass

//==================================================================================
class axi_1wr_seq extends axi_sequence;
`uvm_object_utils(axi_1wr_seq)
`NEW_OBJ

axi_tx tx;

task body();
	tx = axi_tx::type_id::create("tx");

	start_item(tx);
   `uvm_info("SEQ","Sequence Started",UVM_NONE)
		assert(tx.randomize() with {wr_rd ==1;
									addr =='h1000;
									id==0;
									burst_len==0;//1 beat
									burst_size ==3'd2; //4bytes/beat
									burst_type ==INCR;});
	//Fill one data beat
	//tx.dataQ.push_back(32'h12345678);
  	tx.dataQ[0] = 32'h12345678;

	//strobe value
	//tx.strbQ.push_back(4'hF);
    tx.strbQ[0]=4'hF;
 `uvm_info("SEQ","Before finish_item",UVM_NONE)

  finish_item(tx);
  `uvm_info("SEQ","Sequence Finished",UVM_NONE)
endtask
endclass
	
