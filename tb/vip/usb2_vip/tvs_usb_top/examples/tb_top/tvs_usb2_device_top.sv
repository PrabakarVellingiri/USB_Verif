//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    File for tvs_usb2_device_top class
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

`ifndef TVS_USB2_DEVICE_TOP_SVH
`define TVS_USB2_DEVICE_TOP_SVH

`define no_device 1
 
`include "tvs_ulpi_intf.svh"
module tvs_usb2_device_top;

  // Timing Information
  timeunit 1ns;
  timeprecision 1ps;

  //Instance of axi_usb2_device_0_top
  tvs_axi_usb2_device_0_top axi_usb_inst();
 
  `include "uvm_macros.svh"
  `include "tvs_usb2_include.svh" 

  parameter USB_DATA_WIDTH=8;
  parameter USB_ENV_NAME="env";

  bit clock;
  
  logic  reset; 
  logic  dir;
  logic  nxt;
  logic  stp;
  logic  [USB_DATA_WIDTH-1:0] data_in;
  logic  [USB_DATA_WIDTH-1:0] data_out;
 
  tvs_ulpi_intf ulpi_if(clock);

  tvs_usb_ulpi_passive_device#(0,USB_DATA_WIDTH,"env") i_tvs_usb_ulpi_passive_device(
                               //clock,
                               //dir,
                               //nxt,
                               //stp,
                               //data_in,
                               //data_out
                              );
  tvs_usb_ulpi_host#(0,USB_DATA_WIDTH,"env") i_tvs_usb_ulpi_host(
                           // clock,
                           // dir,
                          //  nxt,
                          //  stp,
                          //  data_in,
                          //  data_out
                            );
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.clock=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_clock;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.reset=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_reset;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.dir=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_dir;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.nxt=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_next;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.stp=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_stop;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.data_in=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_data_i;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_passive_device.data_out=$root.tvs_usb2_device_top.axi_usb_inst.DUT.ulpi_data_o;

 
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.clock            =$root.tvs_usb2_device_top.axi_usb_inst.clk_60m;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.reset            =$root.tvs_usb2_device_top.axi_usb_inst.ulpi_reset;
  assign $root.tvs_usb2_device_top.axi_usb_inst.ulpi_dir                =$root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.dir;
  assign $root.tvs_usb2_device_top.axi_usb_inst.ulpi_next               =$root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.nxt;
  assign $root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.data_in          =$root.tvs_usb2_device_top.axi_usb_inst.ulpi_data_o;
  assign $root.tvs_usb2_device_top.axi_usb_inst.ulpi_data_i             =$root.tvs_usb2_device_top.i_tvs_usb_ulpi_host.data_out;
  initial 
    begin
      run_test("");
    end


    `ifdef QUESTA_DUMP
    initial begin
      $dumpfile ("vsim.vcd");
      $dumpvars (0,tvs_usb2_device_top);
      $dumpvars (0,tvs_usb2_device_top.ulpi_if);
    end
  `endif // QUESTA_DUMP

  //-----------------------------------------------------------------------------
  // Dumping information for generation trn file 
  //-----------------------------------------------------------------------------
  `ifdef CADENCE_DUMP
    initial begin
      $recordfile("tvs_usb2_device_top_dump.trn");
      $recordvars; 
    end
  `endif // CADENCE_DUMP

  always
    #10 clock = ~clock;

endmodule

`endif
