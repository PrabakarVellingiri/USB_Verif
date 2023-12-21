class wb_master_sequencer extends uvm_sequencer#(wb_master_sequence_item);
  `uvm_component_utils(wb_master_sequencer)
  
  function new( string name="wb_master_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
