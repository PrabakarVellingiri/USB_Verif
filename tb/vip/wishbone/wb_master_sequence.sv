class wb_mas_write_seq extends uvm_sequence#(wb_master_sequence_item);
  `uvm_object_utils(wb_mas_write_seq)
  
  function new(string name="wb_mas_write_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    begin
      repeat(1)
        begin
        req=wb_master_sequence_item::type_id::create("req");
          wait_for_grant();
          req.randomize() with {req.WE_O==1'b1;req.SEL_O==15;req.CYC_O==1'b1;req.DAT_O==32'hF;req.ADR_O==32'h8;};
          send_request(req);
          wait_for_item_done();
        end
    end
  endtask
  
endclass

class wb_mas_read_seq extends uvm_sequence#(wb_master_sequence_item);
  `uvm_object_utils(wb_mas_read_seq)
  
  function new(string name="wb_mas_read_seq");
    super.new(name);
  endfunction
  
  virtual task body();
      begin
        repeat(1)
          begin
        req=wb_master_sequence_item::type_id::create("req");
          wait_for_grant();
            req.randomize() with {req.WE_O==1'b0;req.SEL_O==15;req.CYC_O==1'b1;req.ADR_O==32'h8;};
          send_request(req);
          wait_for_item_done();
          end
      end
  endtask
  
  
endclass


