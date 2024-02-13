module router_chip(router_sif sif,router_dif dif0,router_dif dif1,router_dif dif2); 



router_top RTL(.data_out_0(dif0.data_out),.data_out_1(dif1.data_out),.data_out_2(dif2.data_out),.valid_out_0(dif0.valid_out),.valid_out_1(dif1.valid_out),
.valid_out_2(dif2.valid_out),.error(sif.error),.busy(sif.busy),.pkt_valid(sif.pkt_valid),.read_enb_0(dif0.read_enb),.read_enb_1(dif1.read_enb),.read_enb_2(dif2.read_enb),.clk(sif.clk),
.resetn(sif.resetn),.data_in(sif.data_in));

endmodule

