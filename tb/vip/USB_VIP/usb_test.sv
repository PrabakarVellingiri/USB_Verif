//test is written by extending the uvm_test
`include "uvm_macros.svh"
import uvm_pkg::*;
class usb_model_test extends uvm_test;
  
  
   usb_model_env my_env;
   ack_sts_seq ack_seq;
   nak_sts_seq nak_seq;
   stall_sts_seq stall_seq;
   zero_length_data1_seq zseq;
   control_dev_data_8b_seq control_8b_seq;
   control_dev_data_18b_seq control_18b_seq;
   control_config_data_9b_seq control_9b_seq;
   control_config_data_39b_seq control_39b_seq;

   bulk_data_seq bseq;
   interrupt_data_seq int_seq;
   isoch_data_seq iso_seq;
 
  `uvm_component_utils(usb_model_test)

// Declare env and sequence  
/*   usb_model_env my_env;

   ack_sts_seq ack_seq;
   nak_sts_seq nak_seq;
   stall_sts_seq stall_seq;
   zero_length_data1_seq zseq;
   bulk_data_seq bseq;
   control_dev_data_8b_seq control_8b_seq;
   control_dev_data_18b_seq control_18b_seq;
   control_config_data_9b_seq control_9b_seq;
   control_config_data_39b_seq control_39b_seq;
   interrupt_data_seq int_seq;
   isoch_data_seq iso_seq;*/
  
// Constructor  
  function new(string name = "usb_model_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

// build_phase - create env and sequence   
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    my_env = usb_model_env::type_id::create("my_env", this);

    ack_seq = ack_sts_seq::type_id::create("ack_seq",this);
    nak_seq = nak_sts_seq::type_id::create("nak_seq",this);
    stall_seq = stall_sts_seq::type_id::create("stall_seq",this);
    zseq = zero_length_data1_seq::type_id::create("zseq",this);
    bseq = bulk_data_seq::type_id::create("bseq",this);
    control_8b_seq = control_dev_data_8b_seq::type_id::create("control_8b_seq",this);
   control_18b_seq = control_dev_data_18b_seq::type_id::create("control_18b_seq",this);
   control_9b_seq = control_dev_data_8b_seq::type_id::create("control_9b_seq",this);
    control_39b_seq = control_dev_data_39b_seq::type_id::create("control_39b_seq",this);
    int_seq = interrupt_data_seq::type_id::create("int_seq",this);
    iso_seq = isoch_data_seq::type_id::create("int_seq",this);
  endfunction : build_phase
  
   virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass

//start sequence  
 /* task run_phase(uvm_phase phase);
    uvm_top.print_topology(printer);
    uvm_report_info(get_type_name(),$sformatf("in TEST RUN PHASE"),UVM_MEDIUM);
  endtask : run_phase*/
  
class ack_sts_seq_test extends usb_model_test;
     `uvm_component_utils(ack_sts_seq_test)

  function new(string name = "ack_sts_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      ack_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask
endclass

class nak_sts_seq_test extends usb_model_test;
     `uvm_component_utils(ack_sts_seq_test)

    function new(string name = "nak_sts_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      nak_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
  
class stall_sts_seq_test extends usb_model_test;
     `uvm_component_utils(ack_sts_seq_test)

    function new(string name = "stall_sts_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
     stall_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
  class zero_length_data1_seq_test extends usb_model_test;
  `uvm_component_utils(zero_length_data1_seq_test)

  function new(string name = "zero_length_data1_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      zseq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
  
class bulk_data_seq_test extends usb_model_test;
  
  `uvm_component_utils(bulk_data_seq_test)

  function new(string name = "bulk_data_seq_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      bseq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass

class control_dev_data_8b_seq_test extends usb_model_test;
     `uvm_component_utils( control_dev_data_8b_seq_test)

  function new(string name = " control_dev_data_8b_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
     control_8b_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass


class control_dev_data_18b_seq_test extends usb_model_test;
     `uvm_component_utils( control_dev_data_18b_seq_test)

  function new(string name = " control_dev_data_18b_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
     control_18b_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass

class control_config_data_9b_seq_test extends usb_model_test;
     `uvm_component_utils(control_config_data_9b_seq_test)

  function new(string name = " control_config_data_9b_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
     control_9b_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass

class control_config_data_39b_seq_test extends usb_model_test;
     `uvm_component_utils(control_config_data_39b_seq_test)

  function new(string name = "control_config_data_39b_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
     control_39b_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
 


  
   class interrupt_data_seq_test extends usb_model_test;
  `uvm_component_utils(interrupt_data_seq_test)

  function new(string name = "interrupt_data_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      int_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
  
   class isoch_data_seq_test extends usb_model_test;
     `uvm_component_utils(isoch_data_seq_test)

  function new(string name = "isoch_data_seq_test",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual task run_phase(uvm_phase phase);
    begin
      phase.raise_objection(this);
      iso_seq.start(my_env.my_agent.sequencer);
      phase.drop_objection(this);
    end
  endtask

endclass
 


