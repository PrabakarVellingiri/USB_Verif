class wb_slave_driver extends uvm_driver #(wb_slave_sequence_item);

  `uvm_component_utils(wb_slave_driver)

	 virtual wb_interface vif;
  bit [31:0]mem[33000 : 0];
 
    function new (string name = "wb_slave_driver", uvm_component parent);
        super.new (name, parent);
    endfunction

  function void build_phase (uvm_phase phase);
	super.build_phase(phase);
    if(!(uvm_config_db#(virtual wb_interface)::get(this,"","vif",vif)))
      begin
        `uvm_fatal("No vif",$sformatf("No vif in config db"))
      end
  endfunction

task run_phase(uvm_phase phase);

        forever 
          begin
            wait(vif.RST_I == 1'b1);
            seq_item_port.get_next_item(req); 
            drive();
            seq_item_port.item_done();
               
        end
endtask

  task drive();
    begin
      
      @(posedge vif.CLK_I)
      vif.CYC_I = vif.CYC_O;
      vif.STB_I = vif.STB_O;
      vif.ADR_I = vif.ADR_O;
      vif.SEL_I = vif.SEL_O;
      if(vif.WE_I == 1'b1 && vif.CYC_I ==1 && vif.STB_I ==1) 
        begin
          vif.DAT_I = vif.DAT_O;
          mem[vif.ADR_I] = vif.DAT_I;
          
          vif.ACK_O = 1'b1;
          vif.ACK_I = vif.ACK_O;
        end
      else if(vif.WE_I == 1'b0 && vif.CYC_I ==1 && vif.STB_I ==1) 
        begin
          vif.DAT_O = mem[vif.ADR_I];
          vif.DAT_I = vif.DAT_O;
          vif.ACK_O = 1'b1;
          vif.ACK_I = vif.ACK_O;
        end
     
    end
  endtask
  
endclass
