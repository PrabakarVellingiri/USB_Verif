class utmi_wsb_environment extends uvm_env;
  `uvm_component_utils(utmi_wsb_environment)
  
     utmi_agent utmi_agt;
     wsb_agent wsb_agt;
     utmi_wsb_scoreboard utmi_wsb_scr;
     utmi_wsb_virtual_sequencer v_sqncr;
  
  function new(string name = "utmi_wsb_environment",uvm_component parent);
    super.new(name,parent);
   endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    utmi_agt = utmi_agent::type_id::create("utmi_agt",this);
    wsb_agt = wsb_agent::type_id::create("wsb_agt",this);
    utmi_wsb_scr = utmi_wsb_scoreboard::type_id::create("utmi_wsb_scr",this);
    v_sqncr = utmi_wsb_virtual_sequencer::type_id::create("v_sqncr",this);
  endfunction
  
   virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     utmi_agt.utmi_mon.utmi_monitor_port.connect(utmi_wsb_scr.fifo_utmi.analysis_export);
     wsb_agt.wsb_mon.wsb_monitor_port.connect(utmi_wsb_scr.fifo_wsb.analysis_export);
     v_sqncr.utmi_sqncr = utmi_agt.utmi_sqncr;
     v_sqncr.wsb_sqncr = wsb_agt.wsb_sqncr;
   endfunction

endclass
