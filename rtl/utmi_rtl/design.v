`include "tx_fsm.sv"
`include "rx_fsm.sv"
module utmi #(parameter w=8)(data_p,data_m,tx_valid,data,clk_480mhz,clk_60mhz,rst);
inout data_p,data_m;
inout [(w-1):0]data;
input tx_valid;
input clk_480mhz,clk_60mhz,rst;
reg dpt,dmt;
wire dpr,dmr;
wire enc_dout_valid;
wire rx_valid;
wire [(w-1):0]tx_data,rx_data;
//assign rx_valid=0; //remove this after enable rx_fsm
  
assign tx_data=tx_valid?data:'z;
assign data=rx_valid?rx_data:'z;
assign {data_p,data_m}=enc_dout_valid?{dpt,dmt}:2'bz; 
assign {dpr,dmr}=!enc_dout_valid?{data_p,data_m}:2'bz; 

  always@(rx_valid)
    $display("rx_data = %0b",data);
  
//Instantiate tx & rx FSM
tx_fsm tx(dpt,dmt,tx_data,tx_valid,enc_dout_valid,clk_480mhz,clk_60mhz,rst);
rx_fsm rx(dpr,dmr,rx_valid,rx_data,clk_480mhz,clk_60mhz,rst);

endmodule



