class v_reg_reset_read_sqnce extends usb_core_base_virtual_sequence;
  
  `uvm_object_utils(v_reg_reset_read_sqnce)
  
  function new(string name = "v_reg_reset_read_sqnce");
    super.new(name);
  endfunction
  
  
  task body();
    begin
      wb_rd_sqnce.start(p_sequencer.w_m_sqncr);
      //in driver we can fetch the read values during reset and in scoreboard it can be checked by comparing the read values and defualt register values
    end
  endtask
  
endclass

class usb_core_reg_reset_read_test extends usb_core_base_test;
  
  `uvm_component_utils(usb_core_reg_reset_read_test)
  
  function new(string name = "usb_core_reg_reset_read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      v_reg_rst_rd_sqnce.start(env.v_sqncr);
      phase.drop_objection(this);
    end
  endtask
endclass
