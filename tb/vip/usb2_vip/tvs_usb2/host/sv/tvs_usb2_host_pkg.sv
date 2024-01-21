//////////////////////////////////////////////////////////////////////////////
//  Contents:
//    File for the list of HOST Files    
//
//  Brief description: 
//    This files contains the list of files in Host Environment.
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

package tvs_usb2_host_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  //`include "tvs_usb2_host_top_defines.svh"
  ///////SLAVE VIP FILES////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  `include "tvs_usb2_host_agent_config.svh" 
  `include "tvs_usb2_host_defines.svh" 
  `include "tvs_usb2_host_sequence_item.svh"
  `include "tvs_usb2_host_driver.svh"
  `include "tvs_usb2_host_monitor.svh"
  `include "tvs_usb2_host_sequencer.svh"
  `include "tvs_usb2_host_sequence_lib.svh"
  `include "tvs_usb2_host_agent.svh"
//  `include "tvs_usb2_ulpi_test.svh"
///////////////////////////////////////////////////////////////////////////////
endpackage
