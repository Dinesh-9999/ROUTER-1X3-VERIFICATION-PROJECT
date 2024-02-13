class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard);
	uvm_tlm_analysis_fifo#(write_xtn) analysis_fifo_wmon[];
	uvm_tlm_analysis_fifo#(read_xtn) analysis_fifo_rmon[];
	router_env_config cfg;
	
	write_xtn xtn;
	read_xtn rxtn;

	write_xtn write_cov_data;
        read_xtn read_cov_data;
	

	covergroup router_fcov1;
    option.per_instance=1;

    // Address
    CHANNEL : coverpoint write_cov_data.header[1:0] {
        bins low = {2'b00};
        bins mid1 = {2'b01};
        bins mid2 = {2'b10};
    }

    // Payload size
    PAYLOAD_SIZE : coverpoint write_cov_data.header[7:0] {
        bins small_packet = {[1:15]};
        bins medium_packet = {[16:30]};
        bins large_packet = {[31:63]};
    }

     CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL, PAYLOAD_SIZE;

endgroup

covergroup router_fcov2;
      option.per_instance = 1;

      //Address
      CHANNEL : coverpoint read_cov_data.header[1:0] {        bins low = {2'b00};
                                                              bins mid1 ={2'b01};
                                                              bins mid2 ={2'b10};     }

      //payload size
      PAYLOAD_SIZE : coverpoint read_cov_data.header[7:0] {   bins small_packet = {[1:15]};
                                                              bins medium_pakcet = {[16:30]};
                                                              bins large_packet ={[31:63]};   }

      CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL,PAYLOAD_SIZE;

    endgroup



	
	extern function new(string name="router_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_packet(read_xtn rd);
endclass


function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("SB","cannot get config data");

		analysis_fifo_rmon=new[cfg.no_of_rd_agents];
		analysis_fifo_wmon=new[cfg.no_of_wr_agents];

	foreach(analysis_fifo_rmon[i])
		analysis_fifo_rmon[i]=new($sformatf("analysis_fifo_rmon[%0d]",i),this);

	foreach(analysis_fifo_wmon[i])
		analysis_fifo_wmon[i]=new($sformatf("analysis_fifo_wmon[%0d]",i),this);
		super.build_phase(phase);
endfunction


task router_scoreboard::run_phase(uvm_phase phase);
	  forever
		begin
			analysis_fifo_wmon[0].get(xtn);
			`uvm_info("Router_src_monitor",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 

			analysis_fifo_rmon[xtn.header[1:0]].get(rxtn);
			`uvm_info("Router_dst_monitor",$sformatf("printing from driver \n %s", rxtn.sprint()),UVM_LOW) 
			check_packet(rxtn);
		end
endtask

function void router_scoreboard::check_packet(read_xtn rd);
	$display("------------------SCOREBOARD RESULTS-------------------------------");
	$display("FOR DESTINATION =%0d",xtn.header[1:0]);
	if(rxtn.header==xtn.header)
	  begin
	    foreach(rxtn.payload_data[i])
		if(rxtn.payload_data[i]!=xtn.payload_data[i])
		     begin 
			$display("---------------------------WRONG DATA-------------------------------");
			return;
		     end
		 $display("------------------------HEADER  MATCH------------------------------------");
	  end
	else
	    begin  
		$display("------------------------HEADER MISMATCH------------------------------------");
		return;
	    end
	if(rxtn.parity==xtn.parity)
	    $display("-------------------------------GOOD PACKET-------------------------------------------");
	else
	    $display("--------------------------------BAD PACKET------------------------------------------");

endfunction
