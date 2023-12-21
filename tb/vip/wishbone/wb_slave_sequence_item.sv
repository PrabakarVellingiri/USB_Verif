class wb_slave_sequence_item extends uvm_sequence_item;
  bit [31:0] DAT_O;
  bit [31:0] DAT_I;
       bit [14:0] ADR_I;
       bit        WE_I;
       bit [3:0]  SEL_I;
       bit        STB_I;
       bit        ACK_O;
       bit        CYC_I;

  `uvm_object_utils_begin(wb_slave_sequence_item)
  `uvm_field_int(DAT_O, UVM_DEFAULT)
  `uvm_field_int(DAT_I, UVM_DEFAULT)
  `uvm_field_int(ADR_I, UVM_DEFAULT)
  `uvm_field_int(WE_I, UVM_DEFAULT)
  `uvm_field_int(SEL_I, UVM_DEFAULT)
  `uvm_field_int(STB_I, UVM_DEFAULT)
  `uvm_field_int(ACK_O, UVM_DEFAULT)
  `uvm_field_int(CYC_I, UVM_DEFAULT)
  `uvm_object_utils_end
  
  
    function new(string name = "wb_slave_sequence_item ");
        super.new(name);
    endfunction
endclass
