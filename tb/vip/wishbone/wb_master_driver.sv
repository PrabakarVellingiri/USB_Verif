class wb_master_driver extends uvm_driver#(wb_master_sequence_item);
  `uvm_component_utils(wb_master_driver)
  
  virtual wb_interface vif;
  
  function new(string name="wb_master_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    if(!(uvm_config_db#(virtual wb_interface)::get(this,"","w_vif",vif)))
      begin
        `uvm_fatal("No vif",$sformatf("No vif in config db"))
      end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      wait(vif.RST_I==1)
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
  
  task drive();
      begin
        @(posedge vif.CLK_I);
        vif.WE_O = req.WE_O;
        vif.ADR_O = req.ADR_O;
        vif.CYC_O = req.CYC_O;
        vif.SEL_O = req.SEL_O;
        vif.STB_O = 1'b1;
        vif.WE_I = vif.WE_O;
        if(req.WE_O==1) 
          begin
            vif.DAT_O = req.DAT_O;
          end
        else if(req.WE_O==0)
          begin
            vif.DAT_O = 0;           
          end
        
        `uvm_info(get_type_name(),$sformatf("wr_rd=%b, ADR_O=%h, DAT_O=%h DAT_I=%h",vif.WE_O,vif.ADR_O,vif.DAT_O,vif.DAT_I),UVM_LOW);
      end 
  endtask
  
endclass

