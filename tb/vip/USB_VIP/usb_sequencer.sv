class usb_sequencer extends uvm_sequencer#(usb_packet);
  `uvm_component_utils(usb_sequencer)
  function new(string name="usb_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
