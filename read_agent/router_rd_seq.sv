class router_rd_seq  extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_rd_seq);
extern function new(string name="router_rd_seq");
endclass

function router_rd_seq::new(string name="router_rd_seq");
	super.new(name);
endfunction

class router_rd_seq_case1  extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_rd_seq_case1);
extern function new(string name="router_rd_seq_case1");
extern task body;
endclass

function router_rd_seq_case1::new(string name="router_rd_seq_case1");
	super.new(name);
endfunction


task router_rd_seq_case1::body;
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize);
	finish_item(req);
endtask
