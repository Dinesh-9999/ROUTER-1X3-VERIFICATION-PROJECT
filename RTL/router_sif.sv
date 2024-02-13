interface router_sif(input bit clk);

logic [7:0 ]data_in;
logic resetn,busy,pkt_valid,error;
//bit clk;
clocking wr_dr_cb@(posedge clk);
default input#1 output  #1;
	input busy;
	output resetn;
	output pkt_valid;
	output data_in;
endclocking

clocking wr_mon_cb@(posedge clk);
default input#1 output  #1;
	input busy;
	input resetn;
	input pkt_valid;
	input data_in;
	input error;
endclocking


modport WR_DRV_MP(clocking wr_dr_cb);
modport WR_MON_MP(clocking wr_mon_cb);

endinterface

