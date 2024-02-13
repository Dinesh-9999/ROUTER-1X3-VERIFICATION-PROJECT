class router_wr_mon extends uvm_monitor;
`uvm_component_utils(router_wr_mon);
virtual router_sif.WR_MON_MP vif;
router_wr_agt_config wr_cfg;
uvm_analysis_port #(write_xtn) analysis_port_wmon;
write_xtn xtn;
extern function new(string name="router_wr_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data;
endclass

function router_wr_mon::new(string name="router_wr_mon",uvm_component parent);
	super.new(name,parent);
	analysis_port_wmon=new("analysis_port_wmon",this);
endfunction

function void router_wr_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agt_config)::get(this,"","router_wr_agt_config",wr_cfg))
		`uvm_fatal("MON","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_wr_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=wr_cfg.vif;
endfunction

task router_wr_mon::run_phase(uvm_phase phase);
	//super.run_phase(uvm_phase phase);
//	wait(vif.wr_mon_cb.pkt_valid)
	

	forever
		begin
		collect_data;
	//	wait(vif.wr_mon_cb.pkt_valid)
	//	@(vif.wr_mon_cb);	
		end

endtask

task router_wr_mon::collect_data;
	xtn=write_xtn::type_id::create("xtn");
//	@(vif.wr_mon_cb);
	wait(vif.wr_mon_cb.pkt_valid)
	xtn.header=vif.wr_mon_cb.data_in;
	xtn.payload_data=new[xtn.header[7:2]];
	@(vif.wr_mon_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.wr_mon_cb.busy)
				xtn.payload_data[i]=vif.wr_mon_cb.data_in;
				@(vif.wr_mon_cb);
		end
	wait(~vif.wr_mon_cb.busy)
	xtn.parity=vif.wr_mon_cb.data_in;
analysis_port_wmon.write(xtn);

// `uvm_info("Router_src_monitor",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
//$display("--------END---------------------");

//	wait(vif.wr_mon_cb.pkt_valid)
	@(vif.wr_mon_cb);


	endtask
