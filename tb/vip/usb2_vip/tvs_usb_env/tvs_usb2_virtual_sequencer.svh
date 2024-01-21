//============================================================================
//  CONFIDENTIAL and Copyright (C) 2015 Test and Verification Solutions Ltd
//============================================================================
//  Contents:
//    File for tvs_axi_virtual_sequencer class
//
//  Brief description: 
//    This is the Top Virtual Sequencer which have the top level control other the
//    sub-sequencer
//
//  Known exceptions to rules:
//    
//============================================================================
//  Author        : 
//  Created on    : 
//  File Id       : 
//============================================================================


`ifndef TVS_USB2_VIRTUAL_SEQUENCER_SVH
`define TVS_USB2_VIRTUAL_SEQUENCER_SVH

class tvs_usb2_virtual_sequencer#(int DATA_WIDTH = 8) extends uvm_sequencer;

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////Declaration of variables////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////

  // Instantiation of the  Virtual Interface
  virtual tvs_ulpi_intf ulpi_if; 

  // Instantiation of the USB2 Device  Sequencer
  tvs_usb2_device_sequencer#(.DATA_WIDTH_SLV(DATA_WIDTH))  v_device_sequencer[$];

  // Instantiation of the USB2 Host Sequencer
  tvs_usb2_host_sequencer#(.DATA_WIDTH_SLV(DATA_WIDTH))  v_host_sequencer[$];


  ////////////////////////////////////////////////////////////////////////////////
  //////////////////////Registration of the variables  ///////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  ////////////////////////////////////////////////////////////////////////////////
  `uvm_sequencer_param_utils(tvs_usb2_virtual_sequencer#(DATA_WIDTH))
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : new 
  // Description         : Default new constructor  
  ////////////////////////////////////////////////////////////////////////////////
  function new(input string name = "tvs_usb2_virtual_sequencer", input uvm_component parent = null);
    super.new(name,parent);
    `tvs_debug("TVS_USB2_VIRTUAL_SEQUENCER", $psprintf("Building the Top Virtual Sequencer\n"))
  endfunction: new
  ////////////////////////////////////////////////////////////////////////////////

endclass: tvs_usb2_virtual_sequencer

`endif // TVS_USB2_VIRTUAL_SEQUENCER_SVH

//============================================================================


