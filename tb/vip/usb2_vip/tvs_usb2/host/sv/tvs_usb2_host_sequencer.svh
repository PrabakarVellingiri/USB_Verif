///////////////////////////////////////////////////////////////////////////////
//  Contents:
//    Header for tvs_usb2_host_sequencer class
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
///////////////////////////////////////////////////////////////////////////////


`ifndef TVS_USB2_HOST_SEQUENCER_SVH
`define TVS_USB2_HOST_SEQUENCER_SVH

class tvs_usb2_host_sequencer#(int DATA_WIDTH_SLV =8) extends uvm_sequencer #(tvs_usb2_host_sequence_item#(DATA_WIDTH_SLV));

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////Declaration of variables////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // config class
  tvs_usb2_host_agent_config slave_cfg;
  //Instance of monitor
  tvs_usb2_host_monitor host_monitor;
  ////////////////////////////////////////////////////////////////////////////////
  /////////////////////Registration of the Component ////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // method name         :  Factory Registration 
  // description         :  Provide implementations of virtual methods such as 
  //                        get_type_name and create 
  //////////////////////////////////////////////////////////////////////////////// 
  `uvm_sequencer_utils_begin(tvs_usb2_host_sequencer#(DATA_WIDTH_SLV))
     `uvm_field_object(slave_cfg, UVM_ALL_ON)
  `uvm_sequencer_utils_end
  //////////////////////////////////////////////////////////////////////////////// 
  
  ////////////////////////////////////////////////////////////////////////////////
  // method name         : new
  // description         : This is a constructor for tvs_usb2_host_sequencer
  ////////////////////////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TVS_USB2_DEVICE_SLAVE_SEQUENCER-NEW", $psprintf("Building the SLAVE Sequencer\n"),UVM_MEDIUM)
  endfunction : new
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////Build Phase////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // Method name         : build_phase 
  // Description         :   
  ////////////////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase
  ////////////////////////////////////////////////////////////////////////////////

endclass : tvs_usb2_host_sequencer

`endif 
