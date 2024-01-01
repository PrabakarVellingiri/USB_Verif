interface utmi_interf(input logic clk_480mhz, clk_60mhz,rst);
timeunit 1ns;
timeprecision 1ns;
wire data_p;
wire data_m;
logic TXValid;
logic TXReady;
logic RXValid;
logic RXActive; 
logic RXError;
logic LineState;
logic  OpMode;
logic [0:7]DataIn;   // DATA IN (TX) signals
logic [0:7]DataOut; 
logic reg_cfg_done;
logic host_linkup_done;
logic  Xcvr_select;
  
  
//logic [8:15] DataIn;

//logic TXValidH;

				// DATA OUT (RX) signals
//logic [8:15] DataOut;

//logic RXValidH;
  
  clocking driv_cb1 @(posedge clk_480mhz);			//clocking block driver
  default input #1 output #1; 
  output clk_480mhz;
  output DataIn  ; // DATA IN (TX)
  //output DataIn;
  output TXValid;
  //input TXValidH;
  input TXReady;
  input DataOut ; // DATA OUT (RX)
  //input DataOut;
  input RXValid;
  //input RXValidH;
  input RXActive;
  input RXError;
  //inout DP;
  //inout DM;
  output reg_cfg_done;
  output host_linkup_done;
  output OpMode;
  input LineState;
  output Xcvr_select;
  
endclocking
  
  clocking driv_cb2 @(posedge clk_60mhz);			//clocking block driver
  default input #1 output #1; 
  input clk_60mhz;
  output DataIn  ; // DATA IN (TX)
  //output DataIn;
  output TXValid;
  //input TXValidH;
  input TXReady;
  input DataOut ; // DATA OUT (RX)
  //input DataOut;
  input RXValid;
  //input RXValidH;
  input RXActive;
  input RXError;
  //inout DP;
  //inout DM;
  output reg_cfg_done;
  output host_linkup_done;
  output OpMode;
 // input LineState_linkup;
  output Xcvr_select;
     
    
  
endclocking

 
  
  clocking mon_cb @(posedge clk_480mhz);			//clocking block moniter
  default input #1 output #1;
//  input clk_60mhz;
  input DataIn; // DATA IN (TX)
  input TXValid;
  //input TXValidH;
  input TXReady;
  input DataOut; // DATA OUT (RX)
  input RXValid;
  //input RXValidH;
  input RXActive;
  input RXError;
endclocking


  modport driv_mp1(clocking driv_cb1); //modport clocking block driver
  modport driv_mp2(clocking driv_cb2);
  modport mon_mp(clocking mon_cb); //modport clocking block monitor
  

endinterface



