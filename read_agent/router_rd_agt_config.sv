class router_rd_agt_config extends uvm_object;

`uvm_object_utils(router_rd_agt_config)
uvm_active_passive_enum is_active=UVM_ACTIVE;
virtual router_dif vif;

extern function new(string name="router_rd_agt_config");

endclass

function router_rd_agt_config::new(string name="router_rd_agt_config");
	super.new(name);
endfunction
