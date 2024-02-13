class router_rd_driver extends uvm_driver #(read_xtn);
	`uvm_component_utils(router_rd_driver);

	virtual router_dif.RD_DR_MP vif;
	router_rd_agt_config rd_cfg;

	extern function new(string name="router_rd_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase);
	extern task drive(read_xtn xtn);
endclass

function router_rd_driver::new(string name="router_rd_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",rd_cfg))
		`uvm_fatal("R_DR","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_rd_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=rd_cfg.vif;
endfunction

task router_rd_driver::run_phase(uvm_phase phase);
	req=read_xtn::type_id::create("req");
	vif.rd_dr_cb.read_enb<=0;
	forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done;
		end
endtask

task router_rd_driver::drive(read_xtn xtn);

@(vif.rd_dr_cb);
	wait(vif.rd_dr_cb.valid_out);
	repeat(xtn.soft_delay)
	@(vif.rd_dr_cb);
	vif.rd_dr_cb.read_enb<=1;
	
	wait(~vif.rd_dr_cb.valid_out)
	@(vif.rd_dr_cb);
	vif.rd_dr_cb.read_enb<=0;
       //  `uvm_info("Router_dest_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
endtask
