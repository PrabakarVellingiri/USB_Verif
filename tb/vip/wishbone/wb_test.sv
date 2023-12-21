class test extends uvm_test;
  `uvm_component_utils(test)

  wb_mas_write_seq wsqn;
  wb_mas_read_seq rsqn;
  wb_slave_sequence seq;
  wb_environment env;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wsqn = wb_mas_write_seq::type_id::create("wsqn",this);
    rsqn = wb_mas_read_seq::type_id::create("rsqn",this);
    seq =  wb_slave_sequence::type_id::create("seq");
    env = wb_environment::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology(); 
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      wsqn.start(env.ag_m.sqncr);
      seq.start(env.ag_s.slv_sqncr);
    join
    #10
    fork
      rsqn.start(env.ag_m.sqncr);
      seq.start(env.ag_s.slv_sqncr);
    join
      #10;
    phase.drop_objection(this);
  endtask
  
endclass
