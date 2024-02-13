class router_wr_agt_top extends uvm_env;
`uvm_component_utils(router_wr_agt_top);

router_env_config cfg;
router_wr_agt_config wr_cfg[];
router_wr_agent wr_agt[];

extern function new(string name="router_wr_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function router_wr_agt_top::new(string name="router_wr_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction 

function void router_wr_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("router_wr_agt_top","cannot get env config data");
	wr_cfg=new[cfg.no_of_wr_agents];
	wr_agt=new[cfg.no_of_wr_agents];
	foreach(wr_agt[i])
	 begin
		wr_cfg[i]=cfg.wr_cfg[i];
		wr_agt[i]=router_wr_agent::type_id::create($sformatf("wr_agt[%0d]",i),this);
		uvm_config_db#(router_wr_agt_config)::set(this,$sformatf("wr_agt[%0d]*",i),"router_wr_agt_config",wr_cfg[i]);
       	 end
endfunction
