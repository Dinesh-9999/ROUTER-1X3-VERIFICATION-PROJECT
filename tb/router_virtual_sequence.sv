class router_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(router_virtual_sequence);
router_virtual_sequencer v_seqr;
router_wr_seqr w_seqr[];
router_rd_seqr r_seqr[];
router_env_config cfg;
//router_wr_seq_case1 w_seq[]; 
//router_rd_seq_case1 r_seq[];

extern function new(string name="router_virtual_sequence");
extern task body;
endclass

function router_virtual_sequence::new(string name="router_virtual_sequence");
	super.new(name);
endfunction

task router_virtual_sequence::body;
	if(!uvm_config_db#(router_env_config) ::get(null,get_full_name(),"router_env_config",cfg))
		`uvm_fatal("virtual_sequence","cannot get cfg");
	$cast(v_seqr,m_sequencer);
	w_seqr=new[cfg.no_of_wr_agents];
	r_seqr=new[cfg.no_of_rd_agents];
	foreach(w_seqr[i])
		w_seqr[i]=v_seqr.w_seqr[i];
	foreach(r_seqr[i])
		r_seqr[i]=v_seqr.r_seqr[i];
endtask

class router_virtual_sequence_case1 extends router_virtual_sequence;
`uvm_object_utils(router_virtual_sequence_case1);
router_wr_seq_case1 w_seq[]; 
router_rd_seq_case1 r_seq[];

extern function new(string name="router_virtual_sequence_case1");
extern task body;

endclass

function router_virtual_sequence_case1::new(string name="router_virtual_sequence_case1");
	super.new(name);
endfunction

task router_virtual_sequence_case1::body;
	super.body;

	w_seq=new[cfg.no_of_wr_agents];
	foreach(w_seq[i])
	w_seq[i]=router_wr_seq_case1::type_id::create($sformatf("w_seq[%0d]",i));
	r_seq=new[cfg.no_of_rd_agents];
	foreach(r_seq[i])
	r_seq[i]=router_rd_seq_case1::type_id::create($sformatf("r_seq[%0d]",i));
	//repeat(3)
//	begin
	fork
		begin
		foreach(w_seqr[i])
		w_seq[i].start(w_seqr[i]);
		end
		begin
		fork:a
		r_seq[0].start(r_seqr[0]);
		r_seq[1].start(r_seqr[1]);
		r_seq[2].start(r_seqr[2]);
		join
	//	disable a;
		end
	join
//	end
	endtask

class router_virtual_sequence_case2 extends router_virtual_sequence;
`uvm_object_utils(router_virtual_sequence_case2);
router_wr_seq_case2 w_seq[]; 
router_rd_seq_case1 r_seq[];

extern function new(string name="router_virtual_sequence_case2");
extern task body;

endclass

function router_virtual_sequence_case2::new(string name="router_virtual_sequence_case2");
	super.new(name);
endfunction

task router_virtual_sequence_case2::body;
	super.body;

	w_seq=new[cfg.no_of_wr_agents];
	foreach(w_seq[i])
	w_seq[i]=router_wr_seq_case2::type_id::create($sformatf("w_seq[%0d]",i));
	r_seq=new[cfg.no_of_rd_agents];
	foreach(r_seq[i])
	r_seq[i]=router_rd_seq_case1::type_id::create($sformatf("r_seq[%0d]",i));
	//repeat(3)
//	begin
	fork
		begin
		foreach(w_seqr[i])
		w_seq[i].start(w_seqr[i]);
		end
		begin
		fork:a
		r_seq[0].start(r_seqr[0]);
		r_seq[1].start(r_seqr[1]);
		r_seq[2].start(r_seqr[2]);
		join
	//	disable a;
		end
	join
//	end
	endtask


class router_virtual_sequence_case3 extends router_virtual_sequence;
`uvm_object_utils(router_virtual_sequence_case3);
router_wr_seq_case3 w_seq[]; 
router_rd_seq_case1 r_seq[];

extern function new(string name="router_virtual_sequence_case3");
extern task body;

endclass

function router_virtual_sequence_case3::new(string name="router_virtual_sequence_case3");
	super.new(name);
endfunction

task router_virtual_sequence_case3::body;
	super.body;

	w_seq=new[cfg.no_of_wr_agents];
	foreach(w_seq[i])
	w_seq[i]=router_wr_seq_case3::type_id::create($sformatf("w_seq[%0d]",i));
	r_seq=new[cfg.no_of_rd_agents];
	foreach(r_seq[i])
	r_seq[i]=router_rd_seq_case1::type_id::create($sformatf("r_seq[%0d]",i));
	//repeat(3)
//	begin
	fork
		begin
		foreach(w_seqr[i])
		w_seq[i].start(w_seqr[i]);
		end
		begin
		fork:a
		r_seq[0].start(r_seqr[0]);
		r_seq[1].start(r_seqr[1]);
		r_seq[2].start(r_seqr[2]);
		join
	//	disable a;
		end
	join
//	end
	endtask
