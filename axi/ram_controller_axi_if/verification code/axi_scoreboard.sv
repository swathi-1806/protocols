class axi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(axi_scoreboard)

    //--------------------------------------------------
    // Analysis Import
    //--------------------------------------------------

  uvm_analysis_imp #(axi_tx, axi_scoreboard) item_collected_export;

    //--------------------------------------------------
    // Reference Memory
    //--------------------------------------------------

    bit [31:0] ref_mem [0:15];

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name = "axi_scoreboard",
                 uvm_component parent);

        super.new(name,parent);

        item_collected_export = new("item_collected_export", this);

    endfunction

    //--------------------------------------------------
    // Write Method
    //--------------------------------------------------

  virtual function void write(axi_tx tx);

        //--------------------------------------------------
        // Write Transaction
        //--------------------------------------------------

        if(tx.write)
        begin

            ref_mem[tx.awaddr[3:0]] = tx.wdata;

            `uvm_info("SCOREBOARD",
                      $sformatf("WRITE : ADDR = %0d DATA = %0h",
                                tx.awaddr[3:0],
                                tx.wdata),
                      UVM_LOW)

        end

        //--------------------------------------------------
        // Read Transaction
        //--------------------------------------------------

        else
        begin

            if(ref_mem[tx.araddr[3:0]] == tx.rdata)
            begin

                `uvm_info("SCOREBOARD",

                $sformatf("READ PASS : ADDR=%0d EXPECTED=%0h ACTUAL=%0h",

                tx.araddr[3:0],
                ref_mem[tx.araddr[3:0]],
                tx.rdata),

                UVM_LOW)

            end

            else
            begin

                `uvm_error("SCOREBOARD",

                $sformatf("READ FAIL : ADDR=%0d EXPECTED=%0h ACTUAL=%0h",

                tx.araddr[3:0],
                ref_mem[tx.araddr[3:0]],
                tx.rdata))

            end

        end

    endfunction

endclass

