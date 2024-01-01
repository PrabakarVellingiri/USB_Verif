import uvm_pkg::*;
`include "uvm_macros.svh"

class usb_agent extends uvm_agent;//instatiate all the three 
  //declaring agent components
  usb_driver    driver;
  usb_sequencer sequencer;
  usb_monitor   monitor;
 
  // UVM automation macros for general components
  `uvm_component_utils(usb_agent)
 
  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
   // if(get_is_active() == UVM_ACTIVE) begin
      driver = usb_driver::type_id::create("driver", this);
      sequencer = usb_sequencer::type_id::create("sequencer", this);
   // end
 
    monitor = usb_monitor::type_id::create("monitor", this);
  endfunction : build_phase
 
  // connect_phase
  function void connect_phase(uvm_phase phase);
    //if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
   // end 
  endfunction : connect_phase
 
endclass : usb_agent

