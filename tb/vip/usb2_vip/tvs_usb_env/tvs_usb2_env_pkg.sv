//////////////////////////////////////////////////////////////////////////////
//  Contents:
//    File for the list of ENV Files    
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

package tvs_usb2_env_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import tvs_usb2_device_slave_pkg::*;   //importing all the files realated to Slave agent
  import tvs_usb2_host_pkg::*;
  `include "tvs_usb2_top_defines.svh" 
  `include "tvs_usb2_env_config.svh"
  `include "tvs_usb2_virtual_sequencer.svh"
  `include "tvs_usb2_env.svh"
///////////////////////////////////////////////////////////////////////////////
endpackage : tvs_usb2_env_pkg

