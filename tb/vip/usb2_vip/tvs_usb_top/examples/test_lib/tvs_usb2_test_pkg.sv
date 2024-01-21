//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents                  : File for tvs_usb2_test_pkg.sv
//
//  Brief description         : axi environment file contians all the components of testbench
//   
//  Known exceptions to rules :
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : tvs_usb2_test_pkg.sv
//============================================================================
package tvs_usb2_test_pkg;

  `include "uvm_macros.svh"

  // Import uvm package
  import uvm_pkg::*;
  //Importing all files related device agent
  import tvs_usb2_device_slave_pkg::*;   
  //Importing all files related host agent
  import tvs_usb2_host_pkg::*;
  //Importing env related files
  import tvs_usb2_env_pkg::*;
  
  `include "tvs_usb2_defines.svh"
  //Include test files
  `include "tvs_usb2_ulpi_test.svh"
  `include "tvs_usb2_ulpi_rx_cmd_test.svh"

endpackage
