class wb_slave_sequencer extends uvm_sequencer#(wb_slave_sequence_item);

  `uvm_component_utils(wb_slave_sequencer)

  function new(string name = "wb_slave_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass
