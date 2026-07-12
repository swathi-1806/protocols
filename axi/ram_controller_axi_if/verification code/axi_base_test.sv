
//==========================================================
//mem_base_test
//==========================================================
class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    //--------------------------------------------------
    // Environment
    //--------------------------------------------------

    axi_env env;

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name = "base_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //--------------------------------------------------
    // Build Phase
    //--------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = axi_env::type_id::create("env",this);

    endfunction

endclass

class write_test extends base_test;

    `uvm_component_utils(write_test)

    write_sequence seq;

    function new(string name="write_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = write_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class read_test extends base_test;

    `uvm_component_utils(read_test)

    read_sequence seq;

    function new(string name="read_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = read_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class wr_rd_test extends base_test;

    `uvm_component_utils(wr_rd_test)

    wr_rd_sequence seq;

    function new(string name = "wr_rd_test",
                 uvm_component parent);

        super.new(name, parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = wr_rd_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class random_test extends base_test;

    `uvm_component_utils(random_test)

    random_sequence seq;

    function new(string name="random_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = random_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass


=======
class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    //--------------------------------------------------
    // Environment
    //--------------------------------------------------

    axi_env env;

    //--------------------------------------------------
    // Constructor
    //--------------------------------------------------

    function new(string name = "base_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //--------------------------------------------------
    // Build Phase
    //--------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = axi_env::type_id::create("env",this);

    endfunction

endclass

class write_test extends base_test;

    `uvm_component_utils(write_test)

    write_sequence seq;

    function new(string name="write_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = write_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class read_test extends base_test;

    `uvm_component_utils(read_test)

    read_sequence seq;

    function new(string name="read_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = read_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class wr_rd_test extends base_test;

    `uvm_component_utils(wr_rd_test)

    wr_rd_sequence seq;

    function new(string name = "wr_rd_test",
                 uvm_component parent);

        super.new(name, parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = wr_rd_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass

class random_test extends base_test;

    `uvm_component_utils(random_test)

    random_sequence seq;

    function new(string name="random_test",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = random_sequence::type_id::create("seq");

        seq.start(env.agent.seqr);

        phase.drop_objection(this);

    endtask

endclass


>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
