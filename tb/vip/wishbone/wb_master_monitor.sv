class wb_master_monitor extends uvm_monitor;
  `uvm_component_utils(wb_master_monitor)
  
  uvm_analysis_port #(wb_master_sequence_item) mas_mon_scb;
    
  wb_master_sequence_item trans_collected;
  
  virtual wb_interface vif;
  
  function new(string name="wb_master_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    if(!(uvm_config_db#(virtual wb_interface)::get(this,"","w_vif",vif)))
      begin
        `uvm_fatal("No vif",$sformatf("No vif in config db"))
      end
    mas_mon_scb = new("mas_mon_scb", this);
    trans_collected=wb_master_sequence_item::type_id::create("trans_collected");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever 
      begin
      @(posedge vif.CLK_I)
        if(vif.ACK_O==1'b1)
          begin
      trans_collected.ACK_I=vif.ACK_O;
      trans_collected.ADR_O=vif.ADR_O;
      trans_collected.DAT_O=vif.DAT_O;
      trans_collected.WE_O=vif.WE_O;
      trans_collected.SEL_O=vif.SEL_O;
      trans_collected.STB_O=vif.STB_O;
      trans_collected.CYC_O=vif.CYC_O; 
        trans_collected.DAT_I=vif.DAT_I;
      mas_mon_scb.write(trans_collected);
           // `uvm_info(get_type_name(),$sformatf("wr_rd=%b, ADR_O=%h, DAT_O=%h DAT_I=%h",trans_collected.WE_O,trans_collected.ADR_O,trans_collected.DAT_O,trans_collected.DAT_I),UVM_LOW);
          end
    end
  endtask

endclass


