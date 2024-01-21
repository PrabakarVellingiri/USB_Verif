//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    File for tvs_usb_ulpi_active_host class
//
//  Brief description: 
//    This is overall test bench top, where in you instance your DUV and run
//    the test bench process. 
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================

//-----------------------------------------------
// Including the defines files
//-----------------------------------------------
`include "tvs_usb2_defines.svh"
//-----------------------------------------------

//-----------------------------------------------
// Including the interface files
//-----------------------------------------------
`include "tvs_ulpi_intf.svh"
//-----------------------------------------------

import uvm_pkg::*;
module tvs_usb_ulpi_host#(parameter host_id=0,int DATA_WIDTH=8,string env_name="dummy_env")(
                         clk,  
                         reset,  
                         dir,
                         nxt,
                         stp,
                         data_in,
                         data_out);
 
 // Timing Information
  timeunit 1ns;
  timeprecision 1ps;
  
  input clk,reset; 
  output dir,nxt; 
  input  [DATA_WIDTH-1:0] data_in;
  input  stp;
  output [DATA_WIDTH-1:0] data_out;
  
  assign data_out=tvs_ulpi_host_if.host_cb.data_out;
  assign dir     =tvs_ulpi_host_if.host_cb.dir;
  assign nxt     =tvs_ulpi_host_if.host_cb.nxt;
  

  always @(*) begin
    tvs_ulpi_host_if.stp     =stp;
    tvs_ulpi_host_if.data_in =data_in;
    tvs_ulpi_host_if.reset     = reset;
  end
 
  //Instance of interface
  tvs_ulpi_intf #(DATA_WIDTH) tvs_ulpi_host_if(clock);

  string inst_name;
  string inst_name_1;
  
  initial begin
    $sformat(inst_name_1,"%s",env_name);
    $sformat(inst_name,"*%s.host_agent[%0d]*",inst_name_1,host_id);
    uvm_config_db#(virtual tvs_ulpi_intf#(DATA_WIDTH))::set(null,inst_name, "tvs_ulpi_host_if", tvs_ulpi_host_if);
  end

endmodule

