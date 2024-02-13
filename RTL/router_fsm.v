module router_fsm(detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy,
clk,resetn,pkt_valid,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
fifo_empty_0,fifo_empty_1,fifo_empty_2);
input [1:0]data_in;
input clk,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
output detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy;
parameter DECODE_ADDRESS=3'b000,
          LOAD_FIRST_DATA=3'b001,
          LOAD_DATA=3'b010,
          FIFO_FULL_STATE=3'b011,
          LOAD_AFTER_FULL=3'b100,
          LOAD_PARITY=3'b101,
          WAIT_TILL_EMPTY=3'b110,
          CHECK_PARITY_ERROR=3'b111;
reg [2:0]ps,ns;
reg [1:0]addr;

always@(posedge clk)//present state logic
begin
if(!resetn ||(soft_reset_0 && (addr==0))||(soft_reset_1 && (addr==1))||(soft_reset_2 && (addr==2)))
ps<=DECODE_ADDRESS;
else
ps<=ns;
end

always@(posedge clk)
begin
if(!resetn)
addr<=0;
else if(detect_add)
addr<=data_in;
end



always@(*)//next state logic
begin
case(ps)
DECODE_ADDRESS:begin
                if((pkt_valid && (data_in[1:0]==0)&&fifo_empty_0)||(pkt_valid && (data_in[1:0]==1)&&fifo_empty_1)||(pkt_valid && (data_in[1:0]==2)&&fifo_empty_2))
                ns=LOAD_FIRST_DATA;
                else if((pkt_valid && (data_in[1:0]==0)&& !fifo_empty_0)||(pkt_valid && (data_in[1:0]==1)&& !fifo_empty_1)||(pkt_valid && (data_in[1:0]==2)&&!fifo_empty_2))
                ns=WAIT_TILL_EMPTY;
                else
                ns=DECODE_ADDRESS;
                end
LOAD_FIRST_DATA:ns=LOAD_DATA;
LOAD_DATA:begin
        if(fifo_full)
            ns=FIFO_FULL_STATE;
        else if(!pkt_valid)
            ns=LOAD_PARITY;
        else
            ns=LOAD_DATA;
        end
FIFO_FULL_STATE:begin
                case(fifo_full)
                1:ns=FIFO_FULL_STATE;
                0:ns=LOAD_AFTER_FULL;
                default:ns=DECODE_ADDRESS;
                endcase
                end
LOAD_AFTER_FULL:begin
                if(parity_done)
                ns=DECODE_ADDRESS;
                else if(!low_pkt_valid)
                ns=LOAD_DATA;
                else
                ns=LOAD_PARITY;
                end
LOAD_PARITY:ns=CHECK_PARITY_ERROR;
CHECK_PARITY_ERROR:begin
                    if(fifo_full)
                        ns=FIFO_FULL_STATE;
                    else
                        ns=DECODE_ADDRESS;
                    end
WAIT_TILL_EMPTY:begin
                if((fifo_empty_0 && (addr==0))||(fifo_empty_1 && (addr==1))||(fifo_empty_2 && (addr==2)))
                    ns=LOAD_FIRST_DATA;
                else
                    ns=WAIT_TILL_EMPTY;
                end
default:ns=DECODE_ADDRESS;
endcase
end

assign detect_add=((ps==DECODE_ADDRESS))?1'b1:1'b0;
//assign busy=((ps==LOAD_FIRST_DATA)||(ps==FIFO_FULL_STATE)||(ps==LOAD_AFTER_FULL)||(ps==LOAD_PARITY)||(ps==CHECK_PARITY_ERROR)||(ps==WAIT_TILL_EMPTY))?1'b1:1'b0;
assign busy=((ps==DECODE_ADDRESS)||(ps==LOAD_DATA))?1'b0:1'b1;
assign ld_state=(ps==LOAD_DATA)?1'b1:1'b0;
assign write_enb_reg=((ps==LOAD_DATA)||(ps==LOAD_AFTER_FULL)||(ps==LOAD_PARITY))?1'b1:1'b0;
assign laf_state=(ps==LOAD_AFTER_FULL)?1'b1:1'b0;
assign full_state=(ps==FIFO_FULL_STATE)?1'b1:1'b0;
assign rst_int_reg=(ps==CHECK_PARITY_ERROR)?1'b1:1'b0;
assign lfd_state=(ps==LOAD_FIRST_DATA)?1'b1:1'b0;
endmodule
