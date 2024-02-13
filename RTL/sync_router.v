module sync_router(write_enb,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,
vld_out_1,vld_out_2,full_0,full_1,full_2, empty_0,empty_1, empty_2,
read_enb_0,read_enb_1,read_enb_2,detect_add,write_enb_reg,clk,resetn,data_in);
input [1:0]data_in;
input clk,resetn,write_enb_reg,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2;
output reg [2:0]write_enb;
output reg soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2,fifo_full;
reg [4:0]timer_0,timer_1,timer_2;
reg [1:0]temp;
always@(posedge clk)
begin
if(!resetn) 
temp<=0;
else if(detect_add)
temp<=data_in;
end

always@(*)
begin
case(temp)
0:fifo_full=full_0;
1:fifo_full=full_1;
2:fifo_full=full_2;
3:fifo_full=0;
default:fifo_full=0;
endcase
end

always@(*)
begin
if(write_enb_reg)
begin
case(temp)
0:write_enb=3'd1;
1:write_enb=3'd2;
2:write_enb=3'd4;
3:write_enb=3'b0;
default:write_enb=3'b0;
endcase
end
else
write_enb<=0;
end


always@(*)
begin
vld_out_0=~empty_0;
vld_out_1=~empty_1;
vld_out_2=~empty_2;
end

always@(posedge clk)
begin
if(!resetn)
{soft_reset_0,timer_0}<=0;
else
begin
case(vld_out_0)
1:case(read_enb_0)
    1:{timer_0,soft_reset_0}<=0;
    0:begin
        if(timer_0==30)
            begin
            timer_0<=0;
            soft_reset_0<=1'b1;
            end
        else 
            begin
            timer_0<=timer_0+1'b1;
            soft_reset_0<=0;
            end
      end
    default:{timer_0,soft_reset_0}<=0;
    endcase
0:{timer_0,soft_reset_0}<=0;
default:{timer_0,soft_reset_0}<=0;
endcase
end
end

always@(posedge clk)
begin
    if(!resetn)
    {soft_reset_1,timer_1}<=0;
    else
    begin
    case({read_enb_1,vld_out_1})
    0,2,3:{timer_1,soft_reset_1}<=0;
    1:{soft_reset_1,timer_1}<=(timer_1==30)?6'b100000:timer_1+1'b1;
    default:{timer_1,soft_reset_1}<=0;
    endcase
    end
end

always@(posedge clk)
begin
    if(!resetn)
    {soft_reset_2,timer_2}<=0;
    else
    begin
    case({read_enb_2,vld_out_2})
    0,2,3:{timer_2,soft_reset_2}<=0;
    1:{soft_reset_2,timer_2}<=(timer_2==30)?6'b100000:timer_2+1'b1;
    default:{timer_2,soft_reset_2}<=0;
    endcase
    end
end

endmodule