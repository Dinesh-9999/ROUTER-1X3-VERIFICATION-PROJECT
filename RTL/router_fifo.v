module router_fifo(data_out,empty,full,lfd_state,resetn,soft_reset,write_enable,read_enable,data_in,clk);
input [7:0]data_in;
input lfd_state,read_enable,write_enable,soft_reset,resetn,clk;
output reg [7:0]data_out;
output full,empty;
reg [4:0]w_ptr,r_ptr;
reg [6:0]fifo_count;
reg [8:0]mem[0:15];
reg temp;
integer i;
always@(posedge clk)
begin
if(!resetn)
temp<=1'b0;
else
temp<=lfd_state;
end

always@(posedge clk)//write operation
begin
if(!resetn || soft_reset)
begin
w_ptr<=0;
//r_ptr<=0;
for(i=0;i<16;i=i+1)
mem[i]<=0;
end
else if(!full && write_enable)
begin
w_ptr<=w_ptr+1'b1;
mem[w_ptr[3:0]]<={temp,data_in};
end
else
w_ptr<=w_ptr;
end

always@(posedge clk)//read operation
begin
if(!resetn)
begin
r_ptr<=0;
data_out<=8'b0;
fifo_count<=0;
end
else if(soft_reset||(fifo_count==0 && data_out!=0))
data_out<=8'bz;
else if(read_enable && !empty)
begin
data_out<=mem[r_ptr[3:0]][7:0];
r_ptr<=r_ptr+1'b1;
if(mem[r_ptr[3:0]][8]==1'b1)
fifo_count<=mem[r_ptr[3:0]][7:2]+1'b1;
else if(fifo_count!=0)
fifo_count<=fifo_count-1'b1;
else
fifo_count<=fifo_count;
end
else
r_ptr<=r_ptr;
end

assign full=(w_ptr=={(~r_ptr[4]),r_ptr[3:0]})?1'b1:1'b0;
assign empty=(w_ptr==r_ptr)?1'b1:1'b0;
endmodule




