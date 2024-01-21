//============================================================================
//  CONFIDENTIAL and Copyright (C) 2010 Test and Verification Solutions Ltd
//============================================================================
//  Contents                  : File for tvs_usb2_env_config.svh
//
//  Brief description         : which configures no. of agents in the environment 
//   
//  Known exceptions to rules :
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : tvs_usb2_env_config.svh
//============================================================================

`ifndef TVS_USB2_ENV_CONFIG_SVH
`define TVS_USB2_ENV_CONFIG_SVH

class tvs_usb2_env_config extends uvm_object;

  // Instantiation of the Number  of env 
  int unsigned no_usb_env = 1;
  // Instantiation of the Number of USB device
  int unsigned no_usb_device  = 1;
  // Instantiation of the Number  of USB host 
  int unsigned no_usb_host  = 1;

  //Instantiation of  host agent configuration
  tvs_usb2_host_agent_config  host_agent_config[];
  //Instance of device agent configuration
  tvs_usb2_device_agent_config  device_agent_config[];

  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration  
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  ////////////////////////////////////////////////////////////////////////////////   
  `uvm_object_utils(tvs_usb2_env_config)
  ////////////////////////////////////////////////////////////////////////////////
  // method name         : new
  // description         : Default new constructor 
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name = "tvs_usb2_env_config");
    super.new(name);
  endfunction: new

endclass : tvs_usb2_env_config


`endif // TVS_USB2_ENV_CONFIG

