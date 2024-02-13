module router_top(data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,
valid_out_2,error,busy,pkt_valid,read_enb_0,read_enb_1,read_enb_2,clk,resetn,data_in);
output valid_out_0,valid_out_1,valid_out_2,error,busy;
input pkt_valid,read_enb_0,read_enb_1,read_enb_2,clk,resetn;
input [7:0]data_in;
output[7:0]data_out_0,data_out_1,data_out_2;

wire parity_done,empty_0,empty_1,empty_2,full_0,full_1,full_2,soft_reset_0,soft_reset_1,
soft_reset_2,lfd_state,write_enb_reg,detect_add,fifo_full,rst_int_reg,ld_state,laf_state,full_state,low_pkt_valid;

wire [7:0]dout;
wire [2:0]write_enb;
router_reg Register(dout,parity_done,error,low_pkt_valid,full_state,lfd_state,laf_state,ld_state,rst_int_reg,
fifo_full,pkt_valid,resetn,clk,detect_add,data_in);

sync_router Synchroniser(write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,valid_out_0,
valid_out_1,valid_out_2,full_0,full_1,full_2, empty_0,empty_1, empty_2,
read_enb_0,read_enb_1,read_enb_2,detect_add,write_enb_reg,clk,resetn,data_in[1:0]);

router_fsm FSM(detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy,
clk,resetn,pkt_valid,parity_done,data_in[1:0],soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
empty_0,empty_1,empty_2);

router_fifo FIFO_0(data_out_0,empty_0,full_0,lfd_state,resetn,soft_reset_0,write_enb[0],read_enb_0,dout,clk);

router_fifo FIFO_1(data_out_1,empty_1,full_1,lfd_state,resetn,soft_reset_1,write_enb[1],read_enb_1,dout,clk);

router_fifo FIFO_2(data_out_2,empty_2,full_2,lfd_state,resetn,soft_reset_2,write_enb[2],read_enb_2,dout,clk);

endmodule
