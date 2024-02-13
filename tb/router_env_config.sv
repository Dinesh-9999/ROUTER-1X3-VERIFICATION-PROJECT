class router_env_config extends uvm_object;

`uvm_object_utils(router_env_config)

int no_of_wr_agents;
int no_of_rd_agents;
int has_scoreboard;
int has_virtual_sequencer;

router_wr_agt_config wr_cfg[];
router_rd_agt_config rd_cfg[];

extern function new(string name="router_env_config");

endclass

function router_env_config::new(string name="router_env_config");
	super.new(name);
endfunction





