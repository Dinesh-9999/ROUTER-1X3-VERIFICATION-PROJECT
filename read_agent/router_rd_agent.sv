class router_rd_agent extends uvm_agent;
`uvm_component_utils(router_rd_agent);
router_rd_seqr rd_seqr;
router_rd_driver rd_dr;
router_rd_mon rd_mon;
router_rd_agt_config rd_cfg;
extern function new(string name="router_rd_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function router_rd_agent::new(string name="router_rd_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",rd_cfg))
		`uvm_fatal("R_AGENT","cannot get config data");
	super.build_phase(phase);
	rd_mon=router_rd_mon::type_id::create("rd_mon",this);
	if(rd_cfg.is_active==UVM_ACTIVE)
		begin
		rd_seqr=router_rd_seqr::type_id::create("r_seqr",this);
		rd_dr=router_rd_driver::type_id::create("rd_dr",this);
		end
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rd_dr.seq_item_port.connect(rd_seqr.seq_item_export);
endfunction
