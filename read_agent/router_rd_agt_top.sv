class router_rd_agt_top extends uvm_env;
`uvm_component_utils(router_rd_agt_top);

router_env_config cfg;
router_rd_agt_config rd_cfg[];
router_rd_agent rd_agt[];

extern function new(string name="router_rd_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function router_rd_agt_top::new(string name="router_rd_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction 

function void router_rd_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("AGT_TOP","cannot get config data");
	rd_cfg=new[cfg.no_of_rd_agents];
	rd_agt=new[cfg.no_of_rd_agents];
	foreach(rd_agt[i]) begin
	rd_cfg[i]=cfg.rd_cfg[i];
	rd_agt[i]=router_rd_agent::type_id::create($sformatf("rd_agt[%0d]",i),this);
	uvm_config_db#(router_rd_agt_config)::set(this,$sformatf("rd_agt[%0d]*",i),"router_rd_agt_config",rd_cfg[i]);
	end
endfunction
