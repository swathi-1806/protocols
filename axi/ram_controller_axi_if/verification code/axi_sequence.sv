<<<<<<< HEAD
class write_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(write_sequence)

    function new(string name = "write_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(10)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize() with
            {
                write == 1;
            });

            finish_item(tx);

        end

    endtask

endclass



class read_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(read_sequence)

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(10)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize() with
            {
                write == 0;
            });

            finish_item(tx);

        end

    endtask

endclass

class wr_rd_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(wr_rd_sequence)

    axi_tx wr_tx;
    axi_tx rd_tx;

    bit [31:0] addr;
    bit [31:0] data;

    function new(string name = "wr_rd_sequence");
        super.new(name);
    endfunction

    virtual task body();

        //------------------------------------------
        // Generate random address and data
        //------------------------------------------
        addr = $urandom_range(0,15);
        data = $urandom;

        `uvm_info("WR_RD_SEQ",
                  $sformatf("WRITE ADDR=%0d DATA=%0h", addr, data),
                  UVM_LOW)

        //------------------------------------------
        // WRITE TRANSACTION
        //------------------------------------------
        wr_tx = axi_tx::type_id::create("wr_tx");

        start_item(wr_tx);

        assert(wr_tx.randomize() with
        {
            write   == 1;

            awaddr  == local::addr;
            wdata   == local::data;

            awid    == 0;
            awlock  == 0;
            awcache == 0;
            awprot  == 0;

            wstrb   == 4'hF;
        });

        finish_item(wr_tx);

        //------------------------------------------
        // READ TRANSACTION
        //------------------------------------------

        `uvm_info("WR_RD_SEQ",
                  $sformatf("READ  ADDR=%0d", addr),
                  UVM_LOW)

        rd_tx = axi_tx::type_id::create("rd_tx");

        start_item(rd_tx);

        assert(rd_tx.randomize() with
        {
            write   == 0;

            araddr  == local::addr;

            arid    == 0;
            arlock  == 0;
            arcache == 0;
            arprot  == 0;
        });

        finish_item(rd_tx);

    endtask

endclass


class random_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(random_sequence)

    function new(string name = "random_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(20)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize());

            finish_item(tx);

        end

    endtask

endclass

=======
class write_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(write_sequence)

    function new(string name = "write_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(10)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize() with
            {
                write == 1;
            });

            finish_item(tx);

        end

    endtask

endclass



class read_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(read_sequence)

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(10)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize() with
            {
                write == 0;
            });

            finish_item(tx);

        end

    endtask

endclass

class wr_rd_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(wr_rd_sequence)

    axi_tx wr_tx;
    axi_tx rd_tx;

    bit [31:0] addr;
    bit [31:0] data;

    function new(string name = "wr_rd_sequence");
        super.new(name);
    endfunction

    virtual task body();

        //------------------------------------------
        // Generate random address and data
        //------------------------------------------
        addr = $urandom_range(0,15);
        data = $urandom;

        `uvm_info("WR_RD_SEQ",
                  $sformatf("WRITE ADDR=%0d DATA=%0h", addr, data),
                  UVM_LOW)

        //------------------------------------------
        // WRITE TRANSACTION
        //------------------------------------------
        wr_tx = axi_tx::type_id::create("wr_tx");

        start_item(wr_tx);

        assert(wr_tx.randomize() with
        {
            write   == 1;

            awaddr  == local::addr;
            wdata   == local::data;

            awid    == 0;
            awlock  == 0;
            awcache == 0;
            awprot  == 0;

            wstrb   == 4'hF;
        });

        finish_item(wr_tx);

        //------------------------------------------
        // READ TRANSACTION
        //------------------------------------------

        `uvm_info("WR_RD_SEQ",
                  $sformatf("READ  ADDR=%0d", addr),
                  UVM_LOW)

        rd_tx = axi_tx::type_id::create("rd_tx");

        start_item(rd_tx);

        assert(rd_tx.randomize() with
        {
            write   == 0;

            araddr  == local::addr;

            arid    == 0;
            arlock  == 0;
            arcache == 0;
            arprot  == 0;
        });

        finish_item(rd_tx);

    endtask

endclass


class random_sequence extends uvm_sequence #(axi_tx);

    `uvm_object_utils(random_sequence)

    function new(string name = "random_sequence");
        super.new(name);
    endfunction

    axi_tx tx;

    virtual task body();

        repeat(20)
        begin

            tx = axi_tx::type_id::create("tx");

            start_item(tx);

            assert(tx.randomize());

            finish_item(tx);

        end

    endtask

endclass

>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
