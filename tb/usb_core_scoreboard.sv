class usb_core_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(usb_core_scoreboard)
  virtual wb_interface vif;
  uvm_analysis_imp #(wb_master_sequence_item,usb_core_scoreboard) scb_get_port;
  wb_master_sequence_item storage_qu[$];
  bit [31:0] sc_mem[33000 : 0];
  bit flag;
  function new(string name = "usb_core_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_get_port=new("scb_get_port",this);
    if(!(uvm_config_db#(virtual wb_interface)::get(this,"","w_vif",vif)))
      begin
        `uvm_fatal("No vif",$sformatf("No vif in config db"))
      end
    uvm_config_db#(bit)::get(this,"","flag",flag);
  endfunction
 
  virtual function write(wb_master_sequence_item trans);
    storage_qu.push_back(trans);
  endfunction
  virtual task run_phase(uvm_phase phase);
    begin
      forever
        begin
          if(flag==1)
            begin
              wb_master_sequence_item temp;
          wait(storage_qu.size()>0);
          temp=storage_qu.pop_front();
              if(temp.DAT_I==32'h0 || temp.DAT_I==32'hFFFF_FFFF)
                begin
                  `uvm_info(get_type_name(),$sformatf("Address = %h Actual value = %h",temp.ADR_O,temp.DAT_I),UVM_LOW)
                  `uvm_info(get_type_name(),"******TEST PASSED******\n",UVM_LOW)
                end
              else
                begin
                  `uvm_info(get_type_name(),$sformatf("Address = %h Actual value = %h",temp.ADR_O,temp.DAT_I),UVM_LOW)
                  `uvm_error(get_type_name(),"******TEST FAILED******\n")
                end
            end
          else
            begin
          wb_master_sequence_item temp;
          wait(storage_qu.size()>0);
          temp=storage_qu.pop_front();
          if(temp.WE_O==1'b1)
            begin
              sc_mem[temp.ADR_O]=temp.DAT_O;
            end
          else if(temp.WE_O==1'b0)
            begin
              if(sc_mem[temp.ADR_O]==temp.DAT_I)
                begin
                  `uvm_info(get_type_name(),$sformatf("Address = %h Expected value = %h Actual value = %h",temp.ADR_O,sc_mem[temp.ADR_O],temp.DAT_I),UVM_LOW)
                  `uvm_info(get_type_name(),"******TEST PASSED******\n",UVM_LOW)
                end
              else
                begin
                  `uvm_info(get_type_name(),$sformatf("Address = %h Expected value = %h Actual value = %h",temp.ADR_O,sc_mem[temp.ADR_O],temp.DAT_I),UVM_LOW)
                  `uvm_error(get_type_name(),"******TEST FAILED******\n")
                end
            end
            end
        end
    end
  endtask
endclass
has context menu
Compose
