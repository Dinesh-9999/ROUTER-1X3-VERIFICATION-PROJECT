class router_rd_mon extends uvm_monitor;
`uvm_component_utils(router_rd_mon);
virtual router_dif.RD_MON_MP vif;
router_rd_agt_config rd_cfg;
uvm_analysis_port #(read_xtn) analysis_port_rmon;
read_xtn xtn;
extern function new(string name="router_rd_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data;
endclass

function router_rd_mon::new(string name="router_rd_mon",uvm_component parent);
	super.new(name,parent);
	analysis_port_rmon=new("analysis_port_rmon",this);
endfunction

function void router_rd_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",rd_cfg))
		`uvm_fatal("router_rd_mon","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_rd_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=rd_cfg.vif;
endfunction

task router_rd_mon::run_phase(uvm_phase phase);
	forever
		collect_data;
endtask

task router_rd_mon::collect_data;
	xtn=read_xtn::type_id::create("xtn");
	
	wait(vif.rd_mon_cb.read_enb)
	@(vif.rd_mon_cb);
	xtn.header=vif.rd_mon_cb.data_out;
	xtn.payload_data=new[xtn.header[7:2]];
	@(vif.rd_mon_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
			//wait(vif.rd_mon_cb.read_enb)
			xtn.payload_data[i]=vif.rd_mon_cb.data_out;
			@(vif.rd_mon_cb);
		end
//	@(vif.rd_mon_cb);
//	wait(vif.rd_mon_cb.read_enb)
	xtn.parity=vif.rd_mon_cb.data_out;
	analysis_port_rmon.write(xtn);
//	xtn.print;
	@(vif.rd_mon_cb);
	@(vif.rd_mon_cb);
	// `uvm_info("Router_dst_monitor",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
	endtask

