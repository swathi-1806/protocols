class axi_monitor extends uvm_monitor;
`uvm_component_utils(axi_monitor)
`NEW_COMP

//interface declaration
virtual axi_intf vif;

//analysis port
 uvm_analysis_port #(axi_tx) mon_ap_h;
 
//interface handle
 function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon_ap_h = new("mon_ap_h", this);

      if(!uvm_config_db#(virtual axi_intf)::get(this,"","vif",vif))
         `uvm_fatal("VIF","Unable to get AXI interface")
   endfunction

   //--------------------------------------------------
   // Run Phase
   //--------------------------------------------------
   task run_phase(uvm_phase phase);

      axi_tx tx;

      forever begin

         @(posedge vif.aclk);

         //------------------------------------------
         // WRITE TRANSACTION
         //------------------------------------------
         if(vif.awvalid && vif.awready) begin

            tx = axi_tx::type_id::create("tx");

            tx.wr_rd      = 1;
            tx.id         = vif.awid;
            tx.addr       = vif.awaddr;
            tx.burst_len  = vif.awlen;
            tx.burst_size = vif.awsize;
            tx.burst_type = burst_type_t'(vif.awburst);

            tx.dataQ.delete();
            tx.strbQ.delete();

            //--------------------------------------
            // Capture W channel
            //--------------------------------------
            do begin

               @(posedge vif.aclk);
            

               if(vif.wvalid && vif.wready) begin
                  tx.dataQ.push_back(vif.wdata);
                  tx.strbQ.push_back(vif.wstrb);
               end
            end
            
            while(!(vif.wvalid && vif.wready && vif.wlast));

            //--------------------------------------
            // Capture B channel
            //--------------------------------------
           while(!(vif.bvalid && vif.bready));
               @(posedge vif.aclk);

            tx.resp = vif.bresp;

            mon_ap_h.write(tx);

            `uvm_info(get_type_name(),
                     "WRITE transaction captured",
                     UVM_LOW)

            tx.print();

         end

         //------------------------------------------
         // READ TRANSACTION
         //------------------------------------------
         if(vif.arvalid && vif.arready) begin

            tx = axi_tx::type_id::create("tx");

            tx.wr_rd      = 0;
            tx.id         = vif.arid;
            tx.addr       = vif.araddr;
            tx.burst_len  = vif.arlen;
            tx.burst_size = vif.arsize;
            tx.burst_type = burst_type_t'(vif.arburst);

            tx.dataQ.delete();

            //--------------------------------------
            // Capture R channel
            //--------------------------------------
            do begin

               @(posedge vif.aclk);

               if(vif.rvalid && vif.rready) begin
                  tx.dataQ.push_back(vif.rdata);
                  tx.resp = vif.rresp;
               end

            end
            while(!(vif.rvalid && vif.rready && vif.rlast));

            mon_ap_h.write(tx);

            `uvm_info(get_type_name(),
                     "READ transaction captured",
                     UVM_LOW)

            tx.print();

         end

      end

   endtask

endclass


