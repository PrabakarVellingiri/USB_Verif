class wb_master_sequence_item extends uvm_sequence_item;
  rand bit [14:0] ADR_O;
  rand bit [31:0] DAT_O;
  rand bit        WE_O;
  rand bit [3:0]  SEL_O;
  rand bit        STB_O;
  rand bit        CYC_O;
       bit [31:0] DAT_I;
       bit        ACK_I;
  
  `uvm_object_utils_begin(wb_master_sequence_item)//factory registration
  `uvm_field_int(ADR_O,UVM_DEFAULT)//Using feild macro
  `uvm_field_int(DAT_O,UVM_DEFAULT)
  `uvm_field_int(WE_O,UVM_DEFAULT)
  `uvm_field_int(SEL_O,UVM_DEFAULT)
  `uvm_field_int(STB_O,UVM_DEFAULT)
  `uvm_field_int(CYC_O,UVM_DEFAULT)
  `uvm_field_int(DAT_I,UVM_DEFAULT)
  `uvm_field_int(ACK_I,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new(string name="wb_master_sequence_item");
    super.new(name);
  endfunction
  
    
endclass
