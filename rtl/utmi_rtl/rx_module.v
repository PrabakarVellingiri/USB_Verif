//////NRZI DECODER RX////////////////////////
module nrzi_dec (dec_out,clk,rst,dec_in,dec_in_valid,dec_out_valid);
  input dec_in;
  input clk;
  input rst;
  output reg dec_out;
  input dec_in_valid;
  output reg dec_out_valid;
  reg w1;
    
  always @(posedge clk) begin
    if (!rst) begin
       if(dec_in_valid)
          w1 <=  dec_in;
    //  #2
    //  $display("time = %0t w1 = %0b",$time,w1);
    end
  end
  
  always @(posedge clk) begin
    if (rst) begin
        dec_out<=1'b0;
        w1<=1'b0;
        dec_out_valid<=1'b0;
    end
    else begin
      if(dec_in_valid) begin
           dec_out<=~(dec_in^w1);
           dec_out_valid<=1;
       // #2
        //   $display("time = %0t dec_out = %0b",$time,dec_out);
      end
      else
        dec_out_valid<=0;
    end
  end
endmodule
///////////////bitunstuffer///////////////////////////
module bitunstuffer(unstuf_out,unstuf_out_valid,clk,rst,unstuf_in,unstuf_in_en);
  input unstuf_in;
  input unstuf_in_en;
  output reg unstuf_out;
  output reg unstuf_out_valid;
  input clk,rst;
  bit que[$];
  reg [6:0]sft_reg;
  reg count_6;
  always@(posedge clk) begin
    if(rst) begin
      unstuf_out<=0; unstuf_out_valid<=0;
      count_6<=0;
      sft_reg<=6'b000000;
    end
    else begin
      if(unstuf_in_en)
      que.push_front(unstuf_in);
      sft_reg=sft_reg<<1;
      sft_reg[0]=que[0];
     // $display("sft_reg=%b",sft_reg);
      if(sft_reg==7'b1111110)begin
        count_6=1;
      end
      if(que.size()>0) begin
        if(count_6==1) begin
          unstuf_out_valid=0;
          que.delete(0);
          count_6=0;
        end
        else if(unstuf_in_en) begin
          unstuf_out_valid=1;
          unstuf_out=que.pop_back();
        //  $display("time = %0t unstuf_out=%b",$time,unstuf_out);
        end
      end
      else
        unstuf_out_valid=0;
    end
  end
endmodule
/////////////SHIFTHOLD ////////////////////////////
module holdshift #(parameter width=8,parameter depth=64,parameter period=1.04) (rx_hold_out,clk,clk2,rst,rxvalid,load,rx_shft_in);
  
  input rx_shft_in,clk,clk2,rst;
  input load;
  output reg  [width-1:0]rx_hold_out;
  output reg rxvalid;
  reg byte_data_rec_f;
  reg [3:0]count_byte;
  reg [width-1:0] data_reg;
  reg [width-1:0] rx_shft_2_hold;
  reg hold_reg_en; 
  typedef bit [width-1:0] queue;
  queue qu1[$:depth-1];
  
  always @ (posedge clk) begin 
    if (rst)begin
      data_reg <= 8'h00;
      hold_reg_en<=1'b0;
      byte_data_rec_f<=0;
      count_byte<=4'b0000;
      rxvalid<=0;
      rx_hold_out<=0;
    end
    else if(load)begin
      data_reg <={data_reg[width-1:0],rx_shft_in}; 
      count_byte<=count_byte+1; 
     // $display("count_byte = %0d data_reg = %0b", count_byte, data_reg);
    end    
  end
  
  always@(posedge clk) begin 
    if(count_byte==8) begin
       byte_data_rec_f=1;
       count_byte=0;
     // $display("time = %0t byte_data_rec_f is %0b",$time,byte_data_rec_f);
    end
  end
  
  always@(posedge clk) begin 
    if(byte_data_rec_f==1'b1)begin
      rx_shft_2_hold <=data_reg;
      byte_data_rec_f<=0;
      hold_reg_en<=1;
     // $display("time = %0t rx_shft_2_hold = %0b",$time,rx_shft_2_hold);
    end
  end
  
  always @(posedge clk2)begin 
    if(!rst) begin 
      if(hold_reg_en)
        qu1.push_back(rx_shft_2_hold);
    //  $display("time = %0t qu1 = %0p qu1 = %0d",$time,qu1,qu1.size());
        hold_reg_en<=0;
    end
  end
  
  always @(posedge clk2)begin
    if(!rst) begin 
       if(qu1.size()>0) begin
         rx_hold_out<=qu1.pop_front();
         rxvalid<=1;
         #20;
         //$display("time = %0t rx_hold_out = %0b rxvalid = %0b",$time,rx_hold_out,rxvalid);
      end
      else if(qu1.size()==0) begin
         rxvalid<=0;
      end
    end
  end
endmodule
/////////////////////sync pat//////////////////////////////
module sync #(parameter period=1.04)(clk_480mhz,en,din,eop_dect,rst);
  input din;
  input rst;
  input eop_dect;
  input clk_480mhz;
  bit que[$];
  reg [7:0]sft_reg;
  output reg en;
  always@(posedge clk_480mhz) begin
    if(rst) begin
      en=1'b0;
    end
    else begin
      que.push_front(din);
      sft_reg=sft_reg<<1;
      sft_reg[0]=que[0];
      if(sft_reg==8'b01010100)
        en=1;
      else if(eop_dect)
        en=0;
    end
  end
endmodule
////////////////////////////////////////////////////

