`timescale 1ns/1ps
  import uvm_pkg::*;
 
`include "uvm_macros.svh"

`include "common.sv"
`include "eth_tx.sv"
`include "eth_if.sv"
`include "eth_driver.sv"
`include "eth_monitor.sv"
`include "eth_sqr.sv"
`include "eth_magent.sv"
`include "eth_sagent.sv"
`include "eth_sbd.sv"
`include "eth_env.sv"
`include "eth_base_seq.sv"
`include "eth_base_test.sv"

module tb;

bit clk,rst;

// Clock Generation
   //-----------------------------------------
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

    // Reset Generation
   //-----------------------------------------
   initial begin
      rst = 1;
      #20;
      rst = 0;
   end

     // Interface Instance
   //-----------------------------------------
   eth_if vif(clk, rst);


initial begin
	uvm_config_db #(virtual eth_if)::set(null,
									 "*",
									 "vif",
									 vif);
end

initial begin
	run_test("eth_unicast_slave1_test");
end

endmodule

