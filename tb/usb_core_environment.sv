class usb_core_environment extends uvm_env;
  `uvm_component_utils(usb_core_environment)
  
     usb_agent usb_agt;
     wb_master_agent wsb_agt;
     usb_core_scoreboard usb_core_scb;
     usb_core_virtual_sequencer v_sqncr;
  
  function new(string name = "usb_core_environment",uvm_component parent);
    super.new(name,parent);
   endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    usb_agt = usb_agent::type_id::create("utmi_agt",this);
    wsb_agt = wb_master_agent::type_id::create("wsb_agt",this);
    usb_core_scb = usb_core_scoreboard::type_id::create("usb_core_scb",this);
    v_sqncr = usb_core_virtual_sequencer::type_id::create("v_sqncr",this);
  endfunction
  
   virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     //usb_agt.monitor.utmi_monitor_port.connect(utmi_wsb_scr.fifo_utmi.analysis_export);
     wsb_agt.mon.mas_mon_scb.connect(usb_core_scb.scb_get_port);
     v_sqncr.usb_sqncr = usb_agt.sequencer;
     v_sqncr.wb_sqncr = wsb_agt.sqncr;
   endfunction

endclass
