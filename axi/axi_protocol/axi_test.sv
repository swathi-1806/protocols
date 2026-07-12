class axi_test extends uvm_test;
  `uvm_component_utils(axi_test)
   axi_env env_h;
   `NEW_COMP

// Build_phase
function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env_h = axi_env::type_id::create("env_h",this);
endfunction
  
  //end_of_elaboration_phase
function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

endclass

//=================================================================
class axi_1wr_test extends axi_test;
`uvm_component_utils(axi_1wr_test)
`NEW_COMP

   task run_phase(uvm_phase phase);
      axi_1wr_seq seq_h;
     phase.raise_objection(this);//already done in seq pre and post body();
      seq_h = axi_1wr_seq::type_id::create("seq_h");
      seq_h.start(env_h.magt_h.sqr_h);
      phase.drop_objection(this);
   endtask
endclass
//=================================================================


