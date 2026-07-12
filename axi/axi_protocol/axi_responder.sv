//axi_responder
//===================================================================
class axi_responder extends uvm_component;
	bit [7:0] mem[*];

	bit [`ADDR_WIDTH-1:0]awaddr_t;
	bit [3:0]awlen_t;
	bit [2:0]awsize_t;
	bit [3:0]awid_t;
	bit [1:0]awburst_t;

	bit [`ADDR_WIDTH-1:0]araddr_t;
	bit [3:0]arlen_t;
	bit [2:0]arsize_t;
	bit [3:0]arid_t;
	bit [1:0]arburst_t;

	bit [31:0] temp_rdata;

  	// Write wrap boundary
	bit [`ADDR_WIDTH-1:0] aw_wrap_lower_addr;
	bit [`ADDR_WIDTH-1:0] aw_wrap_upper_addr;

	// Read wrap boundary
	bit [`ADDR_WIDTH-1:0] ar_wrap_lower_addr;
	bit [`ADDR_WIDTH-1:0] ar_wrap_upper_addr;

	virtual axi_intf vif;

	`uvm_component_utils(axi_responder)
	`NEW_COMP

	function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if(!uvm_config_db#(virtual axi_intf)::get(this,"","vif",vif))
         `uvm_fatal("VIF","Unable to get AXI interface")
   endfunction

//----------------------------------------------------
   // Address Calculation
   //----------------------------------------------------

   function bit [`ADDR_WIDTH-1:0] next_addr
   (
      input bit [`ADDR_WIDTH-1:0] curr_addr,
      input bit [2:0]             size,
      input burst_type_t          burst,
      input bit [`ADDR_WIDTH-1:0] wrap_lower,
      input bit [`ADDR_WIDTH-1:0] wrap_upper
   );

     // bit [`ADDR_WIDTH-1:0] addr;

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

//----------------------------------------------------
// RUN
//----------------------------------------------------

task run_phase(uvm_phase phase);
      forever begin
         @(posedge vif.aclk);

//write_addr
			if(vif.awvalid==1)begin
				vif.awready<=1;

				awaddr_t	=  vif.awaddr;
				awlen_t		=	vif.awlen;
				awsize_t	=	vif.awsize;
				awburst_t	=	vif.awburst;
				awid_t 		=	vif.awid;

			if(awburst_t == WRAP) begin

            aw_wrap_lower_addr =
               awaddr_t -(awaddr_t % ((awlen_t+1)*(1<<awsize_t)));

            aw_wrap_upper_addr =
               aw_wrap_lower_addr +((awlen_t+1)*(1<<awsize_t))- (1<<awsize_t);

         end

      end
      else
         vif.awready <= 0;

//read_addr
			if(vif.arvalid==1)begin
				vif.arready<=1;
				
				araddr_t=vif.araddr;
				arlen_t=vif.arlen;
				arsize_t=vif.arsize;
				arburst_t=vif.arburst;
				arid_t = vif.arid;

				if(arburst_t == WRAP) begin

   				ar_wrap_lower_addr =araddr_t - (araddr_t % ((arlen_t+1)*(1<<arsize_t)));

   				ar_wrap_upper_addr = ar_wrap_lower_addr +((arlen_t+1)*(1<<arsize_t)) - (1<<arsize_t);

				end
				fork
				read_data(arid_t,
						  araddr_t,
						  arlen_t);
				join_none
			end
			else vif.arready<=0;	
//write_data
			if(vif.wvalid==1)begin
				vif.wready<=1;

				//mem[awaddr_t]=vif.wdata[7:0];
				//mem[awaddr_t+1]=vif.wdata[15:8];
				//mem[awaddr_t+2]=vif.wdata[23:16];
				//mem[awaddr_t+3]=vif.wdata[31:24];
				
				for(int b=0; b<(1<<awsize_t); b++)
  				mem[awaddr_t+b] = vif.wdata[8*b +: 8];//variable[start_bit +: width]
		
		awaddr_t = next_addr(
              				awaddr_t,
              				awsize_t,
              				burst_type_t'(awburst_t), 
							aw_wrap_lower_addr,
              				aw_wrap_upper_addr);
              

			if(vif.wlast==1)begin
					fork
					//	write_resp(vif.wid);
					 write_resp(awid_t);
					join_none
            
			end
		end
			else vif.wready<=0;
	end
endtask

//============================================================	
//write_resp
//============================================================	
	task write_resp(bit [3:0]id);
		@(posedge vif.aclk);
		vif.bid<=id;
		vif.bresp<=2'b00;
		vif.bvalid<=1;
		wait(vif.bready==1); 
		@(posedge vif.aclk);
		vif.bid<=0;
		vif.bresp<=0;
		vif.bvalid<=0;
	endtask
//============================================================	
//read_data
//============================================================	
	task read_data(bit[3:0]id,
				   bit[31:0]addr, 
				   bit[3:0]burst_len);

		for(int i=0;i<=burst_len;i++)begin
			@(posedge vif.aclk);

			 // Clear previous data
       			 temp_rdata = '0;
					//vif.rdata<={mem[araddr_t+3],
					//	mem[araddr_t+2],
					//	mem[araddr_t+1],
					//	mem[araddr_t]
					//	};

			// Read bytes based on ARSIZE
      		for(int b=0; b<(1<<arsize_t); b++)
  				 temp_rdata[8*b +: 8] = mem[araddr_t+b];

			vif.rdata <= temp_rdata;

			vif.rid<=id;
			vif.rresp<=2'b00;
			vif.rlast<=(i==burst_len)? 1:0;
			vif.rvalid<=1;
			wait(vif.rready==1);
			
			// Calculate next address for FIXED/INCR/WRAP
			araddr_t = next_addr(araddr_t,
              					arsize_t,
             					 burst_type_t'(arburst_t),
								 ar_wrap_lower_addr,
              					ar_wrap_upper_addr);
			end

		@(posedge vif.aclk);

		vif.rdata<=0;
		vif.rid<=0;
		vif.rresp<=0;
		vif.rlast<= 0;
		vif.rvalid<=0;
	endtask
endclass


