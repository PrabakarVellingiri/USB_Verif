//`include "tx_module.v"
module tx_fsm #(parameter w=8)(dpt,dmt,tx_data,tx_valid,enc_dount_valid_f,clk_480mhz,clk_60mhz,rst);
 //States present in TX_FSM
  parameter     reset_state  = 3'b000,
 			    tx_wait      = 3'b001,
 			    send_sync    = 3'b010,
		        tx_data_load = 3'b011,
			    send_eop     = 3'b100;
  
  input rst,clk_480mhz,clk_60mhz;
  input tx_valid;
  reg txvalid;
  output dpt,dmt;
  input [(w-1):0]tx_data;
  output enc_dount_valid_f;
  wire [(w-1):0]tx_hold_out_shift_in;
  reg [(w-1):0]tx_hold_in;
  wire tx_hold_out_shift_in_en,tx_ready;
  wire hold_2_shft,shft_2_stuf_en;
  wire tx_shft_out_stuf_in;
  wire tx_stuf_out_encoder_in;
  wire bitstuf_dout_valid_enc_din_valid;
  wire enc_do;
  reg reset;
  bit eop;
  bit reset_eop;
  wire eop_f;
  bit tx_valid_f;
  wire enc_dout_valid;
  wire Dp,Dm;
  reg [(w-1):0]tx_data_q[$];
  reg[2:0] present_state=reset_state;
  reg[2:0] next_state=reset_state;
  
  //instatiation of tx_module
  holdreg tx_holdreg(tx_hold_out_shift_in,clk_60mhz,reset,txvalid,tx_ready,tx_hold_in,tx_hold_out_shift_in_en);
  shiftreg tx_shft_reg(tx_shft_out_stuf_in,tx_hold_out_shift_in_en,clk_480mhz,clk_60mhz,reset,tx_hold_out_shift_in,shft_2_stuf_en);
  bitstuffer tx_bit_stuff(tx_stuf_out_encoder_in,clk_480mhz,reset,tx_shft_out_stuf_in,bitstuf_dout_valid_enc_din_valid,shft_2_stuf_en);
  nrzi_encoder tx_nrzi_enc(enc_do,clk_480mhz,reset,tx_stuf_out_encoder_in,bitstuf_dout_valid_enc_din_valid,enc_dout_valid);
  eop_gen tx_eop_gen(clk_480mhz,eop_f,Dp,Dm,reset_eop);
  
  //tx_data inserted in tx fsm
  always@(posedge clk_60mhz)begin
    if(tx_valid) begin
      tx_data_q.push_back(tx_data);
      tx_valid_f=1;
    end
    else
      if(tx_data_q.size()==0)
        tx_valid_f=0;
  end
  assign dpt=eop_f?Dp:enc_do; //nrzi enc_do assigned to dpt when eop_f is low
  assign dmt=eop_f?Dm:!enc_do;
 
  //FSM states operation
  always@(next_state)
    present_state <= next_state;
  assign eop_f=(eop && !enc_dout_valid)?1'b1:1'b0;// TO add EOP SE0
  assign enc_dount_valid_f=(eop_f||enc_dout_valid) ?1'b1:1'b0;// TO add EOP SE0
  always@(posedge clk_60mhz) begin
    case(present_state)
      
       reset_state: begin 
         if(rst) begin
           reset <=1;
           next_state <= reset_state;
          // $display("time = %0t State:Reset",$time);
         end
	     else begin
           reset <=0;
	       next_state <= tx_wait;
         end
       end
      
       tx_wait: begin 
         if(reset_eop)eop<=0;
         if(tx_valid_f) begin
           next_state <= send_sync;
          // $display("time = %0t State:tx_wait",$time);
         end
		 else 
		   next_state <= tx_wait; 
         end
      
       send_sync: begin  
           tx_hold_in <= 8'h00;// To generate SYNC pattern
           txvalid<=1;
           next_state <= tx_data_load;
         //$display("time = %0t State:send_sync",$time);
       end
      
       tx_data_load: begin 
         if(tx_data_q.size()>0) begin
           tx_hold_in <= tx_data_q.pop_front();
           txvalid <=1;
       	   next_state <=  tx_data_load;
          // $display("time = %0t State:tx_data_load",$time);
         end
         else begin
		   next_state <= send_eop;
           txvalid <=0;
         end
       end
      
       send_eop: begin 
         //$display("time = %0t State:send_eop",$time);
         eop<=1;
         next_state <= tx_wait;
       end
       default: next_state <= reset_state;
      endcase
  end
endmodule
