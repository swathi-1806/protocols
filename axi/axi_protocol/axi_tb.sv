//`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"


`include "axi_common.sv"
`include "axi_intf.sv"
`include "axi_tx.sv"

`include "axi_seq.sv"
`include "axi_drv.sv"
`include "axi_responder.sv"
`include "axi_sqr.sv"
`include "axi_monitor.sv"
`include "axi_coverage.sv"

`include "axi_magent.sv"
`include "axi_sagent.sv"

`include "axi_sbd.sv"
`include "axi_env.sv"

`include "axi_test.sv"

module tb;
	reg clk,rst;
	axi_intf vif(clk,rst);

	initial begin
   		clk = 0;
   		forever #5 clk = ~clk;
	end

	initial begin
  		 rst = 0;
   		#20;
   		rst = 1;
	end

	initial begin
   			uvm_config_db #(virtual axi_intf)::set(null,
      												"*",
      												"vif",
      												vif);
    end
  	
  	initial begin
   			run_test("axi_1wr_test");
	end

  	initial begin
  		$dumpfile("dump.vcd");
  		$dumpvars(0, tb);
	end

    
endmodule

