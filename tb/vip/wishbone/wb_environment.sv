class wb_environment extends uvm_env;
  
  `uvm_component_utils(wb_environment)
  
  wb_master_agent ag_m;
  wb_slave_agent ag_s;
  //wb_scoreboard scb;
  
  
  function new(string name="wb_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag_m=wb_master_agent::type_id::create("ag_m",this);
    ag_s=wb_slave_agent::type_id::create("ag_s",this);
    //scb=wb_scoreboard::type_id::create("scb",this); 
  endfunction
  
  /*virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ag_m.mon.mas_mon_scb.connect(scb.fifo_wb_master.analysis_export); 
    //ag_s.slv_mon.slv_mon_scb.connect(scb.fifo_wb_slave.analysis_export); 
  endfunction*/
  
endclass

