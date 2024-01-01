///////////tx hold reg////////////////////////////////////////
module holdreg #(parameter width=8,parameter depth=64,parameter period=1.04)(tx_hold_out,clk2,rst,txvalid,txready,tx_hold_in,tx_hold_out_en);
  input [width-1:0]tx_hold_in;
  input clk2,rst;
  input  txvalid;
  output reg tx_hold_out_en;
  output reg [width-1:0]tx_hold_out;
  output reg txready;
  byte qu1[$:depth-1];
  always@(txvalid) begin
    if(txvalid)
      txready<=1;
    else
      txready<=0;
  end
  //write
  always @ (posedge clk2)begin
    if(rst)begin
     txready<=0;
     tx_hold_out_en<=0;
     //$display("HOLDREG_RESET");
    end
    else begin 
     if(txvalid==1 && txready==1)begin
       qu1.push_back(tx_hold_in);
     end 
    end
  end 
  
  //read
  always @(posedge clk2)begin
    if(!rst) begin
     if(qu1.size()>0) begin
       tx_hold_out<=qu1.pop_front();
       tx_hold_out_en<=1;    
     end
     else if (qu1.size == 0)
       tx_hold_out_en<=0;
    end
  end
endmodule
/////////////tx shift reg/////////////////////////////////
module shiftreg #(parameter width = 8, parameter period = 1.04)
  (tx_shft_out,load,clk,clk2,rst,tx_shft_in,tx_shft_out_valid);
  input load;
  input clk;
  input clk2;
  input rst;
  output reg tx_shft_out_valid;
  input [width-1:0] tx_shft_in;
  output reg tx_shft_out;
  reg tx_shft_in_rec_f;
  reg [width-1:0] data_reg;
  
  always @ (posedge clk2) begin
    if (rst) begin
      data_reg<=8'h00; 
      tx_shft_out<=0;
      tx_shft_out_valid<=0;
      tx_shft_in_rec_f<=0;
     // $display("SHIFTREG_RESET");
    end
    else if (load) begin
      data_reg<=tx_shft_in;
      tx_shft_in_rec_f<=1;
      //$display("load data_reg= %0b tx_shft_in=%0b",data_reg,tx_shft_in);
    end
    else
     tx_shft_in_rec_f<=0;
  end
  
  always @ (posedge clk) begin
    if (~rst) begin
      if(tx_shft_in_rec_f) begin
        tx_shft_out=data_reg[0];
        data_reg = data_reg>>1;
        data_reg = {1'b0,data_reg[width-1:0]}; 
       // $display("data_reg=%0b tx_shft_out = %0b",data_reg,tx_shft_out);
        tx_shft_out_valid = 1;
      end
      else
        tx_shft_out_valid <=0;
    end
  end
endmodule
/////////////////////bit stuff////////////////////
module bitstuffer(tx_stuf_out,clk,rst,tx_stuf_in,dout_valid,tx_stuf_in_en);
  input tx_stuf_in;
  output reg tx_stuf_out;
  output reg dout_valid;
  input clk,rst;
  input tx_stuf_in_en;
  bit que[$];
  reg [5:0]sft_reg;
  reg count_6;
  always@(posedge clk) begin
    if(rst) begin
      tx_stuf_out<=0;
      dout_valid<=0;
      count_6<=0;
      sft_reg<=6'b000000;
      //$display("BITSTUFFER_RESET");
    end
    else begin
      //$display("tx_stuf_in_en=%0b tx_stuf_in = %0b",tx_stuf_in_en,tx_stuf_in);
      if(tx_stuf_in_en) begin
        que.push_front(tx_stuf_in);
        sft_reg<=sft_reg<<1;
        sft_reg[0]<=que[0];
      //  $display("time = %0t tx_stuf_in = %0b sft_reg=%b",$time,tx_stuf_in,sft_reg);
        if(sft_reg==6'b111111)begin
         count_6<=1;
        end
      end
    end
  end
  always@(posedge clk) begin
    if(!rst) begin      
         if(que.size()>0) begin
          tx_stuf_out<=que.pop_back();
          dout_valid <=1;
          $display("time = %0t tx_stuf_out=%b",$time,tx_stuf_out);
         end
         else if(que.size()==0)
          dout_valid<=0;
     end
  end
  always@(posedge count_6) begin
    que.push_front(0);
    count_6<=0;
    sft_reg<=6'b000000;
  end
endmodule
/////////////nrzi encoder/////////////////////////
module nrzi_encoder (enc_do,clk,rst,enc_di,enc_din_valid,enc_dout_valid);
  input clk;
  input rst;
  input enc_di,enc_din_valid;
  output reg enc_do;
  output reg enc_dout_valid;
  
  always@(posedge clk or posedge rst) begin
    if(rst) begin
       enc_do <= 1'b1;
       enc_dout_valid<=0;
    end
    else begin
      if(enc_din_valid) begin
       // $display("time = %0t enc_di=%b",$time,enc_di);
        enc_do <= ~(enc_di ^ enc_do);
        enc_dout_valid<=1;
       // $display("time = %0t enc_do = %0b",$time,enc_do);
      end
      else
       enc_dout_valid<=0;
    end
  end
endmodule
///////////EOP_Generation//////////////////////////////////
module eop_gen(clk_480mhz,eop_en,Dp,Dm,reset_eop);
  input clk_480mhz,eop_en;
  output reg Dp,Dm;
  bit [1:0]count;
  output bit reset_eop;
  assign Dp=(count<=2'b01)?1'b0:1'b1;
  assign Dm=(count<=2'b01)?1'b0:1'b0;
  always@(posedge clk_480mhz) begin
    if(eop_en) begin
      if(count<=2'b01) 
        count++;
        reset_eop<=1;
    end
    else begin
      count<=2'b00;
      reset_eop<=0;
    end
  end
endmodule
////////////////////////////////////////////////////////////








