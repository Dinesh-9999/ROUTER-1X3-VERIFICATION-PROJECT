module router_reg(dout,parity_done,err,low_pkt_valid,full_state,lfd_state,laf_state,ld_state,rst_int_reg,
fifo_full,pkt_valid,resetn,clk,detect_add,data_in);
input [7:0]data_in;
output reg [7:0]dout;
output reg parity_done,err,low_pkt_valid;
input full_state,lfd_state,laf_state,ld_state,rst_int_reg,
fifo_full,pkt_valid,resetn,clk,detect_add;
reg [7:0]header,fifo_full_byte,internal_parity,packet_parity;

//dout logic
always@(posedge clk)
begin
if(!resetn)
{dout,header,fifo_full_byte}<=0;
else if(detect_add&& pkt_valid)
header<=data_in;
else if(lfd_state)
dout<=header;
else if(ld_state && !fifo_full)
dout<=data_in;
else if(ld_state && fifo_full)
fifo_full_byte<=data_in;
else if(laf_state)
dout<=fifo_full_byte;
else
dout<=dout;
end

//parity done logic
always@(posedge clk)
begin
if(!resetn||detect_add)
parity_done<=1'b0;
else if(ld_state && !pkt_valid && !fifo_full)
parity_done<=1'b1;
else if(laf_state && low_pkt_valid && !parity_done)//transistion from LAF to load parity
parity_done<=1'b1;
else
parity_done<=parity_done;
end

//low_pkt_valid_logic
always@(posedge clk)
begin
if(!resetn||rst_int_reg)
low_pkt_valid<=0;
else if(ld_state && !pkt_valid)
low_pkt_valid<=1'b1;
else
low_pkt_valid<=low_pkt_valid;
end

//parity_calculate_logic
always@(posedge clk)
begin
if(!resetn||detect_add)
{internal_parity}<=0;
else if(lfd_state && pkt_valid)
internal_parity<=internal_parity^header;
else if(ld_state && pkt_valid && !full_state)
internal_parity<=internal_parity^data_in;
else
internal_parity<=internal_parity;
end

//error detection
always@(posedge clk)
begin
if(!resetn)
err<=0;
else
begin
if(parity_done)
begin
if(packet_parity!=internal_parity)
err=1'b1;
else
err=1'b0;
end
else
err<=0;
end
end

always@(posedge clk)
begin
if(!resetn|| detect_add)
packet_parity<=0;
else if((ld_state && !fifo_full && !pkt_valid)||(laf_state && !parity_done && low_pkt_valid))
packet_parity<=data_in;
else
packet_parity<=packet_parity;
end
endmodule