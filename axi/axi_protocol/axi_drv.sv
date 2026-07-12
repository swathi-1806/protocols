//=========================================================
//axi_driver
//=========================================================
class axi_driver extends uvm_driver#(axi_tx);
	virtual axi_intf vif;
	`uvm_component_utils(axi_driver)
	`NEW_COMP

function void build_phase(uvm_phase phase);
    	super.build_phase(phase);

    	if(!uvm_config_db#(virtual axi_intf)::get(this,"","vif",vif))
      `uvm_fatal("VIF","Unable to get AXI interface")
endfunction
	
	task run_phase(uvm_phase phase);
  		vif.awvalid = 0;
   		vif.wvalid  = 0;
   		vif.bready  = 0;
   		vif.arvalid = 0;
   		vif.rready  = 0;	
		forever begin
           $display("%0t Driver waiting",$time);
			seq_item_port.get_next_item(req);
            $display("%0t Driver got item",$time);
			drive_tx(req);
			$display("----------------------->%0t:",$time);
			req.print();
           $display("%0t Driver done",$time);
			seq_item_port.item_done();
		end
	endtask

	task drive_tx(axi_tx tx);
      $display("Entered drive_tx at %0t", $time);
       $display("Initial arst = %b", vif.arst);
      wait(vif.arst==1);
   
      $display("Reset released at %0t", $time);
		vif.wr_rd=tx.wr_rd;
		if(vif.wr_rd==1)begin
			write_addr_phase(tx);
			write_data_phase(tx);
			write_resp_phase(tx);
		end
		else begin
			read_addr_phase(tx);
			read_data_phase(tx);
		end
	endtask

//NO CLOCKING BLOCKS

	task write_addr_phase(axi_tx tx);
      $display("Before first posedge %0t", $time);
			@(posedge vif.aclk);
       $display("After first posedge %0t", $time);
			vif.awid =tx.id;
			vif.awaddr =tx.addr;
			vif.awlen =tx.burst_len;
			vif.awsize =tx.burst_size;
			vif.awburst =tx.burst_type;
			vif.awvalid = 1;
      $display("Waiting for AWREADY...");
			wait(vif.awready==1);
      $display("Got AWREADY");
			@(posedge vif.aclk);
			vif.awvalid=0;
			vif.awid =0;
			vif.awaddr =0;
			vif.awlen =0;
			vif.awsize =0;
			vif.awburst =0;
	endtask
	task write_data_phase(axi_tx tx);
		for(int i=0;i<=tx.burst_len;i++)begin

		@(posedge vif.aclk);

			vif.wdata=tx.dataQ[i];

			//generation of wstrb based on burst size
			vif.wstrb=4'b1111;
			 //vif.wstrb  = (1 << (1 << tx.burst_size)) - 1;

			vif.wid=tx.id;
			vif.wlast=(i==tx.burst_len)? 1:0;
			vif.wvalid=1;
			wait(vif.wready==1);
		end
		@(posedge vif.aclk);
			vif.wvalid=0;
			vif.wid =0;
			vif.wdata =0;
			vif.wstrb =0;
			vif.wlast =0;
	endtask

task write_resp_phase(axi_tx tx);
    while(vif.bvalid==0)
        @(posedge vif.aclk);
    vif.bready = 1;
    @(posedge vif.aclk);
    vif.bready = 0;
endtask

task read_addr_phase(axi_tx tx);
		@(posedge vif.aclk);
			vif.arid =tx.id;
			vif.araddr =tx.addr;
			vif.arlen =tx.burst_len;
			vif.arsize =tx.burst_size;
			vif.arburst =tx.burst_type;
			vif.arvalid = 1;
			wait(vif.arready==1);
		@(posedge vif.aclk);
			vif.arvalid=0;
			vif.arid =0;
			vif.araddr =0;
			vif.arlen =0;
			vif.arsize =0;
			vif.arburst =0;
endtask

task read_data_phase(axi_tx tx);

    for(int i=0;i<=tx.burst_len;i++) begin
        while(vif.rvalid==0)
            @(posedge vif.aclk);
       			vif.rready = 1;
        		tx.dataQ.push_back(vif.rdata);
       		 @(posedge vif.aclk);
        		vif.rready = 0;
    end
endtask
endclass

