//============================================================================
//  CONFIDENTIAL and Copyright (C) 2014 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    File for tvs_usb2_host_agent_config class
//
//  Brief description:
//    This is the USB2 slave config
//    
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================


`ifndef TVS_USB2_HOST_AGENT_CONFIG_SVH
`define TVS_USB2_HOST_AGENT_CONFIG_SVH

class tvs_usb2_host_agent_config extends uvm_object;

 // For mounting off the sequencer and driver
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  // Disable driver
  int has_driver = 1;
  // Disable Scoreboard 
  int has_checker = 1;
  // Disable Monitor
  int has_monitor = 1;
  // Declaring handle for ULPI virtual interface
  //virtual tvs_ulpi_intf tvs_ulpi_dev_if;

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////Registration of the Component///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration 
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  ////////////////////////////////////////////////////////////////////////////////
  `uvm_object_utils_begin(tvs_usb2_host_agent_config)
    `uvm_field_int  (has_driver, UVM_ALL_ON)
    `uvm_field_int  (has_checker, UVM_ALL_ON)
    `uvm_field_int  (has_monitor, UVM_ALL_ON)
    `uvm_field_enum (uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_object_utils_end  

  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : new 
  // Description         : Default new constructor  
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_usb2_host_agent_config");
    super.new(name);
  endfunction: new
  ////////////////////////////////////////////////////////////////////////////////


  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : clone 
  // Description         : clone the object  
  ////////////////////////////////////////////////////////////////////////////////
  virtual function uvm_object clone();
    return this;
  endfunction : clone
  ////////////////////////////////////////////////////////////////////////////////

endclass

`endif // TVS_USB2_HOST_AGENT_CONFIG_SVH

