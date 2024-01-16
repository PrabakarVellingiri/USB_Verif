bit [31:0]temp;
class wb_mas_write_seq extends uvm_sequence#(wb_master_sequence_item);
  `uvm_object_utils(wb_mas_write_seq)
  
  rand bit [31:0]addr_wt;
  
  constraint addr_cwt{addr_wt inside {32'h4,32'h8,32'h40,32'h48,32'h4c,32'h50,32'h58,32'h5c,32'h60,32'h68,32'h6c,32'h70,32'h78,32'h7c};}
  
  function new(string name="wb_mas_write_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    begin
      repeat(1)
        begin
        req=wb_master_sequence_item::type_id::create("req");
          wait_for_grant();
          req.randomize() with {req.WE_O==1'b1;req.SEL_O==15;req.CYC_O==1'b1;req.DAT_O==32'hF;req.ADR_O==addr_wt;};
          temp=req.ADR_O;
          send_request(req);
          wait_for_item_done();
        end
    end
  endtask
  
endclass

class wb_mas_read_seq extends uvm_sequence#(wb_master_sequence_item);
  `uvm_object_utils(wb_mas_read_seq)
  
  rand bit [31:0]addr_rt;
  
  
  function new(string name="wb_mas_read_seq");
    super.new(name);
  endfunction
  
  virtual task body();
      begin
        repeat(1)
          begin
        req=wb_master_sequence_item::type_id::create("req");
          wait_for_grant();
           
            req.randomize() with {req.WE_O==1'b0;req.SEL_O==15;req.CYC_O==1'b1;req.ADR_O==temp;};
            
          send_request(req);
          wait_for_item_done();
          end
      end
  endtask
  
  
endclass

//ep0 address = 32'h40;
//ep1 address = 32'h50;
//ep2 address = 32'h60;
//ep3 address = 32'h70;
//ep4 address = 32'h80;
//ep5 address = 32'h90;
//ep6 address = 32'ha0;
//ep7 address = 32'hb0;
//ep8 address = 32'hc0;
//ep9 address = 32'hd0;
//ep10 address = 32'he0;
//ep11 address = 32'hf0;
//ep12 address = 32'h100;
//ep13 address = 32'h200;
//ep14 address = 32'h300;
//ep15 address = 32'h400;
