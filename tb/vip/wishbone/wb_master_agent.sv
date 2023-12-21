class wb_master_agent extends uvm_agent;
  `uvm_component_utils(wb_master_agent)
  wb_master_sequencer sqncr;
  wb_master_driver driv;
  wb_master_monitor mon;  
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);   
        mon= wb_master_monitor::type_id::create("mon",this);
        sqncr=wb_master_sequencer::type_id::create("sqncr",this);
        driv=wb_master_driver::type_id::create("driv",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
        driv.seq_item_port.connect(sqncr.seq_item_export);
  endfunction
  
endclass
