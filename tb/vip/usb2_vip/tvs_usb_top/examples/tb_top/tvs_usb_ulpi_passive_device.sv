//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    File for Passive monitor instance 
//
//  Brief description:
//
//  Known exceptions to rules:
//
//============================================================================
//  Author        :
//  Created on    :
//  File Id       : 
//============================================================================


`include "tvs_ulpi_intf.svh"

import uvm_pkg::*;

module tvs_usb_ulpi_passive_device#(parameter device_id = 0,int DATA_WIDTH=8, string env_name="dummy_env") (
      clock,
      reset,
      dir,
      nxt,
      stp,
      data_in,
      data_out 
      );

  // Timing Information
  timeunit 1ns;
  timeprecision 1ps;

  input clock;
  input reset;
  input dir;
  input nxt;
  input stp;
  input [DATA_WIDTH-1:0] data_in;
  input [DATA_WIDTH-1:0] data_out;

 
  always @(*) begin
    tvs_ulpi_dev_if.dir = dir;
    tvs_ulpi_dev_if.reset = reset;
    tvs_ulpi_dev_if.nxt = nxt;
    tvs_ulpi_dev_if.stp = stp;
    tvs_ulpi_dev_if.data_in = data_in;
    tvs_ulpi_dev_if.data_out = data_out;
  end

  tvs_ulpi_intf #(DATA_WIDTH) tvs_ulpi_dev_if(clock);

   string inst_name;
   string inst_name_1;
  // setting the interface instance
  initial begin
    $sformat(inst_name_1,"%s",env_name);
    $sformat(inst_name,"*%s.device_agent[%0d]*",inst_name_1,device_id);
    $display(" ################inst_name : %s",inst_name);
    uvm_config_db#(virtual tvs_ulpi_intf#(DATA_WIDTH))::set(null,inst_name, "tvs_ulpi_dev_if", tvs_ulpi_dev_if);
   //uvm_config_db#(virtual tvs_ulpi_intf#(DATA_WIDTH))::set(null,"*slave_agent*", "tvs_ulpi_dev_if", tvs_ulpi_dev_if);
  end

endmodule
    
