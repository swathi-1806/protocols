`define NEW_COMP \
function new(string name="", uvm_component parent);\
	super.new(name,parent);\
endfunction

`define NEW_OBJ \
function new(string name="");\
	super.new(name);\
endfunction

`define ADDR_WIDTH 32
`define DATA_WIDTH 32

typedef enum bit [1:0]{
	FIXED,
	INCR,
	WRAP
}burst_type_t;


