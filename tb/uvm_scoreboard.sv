class usb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(usb_scoreboard)
  
  uvm_tlm_analysis_fifo #(wb_master_sequence_item) fifo_wb_master;
  
  wb_master_sequence_item mst_seq;

 
  bit [31:0] sc_mem1[33000 : 0];
  
  wb_master_sequence_item mst_que[$];
  
  int unsigned temp1 ;
   
  function new(string name = "usb_scoreboard", uvm_component parent);
    super.new(name,parent);
	fifo_wb_master =new("fifo_wb_master",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
	forever
          begin
            fifo_wb_master.get(mst_seq);
            mst_que.push_back(mst_seq);
            checkr();
          end
     endtask

 
  task checkr();  
    mst_seq = mst_que.pop_front();
    
    if(mst_seq.WE_O == 1)
      begin
        sc_mem1[mst_seq.ADR_O] = mst_seq.DAT_O;
      end
    else if(mst_seq.WE_O == 0)
      begin
        #10 
        temp1 = mst_seq.DAT_I;
        if(sc_mem1[mst_seq.ADR_O] == temp1)
          begin
            `uvm_info(get_type_name(),$sformatf("Expected value=%0d Actual value=%0d",sc_mem1[mst_seq.ADR_O],temp1),UVM_LOW)
                  `uvm_info("TEST STATUS = PASS","******TEST PASSED******\n",UVM_LOW)
          end
        else
          begin
            `uvm_info(get_type_name(),$sformatf("Expected value=%0d Actual value=%0d",sc_mem1[mst_seq.ADR_O],temp1),UVM_LOW)
             `uvm_error("TEST STATUS = FAIL","******TEST FAILED******\n")
          end
      end 
  endtask

endclass
