class axi_sbd extends uvm_scoreboard;

   `uvm_component_utils(axi_sbd)

   //----------------------------------------
   // Analysis Export
   //----------------------------------------
   uvm_analysis_imp #(axi_tx, axi_sbd) analysis_export;

   //----------------------------------------
   // Reference Memory
   //----------------------------------------
   bit [7:0] mem[*];

   `NEW_COMP

   //----------------------------------------
   // Build Phase
   //----------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      analysis_export =
         new("analysis_export", this);
   endfunction

   //----------------------------------------
   // Address Calculation
   //----------------------------------------
   function bit [`ADDR_WIDTH-1:0] next_addr
   (
      input bit [`ADDR_WIDTH-1:0] curr_addr,
      input bit [2:0]             size,
      input burst_type_t          burst,
      input bit [`ADDR_WIDTH-1:0] wrap_lower,
      input bit [`ADDR_WIDTH-1:0] wrap_upper
   );

      case(burst)

         FIXED:
            next_addr = curr_addr;

         INCR:
            next_addr = curr_addr + (1<<size);

         WRAP:
         begin
            next_addr = curr_addr + (1<<size);

            if(next_addr > wrap_upper)
               next_addr = wrap_lower;
         end

         default:
            next_addr = curr_addr;

      endcase

   endfunction

   //----------------------------------------
   // Write Function
   //----------------------------------------
   virtual function void write(axi_tx tx);

      bit [`ADDR_WIDTH-1:0] addr;

      bit [`ADDR_WIDTH-1:0] wrap_lower;
      bit [`ADDR_WIDTH-1:0] wrap_upper;

      bit [31:0] exp_data;

      addr = tx.addr;

      //--------------------------------------
      // WRAP boundary calculation
      //--------------------------------------
      if(tx.burst_type == WRAP) begin

         wrap_lower =
            tx.addr -
            (tx.addr %
            ((tx.burst_len+1)*(1<<tx.burst_size)));

         wrap_upper =
            wrap_lower +
            ((tx.burst_len+1)*(1<<tx.burst_size))
            - (1<<tx.burst_size);

      end

      //--------------------------------------
      // WRITE Transaction
      //--------------------------------------
      if(tx.wr_rd) begin

         foreach(tx.dataQ[i]) begin

            for(int b=0;b<(1<<tx.burst_size);b++) begin

               mem[addr+b]
                  = tx.dataQ[i][8*b +: 8];

            end

            addr = next_addr(
                     addr,
                     tx.burst_size,
                     tx.burst_type,
                     wrap_lower,
                     wrap_upper
                   );
         end

         `uvm_info("SBD",
                   "WRITE stored in reference memory",
                   UVM_LOW)

      end

      //--------------------------------------
      // READ Transaction
      //--------------------------------------
      else begin

         foreach(tx.dataQ[i]) begin

            exp_data = '0;

            for(int b=0;b<(1<<tx.burst_size);b++) begin

               exp_data[8*b +: 8]
                  = mem[addr+b];
            end

            if(exp_data !== tx.dataQ[i]) begin

               `uvm_error("AXI_SBD",
                  $sformatf(
                  "READ MISMATCH beat=%0d addr=%0h EXP=%0h ACT=%0h",
                  i,
                  addr,
                  exp_data,
                  tx.dataQ[i]))

            end
            else begin

               `uvm_info("AXI_SBD",
                  $sformatf(
                  "READ MATCH beat=%0d addr=%0h data=%0h",
                  i,
                  addr,
                  exp_data),
                  UVM_LOW)

            end

            addr = next_addr(
                     addr,
                     tx.burst_size,
                     tx.burst_type,
                     wrap_lower,
                     wrap_upper
                   );

         end

      end

   endfunction

endclass

