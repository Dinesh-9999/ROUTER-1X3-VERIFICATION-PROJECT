class router_test extends uvm_test;
`uvm_component_utils(router_test)
router_env_config cfg;
router_wr_agt_config wr_cfg[];
router_rd_agt_config rd_cfg[];
int no_of_wr_agents=1;
int no_of_rd_agents=3;
int has_scoreboard=1;
int has_virtual_sequencer=1;
router_env env;

extern function new(string name="router_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function router_test:: new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test:: build_phase(uvm_phase phase);
	rd_cfg=new[no_of_rd_agents];
	wr_cfg=new[no_of_wr_agents];
	cfg=router_env_config::type_id::create("router_env_config");
	cfg.rd_cfg=new[no_of_rd_agents];
	cfg.wr_cfg=new[no_of_wr_agents];
	foreach(wr_cfg[i])
	begin
		wr_cfg[i]=router_wr_agt_config::type_id::create($sformatf("wr_cfg[%0d]",i));
		if(!uvm_config_db #(virtual router_sif)::get(this,"","svif",wr_cfg[i].vif))
			`uvm_fatal("router_test","cannot get interface for  config data");
		wr_cfg[i].is_active=UVM_ACTIVE;
		cfg.wr_cfg[i]=wr_cfg[i];
	end
	foreach(rd_cfg[i])
	begin
		rd_cfg[i]=router_rd_agt_config::type_id::create($sformatf("rd_cfg[%0d]",i));
		if(!uvm_config_db #(virtual router_dif)::get(this,"",$sformatf("dvif[%0d]",i),rd_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");
		rd_cfg[i].is_active=UVM_ACTIVE;
		cfg.rd_cfg[i]=rd_cfg[i];
	end
	cfg.no_of_wr_agents=no_of_wr_agents;
	cfg.no_of_rd_agents=no_of_rd_agents;
	cfg.has_scoreboard=has_scoreboard;
	cfg.has_virtual_sequencer=has_virtual_sequencer;
	uvm_config_db#(router_env_config) ::set(this,"*","router_env_config",cfg);
	super.build_phase(phase);
	env=router_env::type_id::create("env",this);
endfunction

function void router_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction

class router_test_case1 extends router_test;
`uvm_component_utils(router_test_case1)
router_virtual_sequence_case1 v_seq;

extern function new(string name="router_test_case1",uvm_component parent);
extern function void build_phase(uvm_phase);
extern task run_phase(uvm_phase);

endclass

function router_test_case1:: new(string name="router_test_case1",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test_case1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task router_test_case1::run_phase(uvm_phase phase);
	v_seq=router_virtual_sequence_case1::type_id::create("v_seq");
//	repeat(2)
//	begin
	phase.raise_objection(this);
				v_seq.start(env.v_seqr);
	phase.drop_objection(this);
//	end

endtask

class router_test_case2 extends router_test;
`uvm_component_utils(router_test_case2)
router_virtual_sequence_case2 v_seq;

extern function new(string name="router_test_case2",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_test_case2:: new(string name="router_test_case2",uvm_component parent);
	super.new(name,parent);
	endfunction

function void router_test_case2::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task router_test_case2::run_phase(uvm_phase phase);
	v_seq=router_virtual_sequence_case2::type_id::create("v_seq");
//	repeat(2)
//	begin
	phase.raise_objection(this);
				v_seq.start(env.v_seqr);
	phase.drop_objection(this);
//	end

endtask

class router_test_case3 extends router_test;
`uvm_component_utils(router_test_case3)
router_virtual_sequence_case3 v_seq;

extern function new(string name="router_test_case3",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_test_case3:: new(string name="router_test_case3",uvm_component parent);
	super.new(name,parent);
	endfunction

function void router_test_case3::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task router_test_case3::run_phase(uvm_phase phase);
	v_seq=router_virtual_sequence_case3::type_id::create("v_seq");
//	repeat(2)
//	begin
	phase.raise_objection(this);
				v_seq.start(env.v_seqr);
	phase.drop_objection(this);
//	end

endtask



