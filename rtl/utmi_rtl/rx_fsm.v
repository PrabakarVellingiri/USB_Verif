`include "rx_module.sv"
module rx_fsm #(parameter w=8) (dpr,dmr,rx_valid,rx_data,clk_480mhz,clk_60mhz,rst);
  //States present in RX_FSM
  parameter rx_reset_state          =  3'b000,
            rx_wait                 =  3'b001,
            rx_data_state           =  3'b010;
            
  input rst,clk_480mhz,clk_60mhz;
  input dpr,dmr;
  output rx_valid;
  output [(w-1):0]rx_data;
  wire dec_out_2_unstuf_in;
  wire dec_out_valid_to_unstuf_in_en;
  wire unstuf_out_2_holdshft_in;
  wire unstuf_out_valid; 
  reg [w-1:0]rx_hold_out; 
  reg reset;
  reg rxactive;  
  reg [(w-1):0]rx_data_q[$];
  wire en_f; 
  reg [2:0] PS = rx_reset_state;
  reg [2:0] NS = rx_reset_state;
  wire eop_detect;
  
  assign rx_data=rx_hold_out;
  assign eop_detect=(!dpr && !dmr)?1'b1:1'b0;
 
  
  //instantiation of rx_module
  nrzi_dec NRZI_DEC(dec_out_2_unstuf_in,clk_480mhz,reset,dpr,en_f,dec_out_valid_to_unstuf_in_en);
  bitunstuffer BIT_UNSTUFFER(unstuf_out_2_holdshft_in,unstuf_out_valid,clk_480mhz,reset,dec_out_2_unstuf_in,dec_out_valid_to_unstuf_in_en);
  holdshift HOLD_SHIFT(rx_hold_out,clk_480mhz,clk_60mhz,reset,rx_valid,unstuf_out_valid,unstuf_out_2_holdshft_in);
  sync sync_pat(clk_480mhz,en_f,dpr,eop_detect,rst);
 
  always @(posedge clk_480mhz)
    begin
      if(rst)
        PS<=rx_reset_state;
      else
        PS<=NS;
    end
  
  always @(*) 
    begin
      case(PS)
        rx_reset_state : begin if(rst) begin
                      reset <=1;
                      rxactive <= 0;
                      NS<=rx_reset_state;
                      $display("rx_reset_state");
                      end
                      else
                      reset <=0;
                      NS<=rx_wait;
        end
        
        rx_wait : begin if(en_f) begin 
                         NS <= rx_data_state;
                         $display("rx_wait");
                        end
                        else
                         NS<=rx_wait;
        end
     
        rx_data_state : begin if(!eop_detect) begin 
                               NS<=rx_data_state;
                               $display("rx_data_state");
                              end
                              else begin
                                NS<=rx_wait; 
                              end
        end
        
        default  : NS <= rx_reset_state;             
      endcase
    end
 endmodule

