class wb_slave_agent extends uvm_agent;
     
  `uvm_component_utils(wb_slave_agent)

   wb_slave_sequencer slv_sqncr;
   wb_slave_driver slv_driv;
   //wb_slave_monitor slv_mon;

  function new(string name = "wb_slave_agent",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(get_is_active() == UVM_ACTIVE)
        begin
          slv_sqncr = wb_slave_sequencer::type_id::create("slv_sqncr",this);    
          slv_driv = wb_slave_driver::type_id::create("slv_driv",this);    
        end
     //slv_mon = wb_slave_monitor::type_id::create("slv_mon",this);    
   endfunction

   virtual function void connect_phase(uvm_phase phase);
     $display("wb_slave_agent");
      super.connect_phase(phase);
     slv_driv.seq_item_port.connect(slv_sqncr.seq_item_export);
   endfunction

endclass


