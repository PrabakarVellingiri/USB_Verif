class usb_core_base_test extends uvm_test;
  
  `uvm_component_utils(usb_core_base_test)
  
  usb_core_environment env;
  
  v_reg_reset_read_sqnce v_reg_rst_rd_sqnce;
  v_reg_write_read_sqnce v_reg_wr_rd_sqnce;
  
  function new(string name = "usb_core_base_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase();
    env=usb_core_environment::type_id::create("env",this);
    v_reg_wr_rd_sqnce=v_reg_write_read_sqnce::type_id::create("v_reg_wr_rd_sqnce",this);
    v_reg_rst_rd_sqnce=v_reg_reset_read_sqnce::type_id::create("v_reg_rst_rd_sqnce",this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass


