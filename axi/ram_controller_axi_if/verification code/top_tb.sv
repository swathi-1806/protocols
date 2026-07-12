<<<<<<< HEAD
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

//----------------------------------------------
// RTL Files
//----------------------------------------------

`include "axi_if.sv"
`include "ram_if.sv"
`include "ram_controller.sv"
`include "ram_model.v"
`include "top.sv"

//----------------------------------------------
// UVM Files
//----------------------------------------------

`include "axi_tx.sv"
`include "axi_sequence.sv"
`include "axi_sequencer.sv"
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_agent.sv"
`include "axi_scoreboard.sv"
`include "axi_env.sv"
`include "axi_base_test.sv"

module tb_top;

    //------------------------------------------
    // Instantiate RTL Top
    //------------------------------------------

    top dut();

    //------------------------------------------
    // Pass Virtual Interface
    //------------------------------------------

    initial
    begin

        uvm_config_db #(virtual axi_if)::set(null,
                                             "*",
                                             "vif",
                                             dut.axi_vif);

      run_test("wr_rd_test");

    end
  
  initial begin
    #10000;
    `uvm_fatal("TIMEOUT","Simulation Timed Out");
end
  
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top);
end

endmodule

=======
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

//----------------------------------------------
// RTL Files
//----------------------------------------------

`include "axi_if.sv"
`include "ram_if.sv"
`include "ram_controller.sv"
`include "ram_model.v"
`include "top.sv"

//----------------------------------------------
// UVM Files
//----------------------------------------------

`include "axi_tx.sv"
`include "axi_sequence.sv"
`include "axi_sequencer.sv"
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_agent.sv"
`include "axi_scoreboard.sv"
`include "axi_env.sv"
`include "axi_base_test.sv"

module tb_top;

    //------------------------------------------
    // Instantiate RTL Top
    //------------------------------------------

    top dut();

    //------------------------------------------
    // Pass Virtual Interface
    //------------------------------------------

    initial
    begin

        uvm_config_db #(virtual axi_if)::set(null,
                                             "*",
                                             "vif",
                                             dut.axi_vif);

      run_test("wr_rd_test");

    end
  
  initial begin
    #10000;
    `uvm_fatal("TIMEOUT","Simulation Timed Out");
end
  
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top);
end

endmodule

>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
