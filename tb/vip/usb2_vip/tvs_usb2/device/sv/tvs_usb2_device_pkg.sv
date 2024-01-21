//////////////////////////////////////////////////////////////////////////////
//  Contents:
//    File for the list of SLAVE Files    
//
//  Brief description: 
//    This files contains the list of files in SLAVE Environment.
//      
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       :
//============================================================================
////////////////////////////////////////////////////////////////////////////////

package tvs_usb2_device_slave_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  //`include "tvs_usb2_device_top_defines.svh"
  ///////SLAVE VIP FILES////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  `include "tvs_usb2_defines.svh" 
  `include "tvs_usb2_device_agent_config.svh" 
  `include "tvs_usb2_device_sequence_item.svh"
  `include "tvs_usb2_device_monitor.svh"
  `include "tvs_usb2_device_driver.svh"
 // `include "tvs_usb2_device_monitor.svh"
  `include "tvs_usb2_device_sequencer.svh"
  //`include "tvs_usb2_device_slave_sequence_lib.svh"
  `include "tvs_usb2_device_agent.svh"
  `include "tvs_usb2_device_test.svh"
///////////////////////////////////////////////////////////////////////////////
endpackage
