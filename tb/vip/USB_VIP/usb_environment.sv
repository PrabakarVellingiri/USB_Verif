import uvm_pkg::*;
`include "uvm_macros.svh"

class usb_model_env extends uvm_env;
 
  usb_agent      my_agent;
 // usb_scoreboard usb_scb;
   
  `uvm_component_utils(usb_model_env)
   
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    my_agent = usb_agent::type_id::create("my_agent", this);
   // usb_scb  = usb_scoreboard::type_id::create("usb_scb", this);
  endfunction : build_phase
   
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
 /* function void connect_phase(uvm_phase phase);
    my_agent.monitor.mon2scr.connect(usb_scb.fifo_export.
               analysis_export);  endfunction : connect_phase*/
 
endclass 

