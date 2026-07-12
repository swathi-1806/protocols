interface eth_if (input logic clk,input logic rst);
	
	//byte stream
	logic        valid;

	//The width of the data signal in your interface determines which physical Ethernet interface you are modeling.
	// Data width represents the physical Ethernet interface.
// 8-bit : GMII
// 4-bit : MII
// 2-bit : RMII
// 1-bit : Serial Interface
	logic [7:0]  data;//GMII

	logic        last;
	logic        error;

	// Driver clocking block
   clocking drv_cb @(posedge clk);
      default input #1 output #0;
      output valid;
      output data;
      output last;
      output error;
   endclocking

   // Monitor clocking block
   clocking mon_cb @(posedge clk);
      default input #1;
      input valid;
      input data;
      input last;
      input error;
   endclocking

endinterface

