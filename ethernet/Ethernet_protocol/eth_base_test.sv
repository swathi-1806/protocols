class eth_base_test extends uvm_test;

   `uvm_component_utils(eth_base_test)
   `NEW_COMP

   // Environment
   eth_env env_h;

   //-----------------------------------------
   // Build Phase
   //-----------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env_h = eth_env::type_id::create("env_h", this);
   endfunction

endclass

class eth_unicast_slave1_test extends eth_base_test;

   `uvm_component_utils(eth_unicast_slave1_test)
   `NEW_COMP

   eth_unicast_slave1_seq seq_h;

   //-----------------------------------------
   // Run Phase
   //-----------------------------------------
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq_h = eth_unicast_slave1_seq::type_id::create("seq_h");
     seq_h.start(env_h.magt_h.msqr_h);
      phase.drop_objection(this);
   endtask

endclass

class eth_unicast_slave2_test extends eth_base_test;

   `uvm_component_utils(eth_unicast_slave2_test)
   `NEW_COMP

   eth_unicast_slave2_seq seq_h;

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq_h = eth_unicast_slave2_seq::type_id::create("seq_h");
     seq_h.start(env_h.magt_h.msqr_h);
      phase.drop_objection(this);
   endtask

endclass

