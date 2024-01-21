///////////////////////////////////////////////////////////////////////////////
//  Contents:
//    tvs_ulpi_intf inteface file
//
//  Brief description: 
//    This contains the list of signals which are used in USB2 device 
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================
///////////////////////////////////////////////////////////////////////////////

`ifndef TVS_ULPI_INTF_SVH
`define TVS_ULPI_INTF_SVH

interface tvs_ulpi_intf#(int ULPI_DATA_WIDTH = 8)(input clock);

  // Timing Information
  timeunit 1ns;
  timeprecision 1ps;
  parameter data_width = ULPI_DATA_WIDTH;
  
  logic                     reset;
  //Direction Signal Used to indicate Transaction from PHY/Link
  logic                       dir;
  //STP Signal Used to indicate Last data  
  logic                       stp;
  //nxt signal Used to indicate data throttle
  logic                       nxt;
  //Data_in used collect the Data
  logic [data_width-1:0] data_in;
  //Data_in used transfer the Data
  logic [data_width-1:0] data_out;
  
  //Clocking block for host
  clocking host_cb @(posedge clock);
    input reset;
    input  stp;
    input  data_in;
    output dir;
    output data_out;
    output nxt;
  endclocking
  
  //Clocking block for monitor
  clocking monitor_cb @(posedge clock);
    input stp;
    input data_in;
    input dir;
    input nxt;
    input data_out;
  endclocking   


endinterface:tvs_ulpi_intf
`endif // TVS_ULPI_INTF_SVH
