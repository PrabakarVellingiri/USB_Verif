//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    Header for tvs_usb2_ulpi_test class
//
//  Brief description: 
//    This is an arbiter, which arbitrates the list of sequence been
//    registered to this respective sequencer 
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================

`ifndef TVS_USB2_ULPI_TEST_SVH
`define TVS_USB2_ULPI_TEST_SVH

class tvs_usb2_ulpi_test extends uvm_test;

  parameter DATA_WIDTH_SLV=8;
  //int DATA_WIDTH_SLV = 8;
  //Instance of environment
  tvs_usb2_env#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV)) env;
  //Instance of environment config
  tvs_usb2_env_config env_config;
  // Printer settings for display of the output in the table format
  uvm_table_printer printer;
  //Instance of virtual sequencer
  tvs_usb2_virtual_sequencer#(.DATA_WIDTH(DATA_WIDTH_SLV)) usb2_virtual_sequencer;

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////Registration of the Component  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration
  // description         :  Provide implementations of virtual methods such as
  //                        get_type_name and create
  ////////////////////////////////////////////////////////////////////////////////

  `uvm_component_utils(tvs_usb2_ulpi_test)

  ////////////////////////////////////////////////////////////////////////////////
  /////////////////////////Declaration of the Methods  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         : new
  // description         : Default new constructor
  ////////////////////////////////////////////////////////////////////////////////
  function new(string name = "tvs_usb2_ulpi_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  ////////////////////////////////////////////////////////////////////////////////
  // FUNCTION: build_phase()
  // Factory build phase
  // Get configuration settings for virtual interfaces
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // create the object for the axi config
    env_config = new();
    env_config.no_usb_device = 1 ;
    env_config.no_usb_host= 1 ;
    env_config.device_agent_config = new[env_config.no_usb_device];
    env_config.host_agent_config = new[env_config.no_usb_host];

    for(int i = 0 ; i < env_config.no_usb_device ; i++) begin
        env_config.device_agent_config[i] = new("device_agent_config");
        env_config.device_agent_config[i].is_active = UVM_PASSIVE;
    end
        
    for(int i = 0 ; i < env_config.no_usb_host; i++)
        env_config.host_agent_config[i] = new("host_agent_config");
    //env creation
    env=tvs_usb2_env#(.DATA_WIDTH_SLV(DATA_WIDTH_SLV))::type_id::create("env",this);
    // set environment confiuration objects
    uvm_config_db #(tvs_usb2_env_config)::set( null , "*" , "env_config",env_config);
    //Virtual sequence creation  
    usb2_virtual_sequencer=tvs_usb2_virtual_sequencer#(.DATA_WIDTH(DATA_WIDTH_SLV))::type_id::create("usb2_virtual_sequencer",this);

   printer = new();
   printer.knobs.depth = 10;
        

  endfunction
  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : connect_phase
  // Description         : 
  ////////////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
    ///////////////////////////////////////////////////////////////////
    ///////////////// VIRTUAL SEQUENCER CONNECTIONS ///////////////////
    ///////////////////////////////////////////////////////////////////

    for(int i = 0; i < env_config.no_usb_device; i++) begin
      usb2_virtual_sequencer.v_device_sequencer[i] = env.device_agent[i].sequencer;
    end
    for(int i = 0; i < env_config.no_usb_host; i++) begin
      usb2_virtual_sequencer.v_host_sequencer[i] = env.host_agent[i].sequencer;
    end
  endfunction : connect_phase


  ////////////////////////////////////////////////////////////////////////////////
  // Task name           : run_phase
  // Description         : Use to start the transactor.
  ////////////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    uvm_top.print_topology();
    #50000000;
    phase.drop_objection(this);

  endtask : run_phase
  ////////////////////////////////////////////////////////////////////////////////

endclass

`endif
