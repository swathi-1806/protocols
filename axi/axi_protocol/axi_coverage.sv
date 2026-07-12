class axi_coverage extends uvm_component;
axi_tx tx;
`uvm_component_utils(axi_coverage)

uvm_analysis_imp #(axi_tx,axi_coverage) analysis_export;

function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   analysis_export =new("analysis_export",this);
endfunction

	covergroup axi_cg;
		ADDR_CP : coverpoint tx.addr{
			option.auto_bin_max=8;
		}

		WR_RD_CP : coverpoint tx.wr_rd{
			bins WRITE = {1'b1};
			bins READ = {1'b0};
		}

		BURST_LEN_CP : coverpoint tx.burst_len{
			option.auto_bin_max=8;
		}

		BURST_SIZE_CP : coverpoint tx.burst_size{
			bins BYTE1_SIZE={3'b000};
			bins BYTE2_SIZE={3'b001};
			bins BYTE4_SIZE={3'b010};
			bins BYTE8_SIZE={3'b011};
			bins BYTE16_SIZE={3'b100};
			bins BYTE32_SIZE={3'b101};
			bins BYTE64_SIZE={3'b110};
			bins BYTE128_SIZE={3'b111};
		}

		BURST_TYPE_CP : coverpoint tx.burst_type{
			bins FIXED ={2'b00};
			bins INCRE ={2'b01};
			bins WRAP  ={2'b10};
			illegal_bins ILLEGAL ={2'b11};
		}

		ADDR_X_WR_RD_CP : cross ADDR_CP,WR_RD_CP;
		BURS_TYPE_X_WR_RD_CP : cross BURST_TYPE_CP,WR_RD_CP;
	endgroup

	function new(string name="",uvm_component parent=null);
			super.new(name,parent);
			axi_cg=new();
	endfunction

	virtual function void write(axi_tx t);
		tx=axi_tx::type_id::create("tx");
        tx.copy(t); //$cast(tx,t);
		axi_cg.sample();
	endfunction

endclass

