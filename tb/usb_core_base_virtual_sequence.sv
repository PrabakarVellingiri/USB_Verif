class usb_core_base_virtual_sequence extends uvm_sequence#(wb_master_sequence_item,usb_packet);
  
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
    wb_wr_sqnce=wb_mas_write_seq::type_id::create("wb_wr_sqnce");
    wb_rd_sqnce=wb_mas_read_seq::type_id::create("wb_rd_sqnce");
  endtask
  
endclass

class v_reg_reset_read_sqnce extends usb_core_base_virtual_sequence;
  
  `uvm_object_utils(v_reg_reset_read_sqnce)
  
  function new(string name = "v_reg_reset_read_sqnce");
    super.new(name);
  endfunction
  
  
  task body();
    begin
      wb_rd_sqnce.start(p_sequencer.wb_sqncr);
      //in driver we can fetch the read values during reset and in scoreboard it can be checked by comparing the read values and defualt register values
    end
  endtask
  
endclass

class v_reg_write_read_sqnce extends usb_core_base_virtual_sequence;
  
  `uvm_object_utils(v_reg_write_read_sqnce)
  
  function new(string name = "v_reg_write_read_sqnce");
    super.new(name);
  endfunction
  
  task body();
    begin   
      wb_wr_sqnce.start(p_sequencer.wb_sqncr);
      #10
      wb_rd_sqnce.start(p_sequencer.wb_sqncr);
    end
  endtask
  
endclass



