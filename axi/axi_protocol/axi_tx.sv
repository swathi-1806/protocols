class axi_tx extends uvm_sequence_item;

   rand bit [`ADDR_WIDTH-1:0] addr;
   rand bit [`DATA_WIDTH-1:0] dataQ[$];
   rand bit [`DATA_WIDTH/8-1:0] strbQ[$];
   rand bit                    wr_rd;       // 1=write, 0=read
   rand bit [3:0]              id;
   rand bit [3:0]              burst_len;   // AXI LEN = beats-1
   rand burst_type_t           burst_type;
   rand bit [2:0]              burst_size;  // AXI SIZE
        bit [1:0]              resp;

   `uvm_object_utils_begin(axi_tx)
      `uvm_field_int		(addr,UVM_ALL_ON)
      `uvm_field_queue_int	(dataQ, UVM_ALL_ON)
      `uvm_field_queue_int	(strbQ, UVM_ALL_ON)
      `uvm_field_int	  	(wr_rd,UVM_ALL_ON)
      `uvm_field_int		(id,UVM_ALL_ON)
      `uvm_field_int		(burst_len,UVM_ALL_ON)
      `uvm_field_enum		(burst_type_t, burst_type, UVM_ALL_ON)
      `uvm_field_int		(burst_size,UVM_ALL_ON)
      `uvm_field_int		(resp,UVM_ALL_ON)
   `uvm_object_utils_end

   `NEW_OBJ

   // Number of beats = burst_len + 1
   constraint burst_len_c {
      dataQ.size() == burst_len + 1;
      strbQ.size() == burst_len + 1;
   }

   //limiting burst size [0-2]1 or 2 or 4 bytes per transfer
   constraint burst_size_c {
		burst_size inside {[0:2]}; //1,2,4 bytes
	}

   // Default values
   constraint soft_c {
      soft burst_type == INCR;
      soft burst_size == 2; // 4-byte transfer
   }

endclass

