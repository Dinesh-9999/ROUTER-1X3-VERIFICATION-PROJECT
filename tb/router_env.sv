class router_env extends uvm_env;
`uvm_component_utils(router_env);
router_env_config cfg;
router_scoreboard sb;
router_virtual_sequencer v_seqr;
router_wr_agt_top wr_top;
router_rd_agt_top rd_top;

extern function new(string name="router_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function router_env::new(string name="router_env",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("env","cannot get config data");
	super.build_phase(phase);
	if(cfg.has_scoreboard)
		sb=router_scoreboard::type_id::create("sb",this);
	if(cfg.has_virtual_sequencer)
		v_seqr=router_virtual_sequencer::type_id::create("v_seqr",this);

		wr_top=router_wr_agt_top::type_id::create("wr_top",this);

		rd_top=router_rd_agt_top::type_id::create("rd_top",this);
endfunction

function void router_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(cfg.has_virtual_sequencer)
	begin
	foreach(v_seqr.w_seqr[i])
		v_seqr.w_seqr[i]=wr_top.wr_agt[i].wr_seqr;
	foreach(v_seqr.r_seqr[i])
		v_seqr.r_seqr[i]=rd_top.rd_agt[i].rd_seqr;
	end
	if(cfg.has_scoreboard)
	begin
		foreach(wr_top.wr_agt[i])
		wr_top.wr_agt[i].wr_mon.analysis_port_wmon.connect(sb.analysis_fifo_wmon[i].analysis_export);
		foreach(rd_top.rd_agt[i])
		rd_top.rd_agt[i].rd_mon.analysis_port_rmon.connect(sb.analysis_fifo_rmon[i].analysis_export);
	end
endfunction
