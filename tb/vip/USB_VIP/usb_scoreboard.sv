class usb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(usb_scoreboard)

  uvm_tlm_analysis_fifo#(usb_packet)fifo_export;

 
 //bit [31:0] mem[0:256];
 int temp;
 
 function new(string name="usb_scoreboard",uvm_component parent =null);
    super.new(name,parent);
    fifo_export=new("fifo_export",this);
  endfunction

virtual task run_phase(uvm_phase phase);
    usb_packet usb_item;
        forever
          begin
            fifo_export.get(usb_item);
           // qu.push_back( sb_item);
            
           // sb_item = qu.pop_front();
            temp =usb_item.data ;
            if(vif.mon_cb.DataOut == temp)
        `uvm_info("scoreboard:","---Test passed---",UVM_NONE)
      else
        begin
          `uvm_error("scoreboard","---Test fail---")
          `uvm_info("TEST FAIL",$sformatf("expected output %d",vif.mon_cb.DataOut),UVM_NONE)
          `uvm_info("TEST FAIL",$sformatf("actual output %d",usb_item.data),UVM_NONE)
        end
    end
  endtask
endclass

            
