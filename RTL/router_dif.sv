interface router_dif(input bit clk);

logic read_enb,valid_out,resetn;
logic [7:0] data_out;

clocking rd_dr_cb@(posedge clk);
default input#1 output  #1;
	input valid_out;
	output read_enb;
	output resetn;
endclocking


clocking rd_mon_cb@(posedge clk);
default input#1 output  #1;
	input  data_out;
	input read_enb;
	input valid_out;
endclocking


modport RD_DRV_MP(clocking rd_dr_cb);
modport RD_MON_MP(clocking rd_mon_cb);


endinterface

