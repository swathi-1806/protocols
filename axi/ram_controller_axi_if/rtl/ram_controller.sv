<<<<<<< HEAD
module ram_controller(

input logic aclk,
input logic arst,

//=====================================================
// Write Address Channel
//=====================================================
input  logic [3:0]  awid,
input  logic [31:0] awaddr,
input  logic [3:0]  awlen,
input  logic [2:0]  awsize,
input  logic [1:0]  awburst,
input  logic        awlock,
input  logic [3:0]  awcache,
input  logic [2:0]  awprot,
input  logic        awvalid,
output logic        awready,

//=====================================================
// Write Data Channel
//=====================================================
input  logic [31:0] wdata,
input  logic [3:0]  wstrb,
input  logic        wlast,
input  logic        wvalid,
output logic        wready,

//=====================================================
// Write Response Channel
//=====================================================
output logic [3:0]  bid,
output logic [1:0]  bresp,
output logic        bvalid,
input  logic        bready,

//=====================================================
// Read Address Channel
//=====================================================
input  logic [3:0]  arid,
input  logic [31:0] araddr,
input  logic [3:0]  arlen,
input  logic [2:0]  arsize,
input  logic [1:0]  arburst,
input  logic        arlock,
input  logic [3:0]  arcache,
input  logic [2:0]  arprot,
input  logic        arvalid,
output logic        arready,

//=====================================================
// Read Data Channel
//=====================================================
output logic [3:0]  rid,
output logic [31:0] rdata,
output logic [1:0]  rresp,
output logic        rlast,
output logic        rvalid,
input  logic        rready,

//=====================================================
// RAM Interface
//=====================================================
output logic        wr_rd,
output logic [31:0] ram_addr,
output logic [31:0] ram_wdata,
input  logic [31:0] ram_rdata

);

//=====================================================
// Internal Registers
//=====================================================

logic [31:0] write_addr_reg;
logic [31:0] read_addr_reg;

logic [31:0] write_data_reg;

logic [3:0] write_id_reg;
logic [3:0] read_id_reg;

logic [3:0] write_len_reg;
logic [3:0] read_len_reg;


//=====================================================
// Write FSM
//=====================================================

typedef enum logic [1:0]
{
    WR_ADDR_PHASE,
    WR_DATA_PHASE,
    WR_RESPONSE_PHASE
} wr_state_t;

wr_state_t wr_state;


//=====================================================
// Read FSM
//=====================================================

typedef enum logic [1:0]
{
    RD_ADDR_PHASE,
  	RD_WAIT_PHASE,
    RD_DATA_PHASE
} rd_state_t;

rd_state_t rd_state;


//=====================================================
// Sequential Logic
//=====================================================

always_ff @(posedge aclk or negedge arst)
begin

    if(!arst)
    begin

        //-------------------------
        // Reset States
        //-------------------------

        wr_state <= WR_ADDR_PHASE;
        rd_state <= RD_ADDR_PHASE;

        //-------------------------
        // Internal Registers
        //-------------------------

        write_addr_reg <= '0;
        read_addr_reg  <= '0;

        write_data_reg <= '0;

        write_id_reg <= '0;
        read_id_reg  <= '0;

        write_len_reg <= '0;
        read_len_reg  <= '0;

    end

    else
    begin

        //-------------------------------------
        // WRITE FSM
        //-------------------------------------

        case(wr_state)

            //---------------------------------
            // Address Phase
            //---------------------------------

            WR_ADDR_PHASE:
            begin

                if(awvalid && awready)
                begin

                    write_addr_reg <= awaddr;
                    write_id_reg   <= awid;
                    write_len_reg  <= awlen;

                    wr_state <= WR_DATA_PHASE;

                end

            end


            //---------------------------------
            // Data Phase
            //---------------------------------

            WR_DATA_PHASE:
            begin

                if(wvalid && wready && wlast)
                begin

                    write_data_reg <= wdata;

                    wr_state <= WR_RESPONSE_PHASE;

                end

            end


            //---------------------------------
            // Response Phase
            //---------------------------------

            WR_RESPONSE_PHASE:
            begin

                if(bvalid && bready)

                    wr_state <= WR_ADDR_PHASE;

            end

        endcase


        //-------------------------------------
        // READ FSM
        //-------------------------------------

        case(rd_state)

            //---------------------------------
            // Address Phase
            //---------------------------------

            RD_ADDR_PHASE:
            begin

                if(arvalid && arready)
                begin

                    read_addr_reg <= araddr;
                    read_id_reg   <= arid;
                    read_len_reg  <= arlen;

                    rd_state <= RD_WAIT_PHASE;

                end

            end

 			//---------------------------------
    		// Wait for RAM
    		//---------------------------------
    		RD_WAIT_PHASE:
    			begin
        			rd_state <= RD_DATA_PHASE;
    			end
	
		    //---------------------------------
    		// Send Read Data
    		//---------------------------------
    		RD_DATA_PHASE:
    			begin
        			if(rvalid && rready)
            			rd_state <= RD_ADDR_PHASE;
    			end

		endcase

    end

end
//=====================================================
// Write Channel Combinational Logic
//=====================================================

always_comb
begin

    // Default values
    awready = 1'b0;
    wready  = 1'b0;

    bvalid  = 1'b0;
    bresp   = 2'b00;          // OKAY
    bid     = write_id_reg;

    case(wr_state)

        //---------------------------------
        // Address Phase
        //---------------------------------
        WR_ADDR_PHASE:
        begin
            awready = 1'b1;
        end

        //---------------------------------
        // Data Phase
        //---------------------------------
        WR_DATA_PHASE:
        begin
            wready = 1'b1;
        end

        //---------------------------------
        // Response Phase
        //---------------------------------
        WR_RESPONSE_PHASE:
        begin
            bvalid = 1'b1;
            bresp  = 2'b00;
            bid    = write_id_reg;
        end

        default:
        begin
            awready = 1'b0;
            wready  = 1'b0;
            bvalid  = 1'b0;
        end

    endcase

end


//=====================================================
// Read Channel Combinational Logic
//=====================================================

always_comb
begin

    // Default values
    arready = 1'b0;

    rvalid  = 1'b0;
    rdata   = '0;
    rresp   = 2'b00;          // OKAY
    rid     = read_id_reg;
    rlast   = 1'b0;

    case(rd_state)

        //---------------------------------
        // Address Phase
        //---------------------------------
        RD_ADDR_PHASE:
        begin
            arready = 1'b1;
        end
		
      RD_WAIT_PHASE:
		begin
    // Nothing to drive here.
    // RAM is reading using ram_addr.
		end
      	
        //---------------------------------
        // Data Phase
        //---------------------------------
        RD_DATA_PHASE:
        begin
            rvalid = 1'b1;
            rdata  = ram_rdata;
            rid    = read_id_reg;
            rresp  = 2'b00;
            rlast  = 1'b1;
        end

        default:
        begin
            arready = 1'b0;
            rvalid  = 1'b0;
        end

    endcase

end


//=====================================================
// RAM Interface Control
//=====================================================

always_comb
begin

    // Default values
    wr_rd     = 1'b1;      // Read
    ram_addr  = '0;
    ram_wdata = '0;

    //---------------------------------
    // Write Operation
    //---------------------------------
    if((wr_state == WR_DATA_PHASE) && wvalid)
    begin
        wr_rd     = 1'b0;              // Write
        ram_addr  = write_addr_reg;
        ram_wdata = wdata;
    end

    //---------------------------------
    // Read Operation
    //---------------------------------
  else if(rd_state == RD_WAIT_PHASE || rd_state == RD_DATA_PHASE)
    begin
        wr_rd     = 1'b1;              // Read
        ram_addr  = read_addr_reg;
    end

end

endmodule

=======
module ram_controller(

input logic aclk,
input logic arst,

//=====================================================
// Write Address Channel
//=====================================================
input  logic [3:0]  awid,
input  logic [31:0] awaddr,
input  logic [3:0]  awlen,
input  logic [2:0]  awsize,
input  logic [1:0]  awburst,
input  logic        awlock,
input  logic [3:0]  awcache,
input  logic [2:0]  awprot,
input  logic        awvalid,
output logic        awready,

//=====================================================
// Write Data Channel
//=====================================================
input  logic [31:0] wdata,
input  logic [3:0]  wstrb,
input  logic        wlast,
input  logic        wvalid,
output logic        wready,

//=====================================================
// Write Response Channel
//=====================================================
output logic [3:0]  bid,
output logic [1:0]  bresp,
output logic        bvalid,
input  logic        bready,

//=====================================================
// Read Address Channel
//=====================================================
input  logic [3:0]  arid,
input  logic [31:0] araddr,
input  logic [3:0]  arlen,
input  logic [2:0]  arsize,
input  logic [1:0]  arburst,
input  logic        arlock,
input  logic [3:0]  arcache,
input  logic [2:0]  arprot,
input  logic        arvalid,
output logic        arready,

//=====================================================
// Read Data Channel
//=====================================================
output logic [3:0]  rid,
output logic [31:0] rdata,
output logic [1:0]  rresp,
output logic        rlast,
output logic        rvalid,
input  logic        rready,

//=====================================================
// RAM Interface
//=====================================================
output logic        wr_rd,
output logic [31:0] ram_addr,
output logic [31:0] ram_wdata,
input  logic [31:0] ram_rdata

);

//=====================================================
// Internal Registers
//=====================================================

logic [31:0] write_addr_reg;
logic [31:0] read_addr_reg;

logic [31:0] write_data_reg;

logic [3:0] write_id_reg;
logic [3:0] read_id_reg;

logic [3:0] write_len_reg;
logic [3:0] read_len_reg;


//=====================================================
// Write FSM
//=====================================================

typedef enum logic [1:0]
{
    WR_ADDR_PHASE,
    WR_DATA_PHASE,
    WR_RESPONSE_PHASE
} wr_state_t;

wr_state_t wr_state;


//=====================================================
// Read FSM
//=====================================================

typedef enum logic [1:0]
{
    RD_ADDR_PHASE,
  	RD_WAIT_PHASE,
    RD_DATA_PHASE
} rd_state_t;

rd_state_t rd_state;


//=====================================================
// Sequential Logic
//=====================================================

always_ff @(posedge aclk or negedge arst)
begin

    if(!arst)
    begin

        //-------------------------
        // Reset States
        //-------------------------

        wr_state <= WR_ADDR_PHASE;
        rd_state <= RD_ADDR_PHASE;

        //-------------------------
        // Internal Registers
        //-------------------------

        write_addr_reg <= '0;
        read_addr_reg  <= '0;

        write_data_reg <= '0;

        write_id_reg <= '0;
        read_id_reg  <= '0;

        write_len_reg <= '0;
        read_len_reg  <= '0;

    end

    else
    begin

        //-------------------------------------
        // WRITE FSM
        //-------------------------------------

        case(wr_state)

            //---------------------------------
            // Address Phase
            //---------------------------------

            WR_ADDR_PHASE:
            begin

                if(awvalid && awready)
                begin

                    write_addr_reg <= awaddr;
                    write_id_reg   <= awid;
                    write_len_reg  <= awlen;

                    wr_state <= WR_DATA_PHASE;

                end

            end


            //---------------------------------
            // Data Phase
            //---------------------------------

            WR_DATA_PHASE:
            begin

                if(wvalid && wready && wlast)
                begin

                    write_data_reg <= wdata;

                    wr_state <= WR_RESPONSE_PHASE;

                end

            end


            //---------------------------------
            // Response Phase
            //---------------------------------

            WR_RESPONSE_PHASE:
            begin

                if(bvalid && bready)

                    wr_state <= WR_ADDR_PHASE;

            end

        endcase


        //-------------------------------------
        // READ FSM
        //-------------------------------------

        case(rd_state)

            //---------------------------------
            // Address Phase
            //---------------------------------

            RD_ADDR_PHASE:
            begin

                if(arvalid && arready)
                begin

                    read_addr_reg <= araddr;
                    read_id_reg   <= arid;
                    read_len_reg  <= arlen;

                    rd_state <= RD_WAIT_PHASE;

                end

            end

 			//---------------------------------
    		// Wait for RAM
    		//---------------------------------
    		RD_WAIT_PHASE:
    			begin
        			rd_state <= RD_DATA_PHASE;
    			end
	
		    //---------------------------------
    		// Send Read Data
    		//---------------------------------
    		RD_DATA_PHASE:
    			begin
        			if(rvalid && rready)
            			rd_state <= RD_ADDR_PHASE;
    			end

		endcase

    end

end
//=====================================================
// Write Channel Combinational Logic
//=====================================================

always_comb
begin

    // Default values
    awready = 1'b0;
    wready  = 1'b0;

    bvalid  = 1'b0;
    bresp   = 2'b00;          // OKAY
    bid     = write_id_reg;

    case(wr_state)

        //---------------------------------
        // Address Phase
        //---------------------------------
        WR_ADDR_PHASE:
        begin
            awready = 1'b1;
        end

        //---------------------------------
        // Data Phase
        //---------------------------------
        WR_DATA_PHASE:
        begin
            wready = 1'b1;
        end

        //---------------------------------
        // Response Phase
        //---------------------------------
        WR_RESPONSE_PHASE:
        begin
            bvalid = 1'b1;
            bresp  = 2'b00;
            bid    = write_id_reg;
        end

        default:
        begin
            awready = 1'b0;
            wready  = 1'b0;
            bvalid  = 1'b0;
        end

    endcase

end


//=====================================================
// Read Channel Combinational Logic
//=====================================================

always_comb
begin

    // Default values
    arready = 1'b0;

    rvalid  = 1'b0;
    rdata   = '0;
    rresp   = 2'b00;          // OKAY
    rid     = read_id_reg;
    rlast   = 1'b0;

    case(rd_state)

        //---------------------------------
        // Address Phase
        //---------------------------------
        RD_ADDR_PHASE:
        begin
            arready = 1'b1;
        end
		
      RD_WAIT_PHASE:
		begin
    // Nothing to drive here.
    // RAM is reading using ram_addr.
		end
      	
        //---------------------------------
        // Data Phase
        //---------------------------------
        RD_DATA_PHASE:
        begin
            rvalid = 1'b1;
            rdata  = ram_rdata;
            rid    = read_id_reg;
            rresp  = 2'b00;
            rlast  = 1'b1;
        end

        default:
        begin
            arready = 1'b0;
            rvalid  = 1'b0;
        end

    endcase

end


//=====================================================
// RAM Interface Control
//=====================================================

always_comb
begin

    // Default values
    wr_rd     = 1'b1;      // Read
    ram_addr  = '0;
    ram_wdata = '0;

    //---------------------------------
    // Write Operation
    //---------------------------------
    if((wr_state == WR_DATA_PHASE) && wvalid)
    begin
        wr_rd     = 1'b0;              // Write
        ram_addr  = write_addr_reg;
        ram_wdata = wdata;
    end

    //---------------------------------
    // Read Operation
    //---------------------------------
  else if(rd_state == RD_WAIT_PHASE || rd_state == RD_DATA_PHASE)
    begin
        wr_rd     = 1'b1;              // Read
        ram_addr  = read_addr_reg;
    end

end

endmodule

>>>>>>> 26da373000eabdbb4fb626dc0dbe77ae4fa1eb5c
