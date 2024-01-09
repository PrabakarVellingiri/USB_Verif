class usb_core_virtual_sequencer extends uvm_sequencer#(usb_packet,wb_master_sequence_item);
 
  `uvm_component_utils(usb_core_virtual_sequencer)

  function new(string name = "usb_core_virtual_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction

  usb_sequencer usb_sqncr;
  wb_master_sequencer wb_sqncr;

endclass
