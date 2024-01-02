class usb_core_base_virtual_sequence extends uvm_sequence#(wb_master_sequence_item,usb_sequence_item);
  
  `uvm_object_utils(usb_core_base_virtual_sequence)
  `uvm_declare_p_sequencer(usb_core_virtual_sequencer)
  
  function new (string name = "usb_core_base_virtual_sequence");
    super.new(name);
  endfunction
  
  wb_master_sequencer w_m_sqncr;
  usb_sequencer u_sqncr;
  
  wb_mas_write_seq wb_wr_sqnce;
  wb_mas_read_seq wb_rd_sqnce;
  
  task pre_body();
    wb_wr_sqnce=wb_mas_write_sqnce::type_id::create("wb_wr_sqnce");
    wb_rd_sqnce=wb_mas_read_sqnce::type_id::create("wb_rd_sqnce");
  endtask
  
endclass


