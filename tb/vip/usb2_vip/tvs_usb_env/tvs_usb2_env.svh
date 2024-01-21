//============================================================================
//  CONFIDENTIAL and Copyright (C) 2010 Test and Verification Solutions Ltd
//============================================================================
//  Contents                  : File for tvs_usb2_env.svh
//
//  Brief description         : uvm environment file contians all the components of testbench
//
//  Known exceptions to rules :
//
//============================================================================
//  Author        :
//  Created on    :
//  File Id       : tvs_usb2_env.svh
//============================================================================

`ifndef TVS_USB2_ENV_SVH
`define TVS_USB2_ENV_SVH

class tvs_usb2_env#(int DATA_WIDTH_SLV=8) extends uvm_env;

  // Instantiation of the Number of USB env.
  protected int unsigned no_usb_env = 0;
  // Instantiation of the Number of USB device
  protected int unsigned no_usb_device  = 0;
  // Instantiation of the Number of USB host
  protected int unsigned no_usb_host  = 0;

  // Instance of environment configuration
  tvs_usb2_env_config env_config;
  //Instance of device agent configuration
  tvs_usb2_device_agent_config device_cfg;
  //Instance of host_agent configuration
  tvs_usb2_host_agent_config host_cfg;
  // Instance of  device agent
  tvs_usb2_device_agent#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV)) device_agent[];
  // Instance of host agent
  tvs_usb2_host_agent#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV))   host_agent[];

  `uvm_component_param_utils_begin(tvs_usb2_env#(DATA_WIDTH_SLV))
    `uvm_field_object(env_config,UVM_ALL_ON)
    `uvm_field_int(no_usb_env,UVM_ALL_ON)
    `uvm_field_int(no_usb_device,UVM_ALL_ON)
    `uvm_field_int(no_usb_host,UVM_ALL_ON)
    `uvm_field_object (env_config,         UVM_DEFAULT)
  `uvm_component_utils_end

  ////////////////////////////////////////////////////////////////////////////////
  // method name         : new
  // description         : Default new constructor 
  ////////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction: new

  ////////////////////////////////////////////////////////////////////////////////
  // FUNCTION: build_phase()
  // Factory build phase
  // Get configuration settings for virtual interfaces
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);
    if(!uvm_config_db#(tvs_usb2_env_config)::get(this,"","env_config",env_config))
    `tvs_fatal("NOVIF",{"",get_full_name(),".env_config"})
   // `tvs_debug(get_full_name(),"\n\n BUILDING TVS UVM ENV\n\n ");
    env_config.print(); 
    // Assigning Environment config Values to Local Fields
    no_usb_device  = env_config.no_usb_device;
    no_usb_host    = env_config.no_usb_host;
    $display(" no_usb_device :%h",no_usb_device);
    $display(" no_usb_host : %0h",no_usb_host);
    ///////////////////////////////////////////////////////////////////
    ////////////////////// DEVICE AGENT CREATION ///////////////////////
    ///////////////////////////////////////////////////////////////////
    // creating the size of the device agent
    device_agent = new[no_usb_device];
     
    for(int i = 0; i < no_usb_device; i++) begin
      $sformat(inst_name,"device_agent[%0d]",i);
      //creates no of USB Device agents
      device_agent[i] = tvs_usb2_device_agent#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV))::type_id::create(inst_name, this);
      device_agent[i].device_cfg = new();
      device_agent[i].device_cfg = env_config.device_agent_config[i];
    end
    ////uvm_config_db#(tvs_usb2_device_agent_config)::set(null,"*","device_cfg",device_cfg);
    /////////////////////////////////////////////////////////////////////
    ///////////////////////HOST AGENT CREATION ///////////////////////
    /////////////////////////////////////////////////////////////////////
    //// creating the host agent size
    host_agent = new[no_usb_host];
    for(int i = 0; i < no_usb_host; i++) begin
      $sformat(inst_name,"host_agent[%0d]",i);
    // create the agent
    host_agent[i] = tvs_usb2_host_agent#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV))::type_id::create(inst_name,this);
    host_agent[i].host_cfg = new();
    host_agent[i].host_cfg = env_config.host_agent_config[i];
    end
    ////uvm_config_db#(tvs_usb2_host_agent_config)::set(null,"*","host_cfg",host_cfg);
  endfunction: build_phase
  /////////////////////////////////////////////////////////////////////////////////
  // Method name         : connect_phase
  // Description         :  
  //////////////////////////////////////////////////////////////////////////////////
  virtual function void connect_phase(uvm_phase phase);
    tvs_usb2_device_sequencer#(DATA_WIDTH_SLV) device_sequencer;
    tvs_usb2_device_monitor#(DATA_WIDTH_SLV)   device_monitor;
    tvs_usb2_device_driver#(DATA_WIDTH_SLV)    device_driver;
    tvs_usb2_host_sequencer#(DATA_WIDTH_SLV)   host_sequencer;
    tvs_usb2_host_monitor#(DATA_WIDTH_SLV)     host_monitor;
    tvs_usb2_host_driver#(DATA_WIDTH_SLV)      host_driver;
    super.connect_phase(phase);
    foreach (device_agent[i]) begin
      if(device_agent[i].sequencer != null ) begin
         assert($cast(device_monitor,   device_agent[i].monitor));
         assert($cast(device_sequencer, device_agent[i].sequencer));
         assert($cast(device_driver, device_agent[i].driver));
         device_sequencer.device_monitor = device_monitor;
         device_driver.monitor = device_monitor;
      end
    end

    foreach (host_agent[i]) begin
      if(host_agent[i].sequencer != null ) begin
         assert($cast(host_monitor,   host_agent[i].monitor));
         assert($cast(host_sequencer, host_agent[i].sequencer));
         assert($cast(host_driver, host_agent[i].driver));
         host_sequencer.host_monitor = host_monitor;
      end
    end
  endfunction : connect_phase


endclass : tvs_usb2_env

`endif // TVS_USB2_ENV_SVH



