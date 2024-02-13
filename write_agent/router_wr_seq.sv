class router_wr_seq extends uvm_sequence #(write_xtn);
`uvm_object_utils(router_wr_seq);
extern function new(string name="router_wr_seq");
endclass

function router_wr_seq::new(string name="router_wr_seq");
	super.new(name);
endfunction


class router_wr_seq_case1 extends router_wr_seq;
`uvm_object_utils(router_wr_seq_case1);
extern function new(string name="router_wr_seq_case1");
extern task body;
endclass

function router_wr_seq_case1::new(string name ="router_wr_seq_case1");
	super.new(name);
endfunction


task router_wr_seq_case1::body;
	req=write_xtn::type_id::create("req");
repeat(3)
	begin
	start_item(req);
	assert(req.randomize with {header[7:2] == 4;});
	finish_item(req);
	end
endtask

class router_wr_seq_case2 extends router_wr_seq;
`uvm_object_utils(router_wr_seq_case2);
extern function new(string name="router_wr_seq_case2");
extern task body;
endclass

function router_wr_seq_case2::new(string name ="router_wr_seq_case2");
	super.new(name);
endfunction



task router_wr_seq_case2::body;
	req=write_xtn::type_id::create("req");
repeat(3)
	begin
	start_item(req);
	assert(req.randomize with {header[7:2] == 16;});
	finish_item(req);
	end
endtask

class router_wr_seq_case3 extends router_wr_seq;
`uvm_object_utils(router_wr_seq_case3);
extern function new(string name="router_wr_seq_case3");
extern task body;
endclass

function router_wr_seq_case3::new(string name ="router_wr_seq_case3");
	super.new(name);
endfunction



task router_wr_seq_case3::body;
	req=write_xtn::type_id::create("req");
repeat(3)
	begin
	start_item(req);
	assert(req.randomize with {header[7:2] == 35;});
	finish_item(req);
	end
endtask
