class router_wr_driver extends uvm_driver #(write_xtn);
`uvm_component_utils(router_wr_driver);

virtual router_sif.WR_DRV_MP vif;
router_wr_agt_config wr_cfg;

extern function new(string name="router_wr_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task drive(write_xtn xtn);
endclass

function router_wr_driver::new(string name="router_wr_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_wr_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agt_config)::get(this,"","router_wr_agt_config",wr_cfg))
		`uvm_fatal("DR","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_wr_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=wr_cfg.vif;
endfunction

task router_wr_driver::run_phase(uvm_phase phase);
	@(vif.wr_dr_cb);
	vif.wr_dr_cb.resetn<=0;
	@(vif.wr_dr_cb);
	vif.wr_dr_cb.resetn<=1;
		forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done(req);
		end
endtask

task router_wr_driver::drive(write_xtn xtn);
	
	wait(~vif.wr_dr_cb.busy)

	 //`uvm_info("Router_src_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
//$display("----------------------------");
	@(vif.wr_dr_cb);
	vif.wr_dr_cb.pkt_valid<=1;
	vif.wr_dr_cb.data_in<=xtn.header;
	@(vif.wr_dr_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.wr_dr_cb.busy)
				vif.wr_dr_cb.data_in<=xtn.payload_data[i];
				@(vif.wr_dr_cb);
		end
	wait(~vif.wr_dr_cb.busy)
	vif.wr_dr_cb.pkt_valid<=0;
	vif.wr_dr_cb.data_in<=xtn.parity;
	repeat(4)
	@(vif.wr_dr_cb);
//	@(vif.wr_dr_cb);


endtask
